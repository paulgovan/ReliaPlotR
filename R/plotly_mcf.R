#' Interactive Mean Cumulative Function Plot.
#'
#' The function creates an interactive Mean Cumulative Function (MCF) plot for
#' one or more `mcf` objects. When a list of objects is provided the models are
#' overlaid on the same plot, each rendered in a distinct color.
#' The MCF is rendered as a step function. Optional confidence bounds are shown
#' as a shaded band around the estimate.
#'
#' @param mcf_obj An object of class 'mcf', or a list of such objects. Each
#' object is created using the `mcf()` function from the `ReliaGrowR` package.
#' @param showConf Show the confidence bounds (TRUE) or not (FALSE). Default is TRUE.
#' @param showGrid Show grid (TRUE) or hide grid (FALSE). Default is TRUE.
#' @param main Main title. Default is "Mean Cumulative Function Plot".
#' @param xlab X-axis label. Default is "Time".
#' @param ylab Y-axis label. Default is "Mean Cumulative Function".
#' @param fitCol Color of the MCF step function. Default is "black". Used only
#' for a single mcf object; ignored when `cols` is provided or multiple objects
#' are supplied.
#' @param confCol Color of the confidence bounds. Default is "black". Used only
#' for a single mcf object; ignored when `cols` is provided or multiple objects
#' are supplied.
#' @param gridCol Color of the grid. Default is "lightgray".
#' @param signif Significant digits of results. Default is 3. Must be a positive integer.
#' @param cols Optional character vector of colors, one per mcf object. When
#' provided, each object's step function and confidence bounds are drawn in the
#' corresponding color. Recycled if shorter than the number of objects.
#' @return A `plotly` object representing the interactive MCF plot.
#' @examples
#' \dontrun{
#' library(ReliaGrowR)
#' ids <- c("A", "A", "A", "B", "B", "C", "C", "C", "C")
#' times <- c(50, 150, 350, 100, 300, 80, 200, 320, 450)
#' fit <- mcf(id = ids, time = times)
#' plotly_mcf(fit)
#'
#' # Overlay two MCF objects
#' fit2 <- mcf(id = c("X", "X", "Y"), time = c(60, 220, 180))
#' plotly_mcf(list(fit, fit2), cols = c("steelblue", "tomato"))
#' }
#' @import ReliaGrowR plotly
#' @importFrom graphics text
#' @importFrom stats runif qnorm
#' @export

plotly_mcf <- function(mcf_obj,
                       showConf = TRUE,
                       showGrid = TRUE,
                       main = "Mean Cumulative Function Plot",
                       xlab = "Time",
                       ylab = "Mean Cumulative Function",
                       fitCol = "black",
                       confCol = "black",
                       gridCol = "lightgray",
                       signif = 3,
                       cols = NULL) {

  # Normalize to list
  if (!is.list(mcf_obj) || inherits(mcf_obj, "mcf")) {
    mcf_obj <- list(mcf_obj)
  }
  n <- length(mcf_obj)

  # Validate inputs
  lapply(mcf_obj, function(obj) {
    if (!inherits(obj, "mcf")) {
      stop("All inputs must be of class 'mcf'.")
    }
  })

  # Set up per-object colors
  default_palette <- c(
    "#1f77b4", "#ff7f0e", "#2ca02c", "#d62728", "#9467bd",
    "#8c564b", "#e377c2", "#7f7f7f", "#bcbd22", "#17becf"
  )
  if (is.null(cols)) {
    if (n == 1) {
      obj_colors <- list(list(fit = fitCol, conf = confCol))
    } else {
      base_cols <- rep(default_palette, length.out = n)
      obj_colors <- lapply(base_cols, function(col) {
        list(fit = col, conf = col)
      })
    }
  } else {
    base_cols <- rep(cols, length.out = n)
    obj_colors <- lapply(base_cols, function(col) {
      list(fit = col, conf = col)
    })
  }

  xgrid <- ifelse(is.null(showGrid) || isTRUE(showGrid), TRUE, FALSE)

  # Build plot
  p <- plot_ly()

  for (i in seq_along(mcf_obj)) {
    obj <- mcf_obj[[i]]
    clrs <- obj_colors[[i]]
    fillcolor <- plotly::toRGB(clrs$conf, 0.2)

    label_suffix <- if (n > 1) paste0(" ", i) else ""
    show_in_legend <- n > 1

    p <- p %>%
      add_trace(
        type = "scatter", x = obj$time, y = obj$mcf, mode = "lines",
        line = list(color = clrs$fit, shape = "hv"),
        showlegend = show_in_legend,
        legendgroup = as.character(i),
        name = paste0("MCF", label_suffix),
        text = paste0("MCF: (", round(obj$time, signif), ", ", round(obj$mcf, signif), ")"),
        hoverinfo = "text"
      )

    if (isTRUE(showConf)) {
      p <- p %>%
        add_trace(
          type = "scatter", x = obj$time, y = obj$lower_bounds, mode = "lines",
          line = list(color = clrs$conf, shape = "hv"),
          showlegend = FALSE,
          legendgroup = as.character(i),
          text = paste0("Lower: (", round(obj$time, signif), ", ", round(obj$lower_bounds, signif), ")"),
          hoverinfo = "text"
        ) %>%
        add_trace(
          type = "scatter", x = obj$time, y = obj$upper_bounds, mode = "lines",
          fill = "tonexty", fillcolor = fillcolor,
          line = list(color = clrs$conf, shape = "hv"),
          showlegend = FALSE,
          legendgroup = as.character(i),
          text = paste0("Upper: (", round(obj$time, signif), ", ", round(obj$upper_bounds, signif), ")"),
          hoverinfo = "text"
        )
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
      )
    )

  return(p)
}
