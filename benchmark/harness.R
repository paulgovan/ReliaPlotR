# Harness: drive ellmer chats across conditions x models for each problem.
# Sourced by run_pilot.R. Requires ellmer (>= 0.4.0) and API keys in the env.
#
# Conditions:
#   C1  LLM alone        - no tools; model must reason/compute from raw data.
#   C3  tool-augmented   - ReliaPlotR/ReliaGrowR fitting tools registered.
#   C2  LLM + code        - optional, OFF by default (executes model-written R;
#                          enable with PILOT_ENABLE_C2=1 only in a trusted env).
#
# Output: appends one JSON line per run to benchmark/responses.jsonl

suppressMessages({
  library(ellmer)
  library(jsonlite)
})

# ----- tool builders for domains not covered by ReliaPlotR's MCP tools -------
# These mirror what ReliaGrowR's own MCP server exposes, kept inline so the
# pilot is self-contained.

.make_rga_tool <- function() {
  ellmer::tool(
    function(times, failures, method = "LS") {
      obj <- ReliaGrowR::rga(times, failures, method = method)
      p <- ReliaPlotR::tidy_rga(obj)$params
      list(lambda = p$lambda, beta = p$beta)
    },
    name = "fit_rga",
    description = paste(
      "Fit a Crow-AMSAA (Power Law NHPP) reliability growth model and return",
      "the scale parameter lambda and shape parameter beta."
    ),
    arguments = list(
      times = ellmer::type_array(ellmer::type_number(),
        description = "Cumulative test times at which failures were observed."),
      failures = ellmer::type_array(ellmer::type_number(),
        description = "Number of failures at each corresponding time."),
      method = ellmer::type_string(
        description = "Estimation method: 'LS' (default) or 'MLE'.", required = FALSE)
    )
  )
}

.make_duane_tool <- function() {
  ellmer::tool(
    function(times, cum_failures) {
      mtbf <- times / cum_failures
      fit <- stats::lm(log(mtbf) ~ log(times))
      list(intercept = unname(stats::coef(fit)[1]),
           slope     = unname(stats::coef(fit)[2]))
    },
    name = "fit_duane",
    description = paste(
      "Fit a Duane reliability growth model: linear regression of",
      "log(cumulative MTBF) on log(cumulative time), where cumulative MTBF =",
      "cumulative time / cumulative failures. Returns the slope and intercept."
    ),
    arguments = list(
      times = ellmer::type_array(ellmer::type_number(),
        description = "Cumulative test times (hours)."),
      cum_failures = ellmer::type_array(ellmer::type_number(),
        description = "Cumulative number of failures at each time.")
    )
  )
}

# Map a problem domain to the tool objects offered in condition C3.
tools_for_domain <- function(domain) {
  switch(domain,
    life       = list(ReliaPlotR:::.make_wblr_tool()),
    alt        = list(ReliaPlotR:::.make_alt_tool()),
    growth     = list(.make_rga_tool()),
    repairable = list(.make_duane_tool()),
    list()
  )
}

# ----- chat construction -----------------------------------------------------

new_chat <- function(provider, model, system_prompt) {
  if (provider == "anthropic") {
    ellmer::chat_anthropic(system_prompt = system_prompt, model = model, echo = "none")
  } else if (provider == "openai") {
    ellmer::chat_openai(system_prompt = system_prompt, model = model, echo = "none")
  } else {
    stop("Unknown provider: ", provider)
  }
}

SYSTEM_PROMPT <- paste(
  "You are a reliability engineering assistant. Answer the user's question.",
  "End your reply with a single line containing ONLY a JSON object with the",
  "exact numeric field names requested (no units, no extra keys, no prose on",
  "that line). Example final line: {\"beta\": 2.5, \"eta\": 80.0}"
)

# Count tool-request contents across all assistant turns (version-robust:
# matches any content class whose name mentions a tool request).
count_tool_calls <- function(chat) {
  turns <- tryCatch(chat$get_turns(), error = function(e) list())
  n <- 0L; names_seen <- character(0)
  for (tn in turns) {
    contents <- tryCatch(tn@contents, error = function(e) NULL)
    if (is.null(contents)) next
    for (ct in contents) {
      cls <- paste(class(ct), collapse = ",")
      if (grepl("ToolRequest", cls)) {
        n <- n + 1L
        nm <- tryCatch(ct@name, error = function(e) NA_character_)
        names_seen <- c(names_seen, nm)
      }
    }
  }
  list(n = n, names = names_seen)
}

# ----- single run ------------------------------------------------------------

run_one <- function(problem, condition, provider, model) {
  fields <- paste(problem$answer_key, collapse = ", ")
  user_msg <- paste0(
    problem$prompt, "\n\n",
    "Report these fields in your final JSON line: ", fields, "."
  )

  chat <- new_chat(provider, model, SYSTEM_PROMPT)

  if (condition == "C3") {
    for (tl in tools_for_domain(problem$domain)) chat$register_tool(tl)
  }
  if (condition == "C2") {
    chat$register_tool(.make_code_tool())   # only defined when C2 enabled
  }

  resp <- tryCatch(
    chat$chat(user_msg),
    error = function(e) paste0("__ERROR__: ", conditionMessage(e))
  )
  resp_text <- paste(as.character(resp), collapse = "\n")
  tc <- count_tool_calls(chat)

  list(
    id        = problem$id,
    domain    = problem$domain,
    condition = condition,
    provider  = provider,
    model     = model,
    response  = resp_text,
    n_tool_calls = tc$n,
    tool_names   = paste(tc$names, collapse = ";"),
    error     = startsWith(resp_text, "__ERROR__")
  )
}

# Optional C2 code-execution tool (DISABLED unless PILOT_ENABLE_C2=1).
.make_code_tool <- function() {
  ellmer::tool(
    function(code) {
      val <- eval(parse(text = code), envir = new.env(parent = globalenv()))
      paste(utils::capture.output(print(val)), collapse = "\n")
    },
    name = "run_r",
    description = "Evaluate R code and return its printed output.",
    arguments = list(
      code = ellmer::type_string(description = "R code to evaluate.")
    )
  )
}
