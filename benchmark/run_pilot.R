# Top-level pilot orchestrator.
# Run from the repo root, with API keys exported:
#   ANTHROPIC_API_KEY=...  OPENAI_API_KEY=...  Rscript benchmark/run_pilot.R
#
# Optional env overrides:
#   PILOT_PROVIDERS   comma list, default "anthropic,openai"
#   PILOT_CONDITIONS  comma list, default "C1,C3"  (add C2 only with PILOT_ENABLE_C2=1)
#   ANTHROPIC_MODEL   default "claude-sonnet-4-6"
#   OPENAI_MODEL      default "gpt-4o"
#   PILOT_PROBLEMS    comma list of problem ids to restrict to (default: all)
#
# Outputs: benchmark/responses.jsonl (raw) and benchmark/results.csv (scored).

# --- load package (installed or local source) --------------------------------
if (!requireNamespace("ReliaPlotR", quietly = TRUE) ||
    !exists("tidy_wblr", where = asNamespace("ReliaPlotR"))) {
  suppressMessages(devtools::load_all(".", quiet = TRUE))
} else {
  suppressMessages(library(ReliaPlotR))
}
suppressMessages({ library(jsonlite); library(ReliaGrowR) })

here <- function(...) file.path("benchmark", ...)
source(here("problems.R"))
source(here("harness.R"))
source(here("grade.R"))

# --- config ------------------------------------------------------------------
env_list <- function(name, default) {
  v <- Sys.getenv(name, default)
  trimws(strsplit(v, ",")[[1]])
}
providers  <- env_list("PILOT_PROVIDERS", "anthropic,openai")
conditions <- env_list("PILOT_CONDITIONS", "C1,C3")
if (!identical(Sys.getenv("PILOT_ENABLE_C2"), "1")) {
  conditions <- setdiff(conditions, "C2")
}
model_for <- c(
  anthropic = Sys.getenv("ANTHROPIC_MODEL", "claude-sonnet-4-6"),
  openai    = Sys.getenv("OPENAI_MODEL", "gpt-4o")
)
problem_filter <- Sys.getenv("PILOT_PROBLEMS", "")
problems <- PROBLEMS
if (nzchar(problem_filter)) {
  keep <- trimws(strsplit(problem_filter, ",")[[1]])
  problems <- Filter(function(p) p$id %in% keep, PROBLEMS)
}

truth <- jsonlite::fromJSON(here("ground_truth.json"), simplifyVector = FALSE)

# --- run ---------------------------------------------------------------------
resp_path <- here("responses.jsonl")
if (file.exists(resp_path)) file.remove(resp_path)
resp_con <- file(resp_path, open = "a")

all_rows <- list()
n_total <- length(problems) * length(conditions) * length(providers)
i <- 0L
for (p in problems) {
  for (cond in conditions) {
    for (prov in providers) {
      i <- i + 1L
      model <- unname(model_for[prov])
      message(sprintf("[%d/%d] %s | %s | %s (%s)",
                      i, n_total, p$id, cond, prov, model))
      run <- run_one(p, cond, prov, model)
      writeLines(jsonlite::toJSON(run, auto_unbox = TRUE), resp_con)
      flush(resp_con)
      all_rows[[length(all_rows) + 1]] <- grade_run(run, p, truth[[p$id]])
    }
  }
}
close(resp_con)

results <- do.call(rbind, all_rows)
write.csv(results, here("results.csv"), row.names = FALSE)
message("\nWrote ", here("results.csv"), " (", nrow(results), " runs)")

# --- summary -----------------------------------------------------------------
cat("\n=== Accuracy by condition x provider (problem pass rate) ===\n")
agg <- aggregate(problem_pass ~ condition + provider, data = results, FUN = mean)
agg$problem_pass <- sprintf("%.0f%%", 100 * agg$problem_pass)
print(agg, row.names = FALSE)

cat("\n=== Mean tool calls by condition ===\n")
print(aggregate(n_tool_calls ~ condition, data = results, FUN = mean), row.names = FALSE)

if (any(results$error)) {
  cat("\nNOTE:", sum(results$error), "run(s) errored - see responses.jsonl\n")
}
