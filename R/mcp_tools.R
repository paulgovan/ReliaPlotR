#' Launch a ReliaPlotR MCP Server.
#'
#' Starts a Model Context Protocol (MCP) server that exposes five reliability
#' analysis tools to MCP clients such as Claude Code and Claude Desktop.
#'
#' \describe{
#'   \item{`fit_weibull`}{Fits a Weibull or lognormal distribution to
#'     time-to-failure data (optionally with right-censored suspensions) and
#'     returns parameter estimates and goodness-of-fit metrics.}
#'   \item{`fit_alt`}{Fits an Accelerated Life Test (ALT) model across
#'     multiple stress levels and returns per-stress-level parameters and the
#'     global life-stress relationship coefficients.}
#'   \item{`plot_weibull`}{Fits a Weibull or lognormal distribution and returns
#'     a Weibull probability plot as a plotly JSON string.}
#'   \item{`plot_alt`}{Fits an ALT model and returns probability and life-stress
#'     relationship plots as plotly JSON strings.}
#'   \item{`plot_rga`}{Fits a Crow-AMSAA reliability growth model and returns a
#'     cumulative failure plot as a plotly JSON string.}
#' }
#'
#' @param ... Additional arguments passed to [mcptools::mcp_server()], such as
#'   `type = "stdio"` (default) or `type = "http"`.
#' @return Called for its side effect of launching a blocking MCP server
#'   process.
#' @details
#' Both `mcptools` (>= 0.2.0) and `ellmer` must be installed. They are listed
#' in `Suggests` and are not automatically installed with ReliaPlotR.
#' `jsonlite` is also required for the `fit_alt` tool.
#'
#' **Registering with Claude Code:**
#' ```bash
#' claude mcp add -s user reliapltr -- \
#'   Rscript -e "ReliaPlotR::reliapltr_mcp_server()"
#' ```
#'
#' Alternatively, use the bundled launcher script:
#' ```bash
#' claude mcp add -s user reliapltr -- \
#'   Rscript /path/to/ReliaPlotR/mcp/server.R
#' ```
#' @export
reliapltr_mcp_server <- function(...) {
  .check_mcp_deps()
  tools <- list(
    .make_wblr_tool(),
    .make_alt_tool(),
    .make_plot_wblr_tool(),
    .make_plot_alt_tool(),
    .make_plot_rga_tool()
  )
  mcptools::mcp_server(tools = tools, ...)
}

# --------------------------------------------------------------------------- #
# Internal helpers                                                             #
# --------------------------------------------------------------------------- #

.check_mcp_deps <- function() {
  missing <- character(0)
  if (!requireNamespace("mcptools", quietly = TRUE)) missing <- c(missing, "mcptools")
  if (!requireNamespace("ellmer",   quietly = TRUE)) missing <- c(missing, "ellmer")
  if (length(missing) > 0) {
    stop(
      "The following packages are required to run the MCP server but are not installed: ",
      paste(missing, collapse = ", "), ". ",
      "Install them with: pak::pak(c('mcptools', 'ellmer'))",
      call. = FALSE
    )
  }
  invisible(NULL)
}

.make_wblr_tool <- function() {
  ellmer::tool(
    fun = function(failures,
                   suspensions = NULL,
                   dist        = "weibull",
                   method_fit  = "mle",
                   method_conf = "lrb") {

      # lrb confidence bounds require MLE; fall back to Fisher-matrix for RR
      if (!identical(method_fit, "mle") && identical(method_conf, "lrb")) {
        method_conf <- "fm"
      }

      obj <- WeibullR::wblr(failures, suspensions)
      obj <- WeibullR::wblr.fit(obj, dist = dist, method.fit = method_fit)
      obj <- tryCatch(
        WeibullR::wblr.conf(obj, method.conf = method_conf),
        error = function(e) obj   # return un-conf'd object if bounds fail
      )

      est <- tidy_wblr(obj)$estimates
      as.list(est[1L, , drop = FALSE])
    },
    name = "fit_weibull",
    description = paste(
      "Fit a Weibull or lognormal distribution to time-to-failure data.",
      "Returns distribution parameters (Beta and Eta for Weibull;",
      "Mulog and Sigmalog for lognormal), a goodness-of-fit metric (R-squared",
      "for rank regression, log-likelihood for MLE), and the number of failures.",
      "Optionally accepts right-censored suspension times."
    ),
    arguments = list(
      failures    = ellmer::type_array(
        ellmer::type_number(),
        description = "Failure times as positive numbers, e.g. [30, 49, 82, 90, 96]."
      ),
      suspensions = ellmer::type_array(
        ellmer::type_number(),
        description = paste(
          "Right-censored (suspension) times -- units still running at end of test.",
          "Optional. Omit if there are no suspensions."
        ),
        required = FALSE
      ),
      dist = ellmer::type_string(
        description = paste(
          "Distribution to fit:",
          "'weibull' (2-parameter Weibull, default),",
          "'lognormal', or 'weibull3p' (3-parameter Weibull)."
        )
      ),
      method_fit = ellmer::type_string(
        description = paste(
          "Parameter estimation method:",
          "'mle' (maximum likelihood, default) or 'rr-xony' (rank regression).",
          "MLE is preferred for censored data."
        )
      ),
      method_conf = ellmer::type_string(
        description = paste(
          "Confidence bound method:",
          "'lrb' (likelihood-ratio bounds, default, requires MLE) or",
          "'fm' (Fisher-matrix bounds).",
          "Automatically set to 'fm' if rank regression is selected."
        )
      )
    )
  )
}

.make_alt_tool <- function() {
  ellmer::tool(
    fun = function(stresses,
                   failures_json,
                   dist      = "weibull",
                   alt_model = "arrhenius") {

      if (!requireNamespace("jsonlite", quietly = TRUE)) {
        stop("Package 'jsonlite' is required for fit_alt. ",
             "Install with: install.packages('jsonlite')", call. = FALSE)
      }

      failures_list <- jsonlite::fromJSON(failures_json)
      if (!is.list(failures_list)) {
        # fromJSON may return a matrix for regular-length arrays; coerce to list
        failures_list <- lapply(seq_len(nrow(failures_list)),
                                function(i) as.numeric(failures_list[i, ]))
      }

      if (length(stresses) != length(failures_list)) {
        stop("'stresses' and 'failures_json' must have the same number of entries.",
             call. = FALSE)
      }

      data_list <- mapply(
        function(s, f) WeibullR.ALT::alt.data(as.numeric(f), stress = s),
        stresses, failures_list,
        SIMPLIFY = FALSE
      )

      obj <- WeibullR.ALT::alt.make(data_list, dist = dist,
                                    alt.model = alt_model,
                                    view_dist_fits = FALSE)
      obj <- WeibullR.ALT::alt.parallel(obj, view_parallel_fits = FALSE)
      obj <- WeibullR.ALT::alt.fit(obj)

      result <- tidy_alt(obj)
      list(
        parallel     = result$parallel,
        relationship = as.list(result$relationship[1L, ])
      )
    },
    name = "fit_alt",
    description = paste(
      "Fit an Accelerated Life Test (ALT) model across multiple stress levels.",
      "Returns per-stress-level distribution parameters (P1 = characteristic life,",
      "P2 = shape parameter) and the global life-stress relationship coefficients",
      "(Arrhenius or Power Law).",
      "Requires at least two stress levels with failure data."
    ),
    arguments = list(
      stresses = ellmer::type_array(
        ellmer::type_number(),
        description = paste(
          "Stress values, one per stress level.",
          "Example: [300, 350, 400] for three temperature stress levels in Kelvin."
        )
      ),
      failures_json = ellmer::type_string(
        description = paste(
          "JSON string encoding an array of failure-time arrays, one inner array",
          "per stress level (must match the length of stresses).",
          "Example: '[[248,456,528,731],[164,176,289],[88,112,152]]'",
          "for three stress levels with 4, 3, and 3 failures respectively."
        )
      ),
      dist = ellmer::type_string(
        description = "Life distribution: 'weibull' (default) or 'lognormal'."
      ),
      alt_model = ellmer::type_string(
        description = paste(
          "Life-stress relationship model:",
          "'arrhenius' (default, for temperature stress) or",
          "'power' (inverse power law, for non-thermal stress)."
        )
      )
    )
  )
}

.make_plot_wblr_tool <- function() {
  ellmer::tool(
    fun = function(failures,
                   suspensions = NULL,
                   dist        = "weibull",
                   method_fit  = "mle",
                   method_conf = "lrb",
                   show_conf   = TRUE) {

      if (!identical(method_fit, "mle") && identical(method_conf, "lrb")) {
        method_conf <- "fm"
      }

      obj <- WeibullR::wblr(failures, suspensions)
      obj <- WeibullR::wblr.fit(obj, dist = dist, method.fit = method_fit)
      obj <- tryCatch(
        WeibullR::wblr.conf(obj, method.conf = method_conf),
        error = function(e) obj
      )

      fig <- plotly_wblr(obj, showConf = show_conf)
      plotly:::to_JSON(plotly::plotly_build(fig)$x)
    },
    name = "plot_weibull",
    description = paste(
      "Fit a Weibull or lognormal distribution and return an interactive",
      "Weibull probability plot as a plotly JSON string.",
      "The JSON can be saved as HTML or rendered in any plotly-compatible viewer.",
      "Optionally accepts right-censored suspension times."
    ),
    arguments = list(
      failures    = ellmer::type_array(
        ellmer::type_number(),
        description = "Failure times as positive numbers, e.g. [30, 49, 82, 90, 96]."
      ),
      suspensions = ellmer::type_array(
        ellmer::type_number(),
        description = paste(
          "Right-censored (suspension) times -- units still running at end of test.",
          "Optional. Omit if there are no suspensions."
        ),
        required = FALSE
      ),
      dist = ellmer::type_string(
        description = paste(
          "Distribution to fit:",
          "'weibull' (2-parameter Weibull, default),",
          "'lognormal', or 'weibull3p' (3-parameter Weibull)."
        )
      ),
      method_fit = ellmer::type_string(
        description = paste(
          "Parameter estimation method:",
          "'mle' (maximum likelihood, default) or 'rr-xony' (rank regression)."
        )
      ),
      method_conf = ellmer::type_string(
        description = paste(
          "Confidence bound method:",
          "'lrb' (likelihood-ratio bounds, default, requires MLE) or",
          "'fm' (Fisher-matrix bounds)."
        )
      ),
      show_conf = ellmer::type_boolean(
        description = "Whether to show confidence bounds on the plot. Default TRUE."
      )
    )
  )
}

.make_plot_alt_tool <- function() {
  ellmer::tool(
    fun = function(stresses,
                   failures_json,
                   dist      = "weibull",
                   alt_model = "arrhenius") {

      failures_list <- jsonlite::fromJSON(failures_json)
      if (!is.list(failures_list)) {
        failures_list <- lapply(seq_len(nrow(failures_list)),
                                function(i) as.numeric(failures_list[i, ]))
      }

      if (length(stresses) != length(failures_list)) {
        stop("'stresses' and 'failures_json' must have the same number of entries.",
             call. = FALSE)
      }

      data_list <- mapply(
        function(s, f) WeibullR.ALT::alt.data(as.numeric(f), stress = s),
        stresses, failures_list,
        SIMPLIFY = FALSE
      )

      obj <- WeibullR.ALT::alt.make(data_list, dist = dist,
                                    alt.model = alt_model,
                                    view_dist_fits = FALSE)
      obj <- WeibullR.ALT::alt.parallel(obj, view_parallel_fits = FALSE)
      obj <- WeibullR.ALT::alt.fit(obj)

      fig_prob <- plotly_alt(obj)
      fig_rel  <- plotly_rel(obj)

      to_json <- function(fig) {
        plotly:::to_JSON(plotly::plotly_build(fig)$x)
      }

      list(
        probability_plot = to_json(fig_prob),
        life_stress_plot = to_json(fig_rel)
      )
    },
    name = "plot_alt",
    description = paste(
      "Fit an Accelerated Life Test (ALT) model and return two interactive plots",
      "as plotly JSON strings: a probability plot (one fitted line per stress level)",
      "and a life-stress relationship plot.",
      "Both JSON strings can be saved as HTML or rendered in a plotly-compatible viewer."
    ),
    arguments = list(
      stresses = ellmer::type_array(
        ellmer::type_number(),
        description = paste(
          "Stress values, one per stress level.",
          "Example: [300, 350, 400] for three temperature stress levels in Kelvin."
        )
      ),
      failures_json = ellmer::type_string(
        description = paste(
          "JSON string encoding an array of failure-time arrays, one inner array",
          "per stress level (must match the length of stresses).",
          "Example: '[[248,456,528,731],[164,176,289],[88,112,152]]'"
        )
      ),
      dist = ellmer::type_string(
        description = "Life distribution: 'weibull' (default) or 'lognormal'."
      ),
      alt_model = ellmer::type_string(
        description = paste(
          "Life-stress relationship model:",
          "'arrhenius' (default, for temperature stress) or",
          "'power' (inverse power law, for non-thermal stress)."
        )
      )
    )
  )
}

.make_plot_rga_tool <- function() {
  ellmer::tool(
    fun = function(times,
                   failures,
                   times_type = "failure_times",
                   method     = "LS",
                   show_conf  = TRUE) {

      obj <- ReliaGrowR::rga(times, failures,
                              times_type = times_type,
                              method     = method)
      fig <- plotly_rga(obj, showConf = show_conf)
      plotly:::to_JSON(plotly::plotly_build(fig)$x)
    },
    name = "plot_rga",
    description = paste(
      "Fit a Crow-AMSAA reliability growth model (Power Law NHPP) and return",
      "an interactive cumulative failure plot as a plotly JSON string.",
      "The JSON can be saved as HTML or rendered in any plotly-compatible viewer."
    ),
    arguments = list(
      times = ellmer::type_array(
        ellmer::type_number(),
        description = paste(
          "Failure times or cumulative failure times (positive numbers).",
          "Interpretation depends on times_type."
        )
      ),
      failures = ellmer::type_array(
        ellmer::type_number(),
        description = "Number of failures at each corresponding time in 'times'."
      ),
      times_type = ellmer::type_string(
        description = paste(
          "Interpretation of 'times':",
          "'failure_times' (default, individual failure times) or",
          "'cumulative_failure_times' (cumulative time at each failure)."
        )
      ),
      method = ellmer::type_string(
        description = paste(
          "Parameter estimation method:",
          "'LS' (least squares, default) or 'MLE' (maximum likelihood)."
        )
      ),
      show_conf = ellmer::type_boolean(
        description = "Whether to show confidence bounds on the plot. Default TRUE."
      )
    )
  )
}
