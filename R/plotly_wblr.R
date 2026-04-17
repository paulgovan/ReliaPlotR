#' Interactive Probability Plot.
#'
#' This function creates an interactive probability plot for one or more wblr objects.
#' When a list of objects is provided the models are overlaid on the same plot, each
#' rendered in a distinct color. All objects must use the same distribution family.
#' It can include confidence bounds, suspension data (single object only), and a results table.
#'
#' @param wblr_obj A single object of class 'wblr', or a list of such objects. This is
#' a required argument. Each object must use the same distribution (e.g. all Weibull or
#' all lognormal). Suspension subplots are only shown when a single object is provided.
#' @param susp An optional numeric vector of suspension data. Default is NULL. Ignored
#' when multiple wblr objects are provided.
#' @param showConf Show the confidence bounds (TRUE) or not (FALSE). Default is TRUE if
#' confidence bounds are available in the wblr object.
#' @param showSusp Show the suspensions plot (TRUE) or not (FALSE). Default is TRUE
#' if susp is provided.
#' @param showGrid Show grid (TRUE) or hide grid (FALSE). Default is TRUE.
#' @param main Main title. Default is 'Probability Plot'.
#' @param xlab X-axis label. Default is 'Time to Failure'.
#' @param ylab Y-axis label. Default is 'Probability'.
#' @param probCol Color of the probability values. Default is 'black'. Used only for a
#' single wblr object; ignored when `cols` is provided or multiple objects are supplied.
#' @param fitCol Color of the model fit. Default is 'black'. Used only for a single
#' wblr object; ignored when `cols` is provided or multiple objects are supplied.
#' @param confCol Color of the confidence bounds. Default is 'black'. Used only for a
#' single wblr object; ignored when `cols` is provided or multiple objects are supplied.
#' @param intCol Color of the intervals for interval censored models. Default is 'black'.
#' @param gridCol Color of the grid. Default is 'lightgray'.
#' @param signif Significant digits of results. Default is 3. Must be a positive integer.
#' @param cols Optional character vector of colors, one per wblr object. When provided,
#' each object's data points, fit line, and confidence bounds are all drawn in the
#' corresponding color. Recycled if shorter than the number of objects.
#' @return A `plotly` object representing the interactive probability plot.
#' @examples
#' library(WeibullR)
#' library(ReliaPlotR)
#' failures <- c(30, 49, 82, 90, 96)
#' obj <- wblr.conf(wblr.fit(wblr(failures)))
#' plotly_wblr(obj)
#'
#' suspensions <- c(100, 45, 10)
#' obj <- wblr.conf(wblr.fit(wblr(failures, suspensions)))
#' plotly_wblr(obj, suspensions,
#'   fitCol = "blue",
#'   confCol = "blue"
#' )
#' inspection_data <- data.frame(
#'   left = c(0, 6.12, 19.92, 29.64, 35.4, 39.72, 45.32, 52.32),
#'   right = c(6.12, 19.92, 29.64, 35.4, 39.72, 45.32, 52.32, 63.48),
#'   qty = c(5, 16, 12, 18, 18, 2, 6, 17)
#' )
#' suspensions <- data.frame(time = 63.48, event = 0, qty = 73)
#' obj <- wblr(suspensions, interval = inspection_data)
#' obj <- wblr.fit(obj, method.fit = "mle")
#' obj <- wblr.conf(obj, method.conf = "fm", lty = 2)
#' suspensions <- as.vector(suspensions$time)
#' plotly_wblr(obj,
#'   susp = suspensions, fitCol = "red", confCol = "red", intCol = "blue",
#'   main = "Parts Cracking Inspection Interval Analysis",
#'   ylab = "Cumulative % Cracked", xlab = "Inspection Time"
#' )
#' failures <- c(25, 30, 42, 49, 55, 67, 73, 82, 90, 96, 101, 110, 120, 132, 145)
#' fit <- wblr.conf(wblr.fit(wblr(failures), dist = "weibull3p"))
#' plotly_wblr(fit, fitCol = "darkgreen", confCol = "darkgreen")
#'
#' # Overlay two Weibull models
#' obj2 <- wblr.conf(wblr.fit(wblr(c(20, 40, 60, 80, 100)), method.fit = "mle"),
#'                   method.conf = "lrb")
#' obj3 <- wblr.conf(wblr.fit(wblr(c(10, 30, 50, 70, 90)), method.fit = "mle"),
#'                   method.conf = "lrb")
#' plotly_wblr(list(obj2, obj3))
#'
#' @import WeibullR
#' @import plotly
#' @importFrom graphics text
#' @importFrom stats runif qnorm
#' @export

plotly_wblr <- function(wblr_obj,
                        susp = NULL,
                        showConf = TRUE,
                        showSusp = TRUE,
                        showGrid = TRUE,
                        main = "Probability Plot",
                        xlab = "Time to Failure",
                        ylab = "Probability",
                        probCol = "black",
                        fitCol = "black",
                        confCol = "black",
                        intCol = "black",
                        gridCol = "lightgray",
                        signif = 3,
                        cols = NULL) {

  # Normalize to list
  if (!is.list(wblr_obj) || inherits(wblr_obj, "wblr")) {
    wblr_obj <- list(wblr_obj)
  }
  n <- length(wblr_obj)

  if (n == 0) {
    stop("Argument 'wblr_obj' is not of class 'wblr'.")
  }

  # Validate inputs
  lapply(wblr_obj, function(obj) {
    if (!inherits(obj, "wblr")) {
      stop("All inputs must be of class 'wblr'.")
    }
  })
  if (!is.null(susp) && !is.numeric(susp)) {
    stop("Argument 'susp' must be a numeric vector.")
  }
  if (n > 1 && !is.null(susp)) {
    warning("'susp' is ignored when multiple wblr objects are provided.")
    susp <- NULL
  }

  # Require same distribution for overlay
  if (n > 1) {
    dist_types <- sapply(wblr_obj, function(obj) {
      if (is.null(obj$fit)) NA_character_ else obj$fit[[1]]$options$dist
    })
    dist_types <- dist_types[!is.na(dist_types)]
    if (length(unique(dist_types)) > 1) {
      stop("All wblr objects must use the same distribution for overlay.")
    }
  }

  # Per-object colors
  default_palette <- c(
    "#1f77b4", "#ff7f0e", "#2ca02c", "#d62728", "#9467bd",
    "#8c564b", "#e377c2", "#7f7f7f", "#bcbd22", "#17becf"
  )
  if (is.null(cols)) {
    if (n == 1) {
      obj_colors <- list(list(prob = probCol, fit = fitCol, conf = confCol))
    } else {
      base_cols <- rep(default_palette, length.out = n)
      obj_colors <- lapply(base_cols, function(col) list(prob = col, fit = col, conf = col))
    }
  } else {
    base_cols <- rep(cols, length.out = n)
    obj_colors <- lapply(base_cols, function(col) list(prob = col, fit = col, conf = col))
  }

  # Get time & probability data
  get_time_data <- function(obj, signif) {
    if (obj$interval == 0) {
      time <- obj$data$dpoints$time
      ints <- NULL
      prob <- obj$data$dpoints$ppp
    } else {
      t1 <- obj$data$dlines$t1
      t2 <- obj$data$dlines$t2
      time <- (t1 + t2) / 2
      ints <- log(t2 - t1)
      prob <- obj$data$dlines$ppp
    }
    list(
      time = time,
      time_sd = round(time, signif),
      ints = ints,
      prob = prob,
      prob_sd = round(prob, signif)
    )
  }

  # Get confidence-bound data
  get_conf_data <- function(obj, signif, showConf) {
    fit <- obj$fit[[1]]
    conf <- fit$conf[[1]]$bounds
    if (is.null(fit) || is.null(conf)) {
      out <- rep(list(NULL), 8)
      names(out) <- c(
        "datum", "unrel", "lower", "upper",
        "datum_sd", "unrel_sd", "lower_sd", "upper_sd"
      )
      return(out)
    }

    datum <- conf$Datum
    unrel <- conf$unrel

    if (!showConf) {
      lower <- upper <- NULL
    } else {
      lower <- conf$Lower
      upper <- conf$Upper
    }

    list(
      datum = datum,
      unrel = unrel,
      lower = lower,
      upper = upper,
      datum_sd = round(datum, signif),
      unrel_sd = round(unrel, signif),
      lower_sd = if (!is.null(lower)) round(lower, signif),
      upper_sd = if (!is.null(upper)) round(upper, signif)
    )
  }

  # Get distribution params & transforms
  get_dist_params <- function(obj, signif, probability, unrel) {
    fit_opts <- obj$fit[[1]]$options
    vec <- as.numeric(obj$fit[[1]]$fit_vec)

    switch(fit_opts$dist,
      lognormal = {
        params <- c("Mulog", "Sigmalog", NULL)
        values <- c(round(vec[1], signif), round(vec[2], signif), NULL)
        prob_tr <- qnorm(probability)
        unrel_tr <- qnorm(unrel)
        list(
          params = params, values = values,
          prob_trans = prob_tr, unrel_trans = unrel_tr
        )
      },
      weibull = ,
      weibull3p = {
        params <- c("Beta", "Eta", if (fit_opts$dist == "weibull3p") "Gamma" else NULL)
        vals <- c(
          round(vec[2], signif), round(vec[1], signif),
          if (fit_opts$dist == "weibull3p") round(vec[3], signif) else NULL
        )
        prob_tr <- log(1 / (1 - probability))
        unrel_tr <- log(1 / (1 - unrel))
        list(
          params = params, values = vals,
          prob_trans = prob_tr, unrel_trans = unrel_tr
        )
      },
      stop("Unsupported distribution: ", fit_opts$dist)
    )
  }

  # Get goodness-of-fit metrics
  get_gof_metrics <- function(obj, signif) {
    fit_opts <- obj$fit[[1]]$options
    gof <- obj$fit[[1]]$gof

    if (is.null(fit_opts$method.fit)) {
      return(list(methlab = NULL, methval = NULL))
    }

    if (fit_opts$method.fit == "rr-xony") {
      list(methlab = "R^2", methval = round(gof$r2, signif))
    } else if (fit_opts$method.fit == "mle") {
      list(methlab = "Loglikelihood", methval = round(gof$loglik, signif))
    } else {
      list(methlab = NULL, methval = NULL)
    }
  }

  # Extract all data from a wblr object
  extract_data <- function(obj, signif = 3, showConf = TRUE) {
    tp <- get_time_data(obj, signif)
    cd <- get_conf_data(obj, signif, showConf)
    dp <- if (is.null(obj$fit)) {
      list(params = NULL, values = NULL, prob_trans = NULL, unrel_trans = NULL)
    } else {
      get_dist_params(obj, signif, tp$prob, cd$unrel)
    }
    gm <- if (is.null(obj$fit)) {
      list(methlab = NULL, methval = NULL)
    } else {
      get_gof_metrics(obj, signif)
    }
    c(tp, cd, dp, gm)
  }

  # Y-axis ticks (in %)
  yticks <- c(
    0.000001, 0.00001, 0.0001, 0.001, 0.01, 0.05, 0.1, 0.2, 0.5, 1,
    2, 5, 10, 20, 50, 90, 99, 99.999
  )

  # Axis transform based on distribution type (use first object)
  first_obj <- wblr_obj[[1]]
  dist_type <- if (!is.null(first_obj$fit)) first_obj$fit[[1]]$options$dist else "weibull"
  if (dist_type == "lognormal") {
    yticks_trans <- qnorm(yticks / 100)
    yaxis_scale <- "linear"
  } else {
    yticks_trans <- log(1 / (1 - yticks / 100))
    yaxis_scale <- "log"
  }

  show_grid <- is.null(showGrid) || isTRUE(showGrid)

  # Extract first object's data now (needed for susp subplot x-range)
  first_data <- extract_data(first_obj, signif, showConf)

  # Build multi-object probability plot
  p <- plot_ly()
  show_in_legend <- n > 1

  for (i in seq_along(wblr_obj)) {
    obj <- wblr_obj[[i]]
    clrs <- obj_colors[[i]]
    data <- extract_data(obj, signif, showConf)
    fillcolor <- plotly::toRGB(clrs$conf, 0.2)
    label_suffix <- if (n > 1) paste0(" ", i) else ""
    grp <- as.character(i)

    p <- p %>%
      add_trace(
        x = data$time, y = data$prob_trans, type = "scatter", mode = "markers",
        marker = list(color = clrs$prob),
        showlegend = show_in_legend,
        legendgroup = grp,
        error_x = list(array = ~ data$ints, color = intCol),
        name = paste0("Data", label_suffix),
        text = ~ paste0("Probability: (", data$time_sd, ", ", data$prob_sd, ")"),
        hoverinfo = "text"
      ) %>%
      add_trace(
        x = data$datum, y = data$unrel_trans, type = "scatter", mode = "markers+lines",
        marker = list(color = "transparent"),
        line = list(color = clrs$fit),
        showlegend = show_in_legend,
        legendgroup = grp,
        name = paste0("Fit", label_suffix),
        text = ~ paste0("Fit: (", data$datum_sd, ", ", data$unrel_sd, ")"),
        hoverinfo = "text"
      )

    if (!is.null(data$lower)) {
      p <- p %>%
        add_trace(
          x = data$lower, y = data$unrel_trans, type = "scatter", mode = "markers+lines",
          marker = list(color = "transparent"),
          line = list(color = clrs$conf),
          showlegend = FALSE,
          legendgroup = grp,
          text = ~ paste0("Lower: (", data$lower_sd, ", ", data$unrel_sd, ")"),
          hoverinfo = "text"
        ) %>%
        add_trace(
          x = data$upper, y = data$unrel_trans, type = "scatter", mode = "markers+lines",
          fill = "tonexty", fillcolor = fillcolor,
          marker = list(color = "transparent"),
          line = list(color = clrs$conf),
          showlegend = FALSE,
          legendgroup = grp,
          text = ~ paste0("Upper: (", data$upper_sd, ", ", data$unrel_sd, ")"),
          hoverinfo = "text"
        )
    }
  }

  # Compute x range from first object's datum (used for both main plot and susp)
  log_datum <- log10(first_data$datum)
  xmin <- min(log_datum)
  xmax <- max(log_datum)

  p <- p %>%
    layout(
      title = main,
      xaxis = list(
        type = "log", title = xlab, showline = TRUE, mirror = "ticks",
        showgrid = show_grid, gridcolor = gridCol,
        range = list(xmin, xmax)
      ),
      yaxis = list(
        type = yaxis_scale, title = ylab, showline = TRUE, mirror = "ticks",
        showgrid = show_grid, gridcolor = gridCol,
        tickvals = yticks_trans, ticktext = yticks
      )
    )

  # Suspension subplot — single object only
  plot_susp <- function() {
    if (!showSusp || is.null(susp)) {
      return(NULL)
    }
    susp_sd <- round(susp, signif)
    rand_y <- stats::runif(length(susp))
    plot_ly(
      x = susp, y = rand_y, type = "scatter", mode = "markers",
      marker = list(color = obj_colors[[1]]$prob), showlegend = FALSE,
      text = ~ paste0("Suspension: ", susp_sd), hoverinfo = "text"
    ) %>%
      layout(
        xaxis = list(
          type = "log", title = "", zeroline = FALSE, showline = TRUE,
          mirror = "ticks", showticklabels = FALSE, showgrid = FALSE,
          range = list(xmin, xmax)
        ),
        yaxis = list(
          title = "", zeroline = FALSE, showline = TRUE,
          mirror = "ticks", showticklabels = FALSE, showgrid = FALSE
        )
      )
  }

  # Combine main plot with optional suspension subplot
  combine_plots <- function(prob_plot, susp_plot) {
    clean_subplot <- function(...) {
      plot <- subplot(...)
      plot$x$layout <- plot$x$layout[grep("NA", names(plot$x$layout), invert = TRUE)]
      plot
    }
    if (is.null(susp_plot)) {
      return(prob_plot)
    }
    clean_subplot(prob_plot, susp_plot, nrows = 2, titleX = TRUE, titleY = TRUE) %>%
      layout(
        xaxis = list(domain = c(0, 1)),
        xaxis2 = list(domain = c(0, 1)),
        yaxis = list(domain = c(0, 0.875)),
        yaxis2 = list(domain = c(0.9, 1))
      )
  }

  p2 <- plot_susp()
  combine_plots(p, p2)
}
