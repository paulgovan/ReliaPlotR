#' Interactive NHPP Plot.
#'
#' The function creates an interactive Non-Homogeneous Poisson Process (NHPP)
#' plot for one or more `nhpp` objects. When a list of objects is provided the
#' models are overlaid on the same plot, each rendered in a distinct color.
#' The plot includes cumulative events over time, the model fit, and optional
#' confidence bounds. Vertical lines indicate change points if breakpoints are
#' specified in the nhpp object.
#'
#' @param nhpp_obj An object of class 'nhpp', or a list of such objects. Each
#' object is created using the `nhpp()` function from the `ReliaGrowR` package.
#' @param showConf Show the confidence bounds (TRUE) or not (FALSE). Default is TRUE.
#' @param showGrid Show grid (TRUE) or hide grid (FALSE). Default is TRUE.
#' @param main Main title. Default is "NHPP Plot".
#' @param xlab X-axis label. Default is "Cumulative Time".
#' @param ylab Y-axis label. Default is "Cumulative Events".
#' @param pointCol Color of the point values. Default is "black". Used only for
#' a single nhpp object; ignored when `cols` is provided or multiple objects are
#' supplied.
#' @param fitCol Color of the model fit. Default is "black". Used only for a
#' single nhpp object; ignored when `cols` is provided or multiple objects are
#' supplied.
#' @param confCol Color of the confidence bounds. Default is "black". Used only
#' for a single nhpp object; ignored when `cols` is provided or multiple objects
#' are supplied.
#' @param gridCol Color of the grid. Default is "lightgray".
#' @param breakCol Color of the breakpoints. Default is "black". Used only for a
#' single nhpp object; ignored when `cols` is provided or multiple objects are
#' supplied.
#' @param signif Significant digits of results. Default is 3. Must be a positive integer.
#' @param cols Optional character vector of colors, one per nhpp object. When
#' provided, each object's points, fit line, confidence bounds, and breakpoints
#' are all drawn in the corresponding color. Recycled if shorter than the number
#' of objects.
#' @return A `plotly` object representing the interactive NHPP plot.
#' @examples
#' \dontrun{
#' library(ReliaGrowR)
#' times <- c(100, 200, 300, 400, 500)
#' events <- c(1, 2, 1, 3, 2)
#' fit <- nhpp(time = times, event = events)
#' plotly_nhpp(fit)
#'
#' # Piecewise model with a breakpoint
#' times2 <- c(100, 200, 300, 400, 500, 600, 700, 800, 900, 1000)
#' events2 <- c(1, 2, 1, 1, 1, 2, 3, 1, 2, 4)
#' fit2 <- nhpp(time = times2, event = events2, breaks = 500)
#' plotly_nhpp(fit2, breakCol = "red")
#'
#' # Overlay two models
#' plotly_nhpp(list(fit, fit2))
#' }
#' @import ReliaGrowR plotly
#' @importFrom graphics text
#' @importFrom stats runif qnorm
#' @export

plotly_nhpp <- function(nhpp_obj,
                        showConf = TRUE,
                        showGrid = TRUE,
                        main = "NHPP Plot",
                        xlab = "Cumulative Time",
                        ylab = "Cumulative Events",
                        pointCol = "black",
                        fitCol = "black",
                        confCol = "black",
                        gridCol = "lightgray",
                        breakCol = "black",
                        signif = 3,
                        cols = NULL) {

  # Normalize to list
  if (!is.list(nhpp_obj) || inherits(nhpp_obj, "nhpp")) {
    nhpp_obj <- list(nhpp_obj)
  }
  n <- length(nhpp_obj)

  # Validate inputs
  lapply(nhpp_obj, function(obj) {
    if (!inherits(obj, "nhpp")) {
      stop("All inputs must be of class 'nhpp'.")
    }
  })

  # Set up per-object colors
  default_palette <- c(
    "#1f77b4", "#ff7f0e", "#2ca02c", "#d62728", "#9467bd",
    "#8c564b", "#e377c2", "#7f7f7f", "#bcbd22", "#17becf"
  )
  if (is.null(cols)) {
    if (n == 1) {
      obj_colors <- list(list(point = pointCol, fit = fitCol, conf = confCol, brk = breakCol))
    } else {
      base_cols <- rep(default_palette, length.out = n)
      obj_colors <- lapply(base_cols, function(col) {
        list(point = col, fit = col, conf = col, brk = col)
      })
    }
  } else {
    base_cols <- rep(cols, length.out = n)
    obj_colors <- lapply(base_cols, function(col) {
      list(point = col, fit = col, conf = col, brk = col)
    })
  }

  xgrid <- ifelse(is.null(showGrid) || isTRUE(showGrid), TRUE, FALSE)

  vline <- function(x = 0, color = "black") {
    list(
      type = "line",
      y0 = 0, y1 = 1, yref = "paper",
      x0 = x, x1 = x,
      line = list(color = color, dash = "dot")
    )
  }

  # Build plot
  p <- plot_ly()
  all_shapes <- list()

  for (i in seq_along(nhpp_obj)) {
    obj <- nhpp_obj[[i]]
    clrs <- obj_colors[[i]]
    fillcolor <- plotly::toRGB(clrs$conf, 0.2)

    times <- obj$time
    cum_events <- obj$cum_events
    fitted <- obj$fitted_values

    label_suffix <- if (n > 1) paste0(" ", i) else ""
    show_in_legend <- n > 1

    p <- p %>%
      add_trace(
        x = times, y = cum_events, type = "scatter", mode = "markers",
        marker = list(color = clrs$point),
        showlegend = show_in_legend,
        legendgroup = as.character(i),
        name = paste0("Data", label_suffix),
        text = paste0("Events: (", round(times, signif), ", ", round(cum_events, signif), ")"),
        hoverinfo = "text"
      ) %>%
      add_trace(
        type = "scatter", x = times, y = fitted, mode = "markers+lines",
        marker = list(color = "transparent"), line = list(color = clrs$fit),
        showlegend = show_in_legend,
        legendgroup = as.character(i),
        name = paste0("Fit", label_suffix),
        text = paste0("Fit: (", round(times, signif), ", ", round(fitted, signif), ")"),
        hoverinfo = "text"
      )

    if (isTRUE(showConf)) {
      p <- p %>%
        add_trace(
          type = "scatter", x = times, y = obj$lower_bounds, mode = "markers+lines",
          marker = list(color = "transparent"), line = list(color = clrs$conf),
          showlegend = FALSE,
          legendgroup = as.character(i),
          text = paste0("Lower: (", round(times, signif), ", ", round(obj$lower_bounds, signif), ")"),
          hoverinfo = "text"
        ) %>%
        add_trace(
          type = "scatter", x = times, y = obj$upper_bounds, mode = "markers+lines",
          fill = "tonexty", fillcolor = fillcolor,
          marker = list(color = "transparent"), line = list(color = clrs$conf),
          showlegend = FALSE,
          legendgroup = as.character(i),
          text = paste0("Upper: (", round(times, signif), ", ", round(obj$upper_bounds, signif), ")"),
          hoverinfo = "text"
        )
    }

    # Collect breakpoint shapes
    if (!is.null(obj$breakpoints) && length(obj$breakpoints) > 0) {
      bp_times <- exp(as.numeric(obj$breakpoints))
      for (bp in bp_times) {
        all_shapes <- c(all_shapes, list(vline(bp, color = clrs$brk)))
      }
    }
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
      ),
      shapes = all_shapes
    )

  return(p)
}
