#' Extract Tidy Parameter Estimates from a wblr Object.
#'
#' Returns a tidy data frame of distribution parameter estimates, goodness-of-fit
#' metrics, and (optionally) confidence bound data from one or more fitted `wblr`
#' objects. This makes it straightforward to use ReliaPlotR output in reproducible
#' research workflows — export to CSV, include in tables, or compare multiple fits.
#'
#' @param wblr_obj A single object of class `'wblr'`, or a list of such objects.
#'   Each object must have been fitted with [WeibullR::wblr.fit()].
#' @return A named list with two elements:
#'   \describe{
#'     \item{`estimates`}{A `data.frame` with one row per `wblr` object and
#'       columns `dist`, `method_fit`, `param1_name`, `param1`, `param2_name`,
#'       `param2`, `param3_name`, `param3`, `gof_metric`, `gof_value`,
#'       `method_conf`, `n_failures`.}
#'     \item{`bounds`}{For a single object, a `data.frame` of confidence bound
#'       data (columns `Datum`, `unrel`, `Lower`, `Upper`), or `NULL` if no
#'       confidence bounds were computed. For a list of objects, a list of such
#'       data frames (one per object).}
#'   }
#' @details
#' Parameters are returned on their natural scales. For Weibull and
#' three-parameter Weibull (\code{weibull3p}) models, \code{param1} is the
#' shape parameter \eqn{\beta} and \code{param2} is the scale parameter
#' \eqn{\eta}; \code{param3} is the location parameter \eqn{\gamma} for
#' \code{weibull3p} (NA otherwise). For lognormal models, \code{param1} is
#' \eqn{\mu_{log}} and \code{param2} is \eqn{\sigma_{log}}.
#'
#' Goodness-of-fit is reported as R\eqn{^2} (column value \code{"R2"}) for
#' rank-regression fits, or log-likelihood (\code{"loglikelihood"}) for MLE
#' fits.
#' @references
#' Meeker, W. Q., and Escobar, L. A. (1998). \emph{Statistical Methods for
#' Reliability Data}. Wiley.
#' @seealso [plotly_wblr()] for the corresponding interactive probability plot.
#' @examples
#' library(WeibullR)
#' failures <- c(30, 49, 82, 90, 96)
#' obj <- wblr.conf(wblr.fit(wblr(failures), method.fit = "mle"), method.conf = "lrb")
#' result <- tidy_wblr(obj)
#' result$estimates
#' result$bounds
#'
#' # List of objects
#' obj2 <- wblr.conf(wblr.fit(wblr(c(20, 40, 60, 80, 100)), method.fit = "mle"),
#'                   method.conf = "lrb")
#' result2 <- tidy_wblr(list(obj, obj2))
#' result2$estimates
#' @import WeibullR
#' @export

tidy_wblr <- function(wblr_obj) {
  if (!is.list(wblr_obj) || inherits(wblr_obj, "wblr")) {
    wblr_obj <- list(wblr_obj)
  }

  if (length(wblr_obj) == 0) {
    stop("Argument 'wblr_obj' is not of class 'wblr'.")
  }
  lapply(wblr_obj, function(obj) {
    if (!inherits(obj, "wblr")) stop("All inputs must be of class 'wblr'.")
  })

  extract_one <- function(obj) {
    fit <- obj$fit[[1]]
    if (is.null(fit)) stop("wblr object has not been fitted. Run wblr.fit() first.")

    vec        <- as.numeric(fit$fit_vec)
    dist       <- fit$options$dist
    method_fit <- fit$options$method.fit

    if (dist == "lognormal") {
      p1_name <- "Mulog";    p1 <- vec[1]
      p2_name <- "Sigmalog"; p2 <- vec[2]
      p3_name <- NA_character_; p3 <- NA_real_
    } else if (dist %in% c("weibull", "weibull3p")) {
      p1_name <- "Beta"; p1 <- vec[2]
      p2_name <- "Eta";  p2 <- vec[1]
      if (dist == "weibull3p" && length(vec) >= 3) {
        p3_name <- "Gamma"; p3 <- vec[3]
      } else {
        p3_name <- NA_character_; p3 <- NA_real_
      }
    } else {
      stop("Unsupported distribution: ", dist)
    }

    gof <- fit$gof
    if (!is.null(method_fit) && method_fit == "rr-xony") {
      gof_metric <- "R2";            gof_value <- gof$r2
    } else if (!is.null(method_fit) && method_fit == "mle") {
      gof_metric <- "loglikelihood"; gof_value <- gof$loglik
    } else {
      gof_metric <- NA_character_;   gof_value <- NA_real_
    }

    method_conf <- tryCatch(
      fit$conf[[1]]$options$method.conf,
      error = function(e) NA_character_
    )
    if (is.null(method_conf)) method_conf <- NA_character_

    n_failures <- if (isTRUE(obj$interval == 0)) {
      length(obj$data$dpoints$time)
    } else {
      nrow(obj$data$dlines)
    }

    data.frame(
      dist        = dist,
      method_fit  = if (is.null(method_fit)) NA_character_ else method_fit,
      param1_name = p1_name, param1 = p1,
      param2_name = p2_name, param2 = p2,
      param3_name = p3_name, param3 = p3,
      gof_metric  = gof_metric, gof_value = gof_value,
      method_conf = method_conf,
      n_failures  = n_failures,
      stringsAsFactors = FALSE
    )
  }

  estimates <- do.call(rbind, lapply(wblr_obj, extract_one))
  rownames(estimates) <- NULL

  bounds_list <- lapply(wblr_obj, function(obj) {
    tryCatch(obj$fit[[1]]$conf[[1]]$bounds, error = function(e) NULL)
  })

  bounds <- if (length(wblr_obj) == 1) bounds_list[[1]] else bounds_list

  list(estimates = estimates, bounds = bounds)
}
