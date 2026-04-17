#' Interactive Reliability Growth Plot.
#'
#' The function creates an interactive reliability growth plot for one or more `rga`
#' objects. When a list of objects is provided the models are overlaid on the same
#' plot, each rendered in a distinct color.
#' The plot includes cumulative failures over time, the model fit, and optional confidence bounds.
#' Vertical lines indicate change points if breakpoints are specified in the rga object.
#'
#'
#' @param rga_obj An object of class 'rga', or a list of such objects. Each object
#' is created using the `rga()` function from the `ReliaGrowR` package.
#' @param showConf Show the confidence bounds (TRUE) or not (FALSE). Default is TRUE.
#' @param showGrid Show grid (TRUE) or hide grid (FALSE). Default is TRUE.
#' @param main Main title. Default is "Reliability Growth Plot".
#' @param xlab X-axis label. Default is "Cumulative Time".
#' @param ylab Y-axis label. Default is "Cumulative Failures".
#' @param pointCol Color of the point values. Default is "black". Used only for a
#' single rga object; ignored when `cols` is provided or multiple objects are supplied.
#' @param fitCol Color of the model fit. Default is "black". Used only for a single
#' rga object; ignored when `cols` is provided or multiple objects are supplied.
#' @param confCol Color of the confidence bounds. Default is "black". Used only for a
#' single rga object; ignored when `cols` is provided or multiple objects are supplied.
#' @param gridCol Color of the grid. Default is "lightgray".
#' @param breakCol Color of the breakpoints. Default is "black". Used only for a
#' single rga object; ignored when `cols` is provided or multiple objects are supplied.
#' @param signif Significant digits of results. Default is 3. Must be a positive integer.
#' @param cols Optional character vector of colors, one per rga object. When provided,
#' each object's points, fit line, confidence bounds, and breakpoints are all drawn in
#' the corresponding color. Recycled if shorter than the number of objects.
#' @return A `plotly` object representing the interactive reliability growth plot.
#' @examples
#' library(ReliaGrowR)
#' times <- c(100, 200, 300, 400, 500)
#' failures <- c(1, 2, 1, 3, 2)
#' rga <- rga(times, failures)
#' plotly_rga(rga)
#'
#' times <- c(100, 200, 300, 400, 500, 600, 700, 800, 900, 1000)
#' failures <- c(1, 2, 1, 1, 1, 2, 3, 1, 2, 4)
#' breakpoints <- 400
#' rga2 <- rga(times, failures, model_type = "Piecewise NHPP", breaks = breakpoints)
#' plotly_rga(rga2, fitCol = "blue", confCol = "blue", breakCol = "red")
#'
#' # Overlay two models
#' rga3 <- rga(c(50, 150, 250, 350, 450), c(2, 1, 3, 1, 2))
#' plotly_rga(list(rga, rga3))
#' @import ReliaGrowR plotly
#' @importFrom graphics text
#' @importFrom stats runif qnorm
#' @export

plotly_rga <- function(rga_obj,
                       showConf = TRUE,
                       showGrid = TRUE,
                       main = "Reliability Growth Plot",
                       xlab = "Cumulative Time",
                       ylab = "Cumulative Failures",
                       pointCol = "black",
                       fitCol = "black",
                       confCol = "black",
                       gridCol = "lightgray",
                       breakCol = "black",
                       signif = 3,
                       cols = NULL) {

  # Normalize to list
  if (!is.list(rga_obj) || inherits(rga_obj, "rga")) {
    rga_obj <- list(rga_obj)
  }
  n <- length(rga_obj)

  # Validate inputs
  lapply(rga_obj, function(obj) {
    if (!inherits(obj, "rga")) {
      stop("All inputs must be of class 'rga'.")
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

  for (i in seq_along(rga_obj)) {
    obj <- rga_obj[[i]]
    clrs <- obj_colors[[i]]
    fillcolor <- plotly::toRGB(clrs$conf, 0.2)

    times <- exp(obj$model$model$log_times)
    cum_failures <- exp(obj$model$model$log_cum_failures)
    fitted <- obj$fitted_values

    label_suffix <- if (n > 1) paste0(" ", i) else ""
    show_in_legend <- n > 1

    p <- p %>%
      add_trace(
        x = times, y = cum_failures, type = "scatter", mode = "markers",
        marker = list(color = clrs$point),
        showlegend = show_in_legend,
        legendgroup = as.character(i),
        name = paste0("Data", label_suffix),
        text = ~ paste0("Failures: (", round(times, signif), ", ", round(cum_failures, signif), ")"),
        hoverinfo = "text"
      ) %>%
      add_trace(
        x = times, y = fitted, mode = "markers+lines",
        marker = list(color = "transparent"), line = list(color = clrs$fit),
        showlegend = show_in_legend,
        legendgroup = as.character(i),
        name = paste0("Fit", label_suffix),
        text = ~ paste0("Fit: (", round(times, signif), ", ", round(fitted, signif), ")"),
        hoverinfo = "text"
      )

    if (isTRUE(showConf)) {
      p <- p %>%
        add_trace(
          x = times, y = obj$lower_bounds, mode = "markers+lines",
          marker = list(color = "transparent"), line = list(color = clrs$conf),
          showlegend = FALSE,
          legendgroup = as.character(i),
          text = ~ paste0("Lower: (", round(times, signif), ", ", round(obj$lower_bounds, signif), ")"),
          hoverinfo = "text"
        ) %>%
        add_trace(
          x = times, y = obj$upper_bounds, mode = "markers+lines",
          fill = "tonexty", fillcolor = fillcolor,
          marker = list(color = "transparent"), line = list(color = clrs$conf),
          showlegend = FALSE,
          legendgroup = as.character(i),
          text = ~ paste0("Upper: (", round(times, signif), ", ", round(obj$upper_bounds, signif), ")"),
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
