#' Interactive Exposure Plot.
#'
#' The function creates an interactive exposure plot for one or more `exposure`
#' objects. When a list of objects is provided the estimates are overlaid on the
#' same plot, each rendered in a distinct color.
#' The plot shows the cumulative event rate over time as a step function.
#'
#' @param exposure_obj An object of class 'exposure', or a list of such objects.
#' Each object is created using the `exposure()` function from the `ReliaGrowR`
#' package.
#' @param showGrid Show grid (TRUE) or hide grid (FALSE). Default is TRUE.
#' @param main Main title. Default is "Exposure Plot".
#' @param xlab X-axis label. Default is "Time".
#' @param ylab Y-axis label. Default is "Event Rate".
#' @param fitCol Color of the event rate step function. Default is "black". Used
#' only for a single exposure object; ignored when `cols` is provided or multiple
#' objects are supplied.
#' @param gridCol Color of the grid. Default is "lightgray".
#' @param signif Significant digits of results. Default is 3. Must be a positive integer.
#' @param cols Optional character vector of colors, one per exposure object. When
#' provided, each object's step function is drawn in the corresponding color.
#' Recycled if shorter than the number of objects.
#' @return A `plotly` object representing the interactive exposure plot.
#' @examples
#' \dontrun{
#' library(ReliaGrowR)
#' ids <- c("A", "A", "A", "B", "B", "C", "C", "C", "C")
#' times <- c(50, 150, 350, 100, 300, 80, 200, 320, 450)
#' fit <- exposure(id = ids, time = times)
#' plotly_exposure(fit)
#'
#' # Overlay two exposure objects
#' fit2 <- exposure(id = c("X", "X", "Y"), time = c(60, 220, 180))
#' plotly_exposure(list(fit, fit2), cols = c("steelblue", "tomato"))
#' }
#' @import ReliaGrowR plotly
#' @importFrom graphics text
#' @importFrom stats runif qnorm
#' @export

plotly_exposure <- function(exposure_obj,
                            showGrid = TRUE,
                            main = "Exposure Plot",
                            xlab = "Time",
                            ylab = "Event Rate",
                            fitCol = "black",
                            gridCol = "lightgray",
                            signif = 3,
                            cols = NULL) {

  # Normalize to list
  if (!is.list(exposure_obj) || inherits(exposure_obj, "exposure")) {
    exposure_obj <- list(exposure_obj)
  }
  n <- length(exposure_obj)

  # Validate inputs
  lapply(exposure_obj, function(obj) {
    if (!inherits(obj, "exposure")) {
      stop("All inputs must be of class 'exposure'.")
    }
  })

  # Set up per-object colors
  default_palette <- c(
    "#1f77b4", "#ff7f0e", "#2ca02c", "#d62728", "#9467bd",
    "#8c564b", "#e377c2", "#7f7f7f", "#bcbd22", "#17becf"
  )
  if (is.null(cols)) {
    if (n == 1) {
      obj_colors <- list(fitCol)
    } else {
      obj_colors <- as.list(rep(default_palette, length.out = n))
    }
  } else {
    obj_colors <- as.list(rep(cols, length.out = n))
  }

  xgrid <- ifelse(is.null(showGrid) || isTRUE(showGrid), TRUE, FALSE)

  # Build plot
  p <- plot_ly()

  for (i in seq_along(exposure_obj)) {
    obj <- exposure_obj[[i]]
    col <- obj_colors[[i]]

    label_suffix <- if (n > 1) paste0(" ", i) else ""
    show_in_legend <- n > 1

    p <- p %>%
      add_trace(
        type = "scatter", x = obj$time, y = obj$event_rate, mode = "lines",
        line = list(color = col, shape = "hv"),
        showlegend = show_in_legend,
        legendgroup = as.character(i),
        name = paste0("Event Rate", label_suffix),
        text = paste0("Rate: (", round(obj$time, signif), ", ", round(obj$event_rate, signif), ")"),
        hoverinfo = "text"
      )
  }

  p <- p %>%
    layout(
      title = main,
      xaxis = list(
        title = xlab, showline = TRUE, mirror = "ticks",
        showgrid = xgrid, gridcolor = gridCol
      ),
      yaxis = list(
        title = ylab, showline = TRUE, mirror = "ticks",
        showgrid = xgrid, gridcolor = gridCol
      )
    )

  return(p)
}
