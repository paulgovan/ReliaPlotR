
#' Interactive Duane Plot.
#'
#' This function creates an interactive Duane plot for a duane object. The plot
#' includes options to customize the appearance, such as colors and grid visibility.
#'
#' @param duane_obj An object of class 'duane'. This object is created
#' using the `duane` function from the ReliaGrowR package.
#' @param showConf Show the confidence bounds (TRUE) or not (FALSE). Default is TRUE.
#' @param showGrid Show grid (TRUE) or hide grid (FALSE). Default is TRUE.
#' @param main Main title. Default is "Duane Plot".
#' @param xlab X-axis label. Default is "Cumulative Time".
#' @param ylab Y-axis label. Default is "Cumulative MTBF".
#' @param pointCol Color of the point values. Default is "black".
#' @param fitCol Color of the model fit. Default is "black".
#' @param confCol Color of the confidence bounds. Default is "black".
#' @param gridCol Color of the grid. Default is "lightgray".
#' @param signif Significant digits of results. Default is 3. Must be a positive integer.
#' @return A `plotly` object representing the interactive Duane plot.
#' @examples
#' library(ReliaGrowR)
#' times <- c(100, 200, 300, 400, 500)
#' failures <- c(1, 2, 1, 3, 2)
#' fit <- duane(times, failures)
#' plotly_duane(fit)
#' @import ReliaGrowR plotly
#' @importFrom graphics text
#' @importFrom stats runif qnorm
#' @export

plotly_duane <- function(duane_obj,
                         showConf = TRUE,
                         showGrid = TRUE,
                         main = "Duane Plot",
                         xlab = "Cumulative Time",
                         ylab = "Cumulative MTBF",
                         pointCol = "black",
                         fitCol = "black",
                         confCol = "black",
                         gridCol = "lightgray",
                         signif = 3) {
  # Validate inputs
  if (!inherits(duane_obj, "duane")) {
    stop("Argument 'duane_obj' is not of class 'duane'.")
  }

  # Extract data from the duane_obj
  times <- duane_obj$Cumulative_Time
  mtbf <- duane_obj$Cumulative_MTBF
  fitted <- duane_obj$Fitted_Values

  # Create the plot
  plot_duane <- function() {

    # Set up the plot layout
    fillcolor <- plotly::toRGB(confCol, 0.2)
    xgrid <- ifelse(is.null(showGrid) || isTRUE(showGrid), TRUE, FALSE)
    ygrid <- xgrid

    duane_plot <- plot_ly(
      x = times, y = mtbf, type = "scatter", mode = "markers",
      marker = list(color = pointCol), showlegend = FALSE, name = "",
      text = ~ paste0("MTBF: (", round(times, signif), ", ", round(mtbf, signif), ")"),
      hoverinfo = "text"
    ) %>%
      # Set up the main plot layout
      layout(
        title = main,
        xaxis = list(
          type = "log", title = xlab, showline = TRUE, mirror = "ticks",
          showgrid = xgrid, gridcolor = gridCol
        ),
        yaxis = list(
          type = "log", title = ylab, showline = TRUE, mirror = "ticks",
          showgrid = ygrid, gridcolor = gridCol
        )
      ) %>%
      # Add best fit
      add_trace(
        x = times, y = fitted, mode = "markers+lines",
        marker = list(color = "transparent"), line = list(color = fitCol),
        text = ~ paste0("Fit: (", round(times, signif), ", ", round(fitted, signif), ")"),
        hoverinfo = "text"
      )

    if (isTRUE(showConf)) {
      duane_plot <- duane_plot %>%
        # Add lower confidence bound
        add_trace(
          x = times, y = duane_obj$lower_bounds, mode = "markers+lines",
          marker = list(color = "transparent"), line = list(color = confCol),
          text = ~ paste0("Lower: (", round(times, signif), ", ", round(duane_obj$lower_bounds, signif), ")"),
          hoverinfo = "text"
        ) %>%
        # Add upper confidence bound
        add_trace(
          x = times, y = duane_obj$upper_bounds, mode = "markers+lines",
          fill = "tonexty",
          fillcolor = fillcolor,
          marker = list(color = "transparent"), line = list(color = confCol),
          text = ~ paste0("Upper: (", round(times, signif), ", ", round(duane_obj$upper_bounds, signif), ")"),
          hoverinfo = "text"
        )
    }

    return(duane_plot)
  }
  final_plot <- plot_duane()

  return(final_plot)
}
