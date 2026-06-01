# Generate the frozen answer key by running canonical R pipelines.
# Run from the repo root:  Rscript benchmark/make_ground_truth.R
#
# Output: benchmark/ground_truth.json  (one entry per problem id)

# Load ReliaPlotR (prefer installed; fall back to local source tree).
if (!requireNamespace("ReliaPlotR", quietly = TRUE) ||
    !exists("tidy_wblr", where = asNamespace("ReliaPlotR"))) {
  suppressMessages(devtools::load_all(".", quiet = TRUE))
} else {
  suppressMessages(library(ReliaPlotR))
}
suppressMessages(library(jsonlite))

here <- function(...) file.path("benchmark", ...)
source(here("problems.R"))

truth <- list()
for (p in PROBLEMS) {
  message("Computing ground truth: ", p$id)
  vals <- tryCatch(p$truth_fun(), error = function(e) {
    stop("truth_fun failed for ", p$id, ": ", conditionMessage(e))
  })
  # Coerce to plain numeric named list
  vals <- lapply(vals, function(x) as.numeric(x))
  missing <- setdiff(p$answer_key, names(vals))
  if (length(missing)) {
    stop("Problem ", p$id, " is missing answer-key fields: ",
         paste(missing, collapse = ", "))
  }
  truth[[p$id]] <- vals
}

out <- here("ground_truth.json")
write_json(truth, out, auto_unbox = TRUE, pretty = TRUE, digits = 10)
message("Wrote ", out, " (", length(truth), " problems)")

# Echo a compact summary table.
for (id in names(truth)) {
  fields <- truth[[id]]
  cat(sprintf("  %-18s %s\n", id,
              paste(sprintf("%s=%.5g", names(fields), unlist(fields)),
                    collapse = "  ")))
}
