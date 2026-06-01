#' Extract Tidy Parameter Estimates from an alt Object.
#'
#' Returns tidy data frames of per-stress-level parameter estimates and (when
#' available) global life-stress relationship coefficients from a fitted `alt`
#' object. Useful for reporting ALT results in reproducible research workflows.
#'
#' @param alt_obj An object of class `'alt'` created by the `WeibullR.ALT`
#'   package. Must have been processed through [WeibullR.ALT::alt.parallel()].
#'   For `$relationship` to be non-NULL, [WeibullR.ALT::alt.fit()] must also
#'   have been called.
#' @return A named list with two elements:
#'   \describe{
#'     \item{`parallel`}{A `data.frame` with one row per stress level,
#'       containing columns `stress`, `P1`, `P2`, `wt`, and `n_failures`.
#'       For Weibull models, `P1` is the scale parameter \eqn{\eta} and `P2`
#'       is the shape parameter \eqn{\beta}. For lognormal models, `P1` is
#'       \eqn{\mu_{log}} and `P2` is \eqn{\sigma_{log}}.}
#'     \item{`relationship`}{A one-row `data.frame` with columns `model`,
#'       `coef1`, and `coef2` (the global life-stress relationship
#'       coefficients), or `NULL` with a message if `alt.fit()` has not been
#'       called.}
#'   }
#' @details
#' Two life-stress models are supported. For the Arrhenius model,
#' \eqn{\eta = \exp(C_1 + C_2 \cdot S)} where \eqn{S} is stress (typically
#' reciprocal temperature in 1/K). For the Power Law model,
#' \eqn{\eta = \exp(C_1) / S^{|C_2|}}. Both \code{coef1} and \code{coef2}
#' are on the log scale as returned by \code{alt.fit()}.
#' @references
#' Nelson, W. B. (1990). \emph{Accelerated Testing: Statistical Models,
#' Test Plans, and Data Analysis}. Wiley.
#' @seealso [plotly_alt()] for the ALT probability plot,
#'   [plotly_rel()] for the life-stress relationship plot.
#' @examples
#' library(WeibullR.ALT)
#' d1 <- alt.data(c(248, 456, 528, 731, 813, 537), stress = 300)
#' d2 <- alt.data(c(164, 176, 289), stress = 350)
#' d3 <- alt.data(c(88, 112, 152), stress = 400)
#' obj <- alt.fit(
#'   alt.parallel(
#'     alt.make(list(d1, d2, d3), dist = "weibull", alt.model = "arrhenius",
#'              view_dist_fits = FALSE),
#'     view_parallel_fits = FALSE
#'   )
#' )
#' result <- tidy_alt(obj)
#' result$parallel
#' result$relationship
#' @import WeibullR.ALT
#' @export

tidy_alt <- function(alt_obj) {
  if (!inherits(alt_obj, "alt")) {
    stop("Argument 'alt_obj' is not of class 'alt'.")
  }
  if (is.null(alt_obj$parallel_par)) {
    stop("'alt_obj' must be fitted with alt.parallel() before calling tidy_alt().")
  }

  pp <- alt_obj$parallel_par

  n_failures <- vapply(seq_len(nrow(pp)), function(i) {
    stress_i  <- pp$stress[i]
    data_idx  <- which(vapply(alt_obj$data, function(d) d$stress, numeric(1)) == stress_i)
    if (length(data_idx) == 0) return(NA_integer_)
    as.integer(alt_obj$data[[data_idx[1]]]$num_fails)
  }, integer(1))

  parallel_df <- data.frame(
    stress     = pp$stress,
    P1         = pp$P1,
    P2         = pp$P2,
    wt         = pp$wt,
    n_failures = n_failures,
    stringsAsFactors = FALSE
  )

  if (is.null(alt_obj$alt_coef)) {
    message("'alt_obj' has not been fitted with alt.fit(). Returning relationship = NULL.")
    relationship_df <- NULL
  } else {
    coef <- alt_obj$alt_coef
    relationship_df <- data.frame(
      model = alt_obj$alt.model,
      coef1 = coef[1],
      coef2 = coef[2],
      stringsAsFactors = FALSE,
      row.names = NULL
    )
  }

  list(parallel = parallel_df, relationship = relationship_df)
}
