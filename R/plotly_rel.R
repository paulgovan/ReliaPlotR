#' Interactive ALT Life-Stress Relationship Plot.
#'
#' Creates an interactive life-stress relationship (Arrhenius or Power Law) plot
#' for an `alt` object. Displays the characteristic-life estimates per stress
#' level, the fitted relationship line, optional percentile bands with shading,
#' and an optional goal-condition marker. The `alt` object must have been
#' processed through [WeibullR.ALT::alt.fit()] before passing to this function.
#'
#' @param alt_obj An object of class `'alt'` created by the `WeibullR.ALT` package
#'   and fitted with `alt.fit()`.
#' @param showPerc Show percentile lines with shading (TRUE) or not (FALSE).
#'   Default is TRUE.
#' @param showGoal Show the goal-condition marker when one is present in `alt_obj`
#'   (TRUE) or not (FALSE). Default is TRUE.
#' @param showGrid Show grid (TRUE) or hide grid (FALSE). Default is TRUE.
#' @param main Main title. Default is "Life-Stress Relationship".
#' @param xlab X-axis label. Default is "Stress".
#' @param ylab Y-axis label. Default is "Time to Failure".
#' @param fitCol Color of the fitted relationship line. Default is "red".
#' @param ptCol Color of the characteristic-life scatter points. Default is "black".
#' @param percCol Color of the percentile lines and fill. Default is "blue".
#' @param goalCol Color of the goal-condition marker. Default is "orange".
#' @param gridCol Color of the grid. Default is "lightgray".
#' @param signif Significant digits for hover text. Default is 3.
#' @param percentiles Numeric vector of percentiles to draw as reference lines
#'   with shading. Sorted internally; shading is filled between adjacent lines.
#'   Default is `c(10, 90)`.
#' @return A `plotly` object representing the interactive life-stress plot.
#' @examples
#' library(WeibullR.ALT)
#' d1 <- alt.data(c(248, 456, 528, 731, 813, 537), stress = 300)
#' d2 <- alt.data(c(164, 176, 289), stress = 350)
#' d3 <- alt.data(c(88, 112, 152), stress = 400)
#' obj <- alt.fit(
#'   alt.parallel(
#'     alt.make(list(d1, d2, d3), dist = "weibull", alt.model = "arrhenius", view_dist_fits = FALSE),
#'     view_parallel_fits = FALSE
#'   )
#' )
#' plotly_rel(obj)
#' @import WeibullR.ALT
#' @import plotly
#' @importFrom stats qweibull qlnorm
#' @export

plotly_rel <- function(alt_obj,
                       showPerc    = TRUE,
                       showGoal    = TRUE,
                       showGrid    = TRUE,
                       main        = "Life-Stress Relationship",
                       xlab        = "Stress",
                       ylab        = "Time to Failure",
                       fitCol      = "red",
                       ptCol       = "black",
                       percCol     = "blue",
                       goalCol     = "orange",
                       gridCol     = "lightgray",
                       signif      = 3,
                       percentiles = c(10, 90)) {

  if (!inherits(alt_obj, "alt")) {
    stop("Argument 'alt_obj' is not of class 'alt'.")
  }
  if (is.null(alt_obj$alt_coef)) {
    stop("'alt_obj' must be fitted with alt.fit() before plotting.")
  }

  pp          <- alt_obj$parallel_par
  coef        <- alt_obj$alt_coef
  dist_type   <- alt_obj$dist
  model_type  <- alt_obj$alt.model
  P2          <- pp$P2[1]

  show_grid <- is.null(showGrid) || isTRUE(showGrid)

  # Characteristic-life values for the scatter points
  # Weibull: P1 = eta (already in time units)
  # Lognormal: P1 = log(median), convert to median life
  stress_pts <- pp$stress
  life_pts   <- if (dist_type == "lognormal") exp(pp$P1) else pp$P1

  # Fitted relationship line over the stress range
  stress_range <- seq(min(stress_pts), max(stress_pts), length.out = 200)
  fit_y <- if (model_type == "power") {
    exp(coef[2] * log(stress_range) + coef[1])
  } else {
    exp(coef[2] * stress_range + coef[1])
  }

  # X-axis type: log for Power Law, linear for Arrhenius
  xaxis_type <- if (model_type == "power") "log" else "linear"

  # Shading fill color (semi-transparent)
  perc_fill <- plotly::toRGB(percCol, 0.2)

  # Build plot
  p <- plot_ly()

  # Characteristic-life scatter
  p <- p %>%
    add_trace(
      x = stress_pts, y = life_pts,
      type = "scatter", mode = "markers",
      marker = list(color = ptCol, symbol = "x", size = 10),
      name = if (dist_type == "lognormal") "Median Life" else "Char. Life",
      text = paste0(
        "Stress: ", round(stress_pts, signif),
        ", Life: ", round(life_pts, signif)
      ),
      hoverinfo = "text"
    ) %>%
    # Fitted line
    add_trace(
      x = stress_range, y = fit_y,
      type = "scatter", mode = "lines",
      line = list(color = fitCol, width = 2),
      name = "Fit",
      text = paste0(
        "Stress: ", round(stress_range, signif),
        ", Life: ", round(fit_y, signif)
      ),
      hoverinfo = "text"
    )

  # Percentile lines with shading between adjacent pairs
  if (isTRUE(showPerc) && length(percentiles) > 0) {
    percs_sorted <- sort(percentiles)

    for (j in seq_along(percs_sorted)) {
      perc  <- percs_sorted[j]
      quant <- if (dist_type == "weibull") {
        qweibull(perc / 100, shape = P2, scale = 1)
      } else {
        qlnorm(perc / 100, meanlog = 0, sdlog = P2)
      }
      perc_y <- fit_y * quant

      # Fill to the previous trace for all but the first percentile
      use_fill <- j > 1

      p <- p %>%
        add_trace(
          x = stress_range, y = perc_y,
          type = "scatter", mode = "lines",
          fill      = if (use_fill) "tonexty" else "none",
          fillcolor = if (use_fill) perc_fill  else NULL,
          line = list(color = percCol, width = 1),
          name = paste0(perc, "th %ile"),
          text = paste0(
            "Stress: ", round(stress_range, signif),
            ", ", perc, "th %ile: ", round(perc_y, signif)
          ),
          hoverinfo = "text"
        )
    }
  }

  # Goal-condition marker
  if (isTRUE(showGoal) && !is.null(alt_obj$goal)) {
    goal_stress <- alt_obj$goal$stress
    goal_life   <- if (model_type == "power") {
      exp(coef[2] * log(goal_stress) + coef[1])
    } else {
      exp(coef[2] * goal_stress + coef[1])
    }
    if (dist_type == "lognormal") goal_life <- exp(goal_life)
    p <- p %>%
      add_trace(
        x = goal_stress, y = goal_life,
        type = "scatter", mode = "markers",
        marker = list(color = goalCol, symbol = "star", size = 14),
        name = "Goal",
        text = paste0(
          "Goal Stress: ", round(goal_stress, signif),
          ", Life: ", round(goal_life, signif)
        ),
        hoverinfo = "text"
      )
  }

  p %>%
    layout(
      title = main,
      xaxis = list(
        type = xaxis_type, title = xlab, showline = TRUE, mirror = "ticks",
        showgrid = show_grid, gridcolor = gridCol
      ),
      yaxis = list(
        type = "log", title = ylab, showline = TRUE, mirror = "ticks",
        showgrid = show_grid, gridcolor = gridCol
      )
    )
}
