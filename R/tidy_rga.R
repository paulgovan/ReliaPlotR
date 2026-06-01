#' Extract Tidy Fitted Values from an rga Object.
#'
#' Returns a tidy data frame of fitted cumulative failure counts, confidence
#' bounds, and (when available) Crow-AMSAA model coefficients from an `rga`
#' object. Suitable for exporting results for use in reproducible research
#' workflows.
#'
#' @param rga_obj An object of class `'rga'`, or a list of such objects. Each
#'   object is created using the [ReliaGrowR::rga()] function.
#' @return A named list with two elements:
#'   \describe{
#'     \item{`fitted`}{For a single object, a `data.frame` with columns
#'       `time`, `cum_failures`, `fitted`, `lower`, `upper`. For a list, a
#'       list of such data frames (one per object).}
#'     \item{`params`}{For a single object, a one-row `data.frame` with columns
#'       `lambda` and `beta` (Crow-AMSAA Power Law parameters), or `NULL` if
#'       the model coefficients cannot be extracted. For a list, a list of such
#'       data frames.}
#'   }
#' @details
#' The Crow-AMSAA (NHPP Power Law) model gives the expected cumulative
#' failures as \eqn{E[N(t)] = \lambda t^\beta}. A \eqn{\beta < 1} indicates
#' reliability growth (decreasing failure rate); \eqn{\beta > 1} indicates
#' degradation. The parameters are recovered from the fitted log-log linear
#' model via \code{coef()}: \eqn{\lambda = \exp(\text{intercept})} and
#' \eqn{\beta} is the slope coefficient.
#' @references
#' Crow, L. H. (1974). Reliability Analysis for Complex Repairable Systems.
#' In \emph{Reliability and Biometry}, SIAM, pp. 379-410.
#' @seealso [plotly_rga()] for the corresponding interactive reliability growth plot.
#' @examples
#' library(ReliaGrowR)
#' times <- c(100, 200, 300, 400, 500)
#' failures <- c(1, 2, 1, 3, 2)
#' obj <- rga(times, failures)
#' result <- tidy_rga(obj)
#' result$fitted
#' result$params
#' @import ReliaGrowR
#' @importFrom stats coef
#' @export

tidy_rga <- function(rga_obj) {
  if (!is.list(rga_obj) || inherits(rga_obj, "rga")) {
    rga_obj <- list(rga_obj)
  }

  if (length(rga_obj) == 0) stop("Argument 'rga_obj' is not of class 'rga'.")
  lapply(rga_obj, function(obj) {
    if (!inherits(obj, "rga")) stop("All inputs must be of class 'rga'.")
  })

  extract_fitted <- function(obj) {
    data.frame(
      time         = exp(obj$model$model$log_times),
      cum_failures = exp(obj$model$model$log_cum_failures),
      fitted       = obj$fitted_values,
      lower        = obj$lower_bounds,
      upper        = obj$upper_bounds,
      stringsAsFactors = FALSE
    )
  }

  extract_params <- function(obj) {
    tryCatch({
      cf <- coef(obj$model)
      data.frame(lambda = exp(cf[1]), beta = cf[2],
                 stringsAsFactors = FALSE, row.names = NULL)
    }, error = function(e) NULL)
  }

  fitted_list <- lapply(rga_obj, extract_fitted)
  params_list <- lapply(rga_obj, extract_params)

  if (length(rga_obj) == 1) {
    list(fitted = fitted_list[[1]], params = params_list[[1]])
  } else {
    list(fitted = fitted_list, params = params_list)
  }
}
