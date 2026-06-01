# Grader: parse agent JSON answers and score against the frozen ground truth.
# Sourced by run_pilot.R.

suppressMessages(library(jsonlite))

DEFAULT_TOL <- 0.05   # relative error tolerance per field unless overridden

# Pull the last JSON object out of a free-text response.
extract_answer <- function(text) {
  if (is.na(text) || !nzchar(text)) return(NULL)
  # Find all {...} candidates; prefer the last parseable one.
  starts <- gregexpr("\\{", text)[[1]]
  ends   <- gregexpr("\\}", text)[[1]]
  if (starts[1] == -1 || ends[1] == -1) return(NULL)
  cand <- NULL
  for (s in rev(starts)) {
    e <- ends[ends > s]
    if (!length(e)) next
    blob <- substr(text, s, max(e))
    parsed <- tryCatch(jsonlite::fromJSON(blob), error = function(err) NULL)
    if (is.list(parsed) && length(parsed)) { cand <- parsed; break }
  }
  cand
}

# Relative error pass test (handles ground truth near zero via absolute floor).
field_pass <- function(got, truth, tol) {
  if (is.null(got) || length(got) != 1 || is.na(got)) return(FALSE)
  got <- suppressWarnings(as.numeric(got))
  if (is.na(got)) return(FALSE)
  denom <- max(abs(truth), 1e-8)
  abs(got - truth) / denom < tol
}

grade_run <- function(run, problem, truth) {
  ans <- extract_answer(run$response)
  keys <- problem$answer_key
  tol_overrides <- if (!is.null(problem$tol)) problem$tol else c()

  passed <- 0L
  detail <- character(0)
  for (k in keys) {
    tol <- if (k %in% names(tol_overrides)) tol_overrides[[k]] else DEFAULT_TOL
    got <- if (!is.null(ans) && k %in% names(ans)) ans[[k]] else NULL
    ok  <- field_pass(got, truth[[k]], tol)
    passed <- passed + as.integer(ok)
    detail <- c(detail, sprintf("%s=%s[%s]", k,
                  if (is.null(got)) "NA" else format(got, digits = 5),
                  if (ok) "ok" else "X"))
  }
  data.frame(
    problem      = run$id,
    domain       = run$domain,
    condition    = run$condition,
    provider     = run$provider,
    model        = run$model,
    fields_passed = passed,
    n_fields      = length(keys),
    problem_pass  = passed == length(keys),
    n_tool_calls  = run$n_tool_calls,
    error         = isTRUE(run$error),
    detail        = paste(detail, collapse = " "),
    tool_names    = run$tool_names,
    stringsAsFactors = FALSE
  )
}
