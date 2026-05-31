#' ReliaPlotR: Interactive Reliability Plots with plotly
#'
#' ReliaPlotR creates interactive reliability probability plots using
#' \href{https://plotly.com/r/}{plotly}. It wraps the \pkg{WeibullR},
#' \pkg{WeibullR.ALT}, and \pkg{ReliaGrowR} packages and provides a consistent
#' interface for four reliability analysis domains:
#'
#' \describe{
#'   \item{Life Data Analysis}{[plotly_wblr()], [plotly_contour()]}
#'   \item{Accelerated Life Testing}{[plotly_alt()], [plotly_rel()]}
#'   \item{Reliability Growth}{[plotly_rga()], [plotly_duane()]}
#'   \item{Repairable Systems}{[plotly_nhpp()], [plotly_mcf()], [plotly_exposure()]}
#' }
#'
#' All functions accept a single fitted model object or a list of objects
#' (for overlay plots) and return a \code{plotly} object.
#'
#' @seealso
#' Vignettes:
#' \itemize{
#'   \item \code{vignette("weibull", package = "ReliaPlotR")} — Life Data Analysis
#'   \item \code{vignette("alt", package = "ReliaPlotR")} — Accelerated Life Testing
#'   \item \code{vignette("rga", package = "ReliaPlotR")} — Reliability Growth Analysis
#'   \item \code{vignette("repairable", package = "ReliaPlotR")} — Repairable Systems Analysis
#' }
#'
#' @keywords internal
"_PACKAGE"

## usethis namespace: start
## usethis namespace: end
NULL
