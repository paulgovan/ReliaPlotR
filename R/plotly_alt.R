#' Interactive ALT Probability Plot.
#'
#' Creates an interactive probability plot for an `alt` object, overlaying one
#' Weibull or lognormal fit line per stress level on a shared probability paper.
#' The `alt` object must have been processed through [WeibullR.ALT::alt.parallel()]
#' before passing to this function.
#'
#' @param alt_obj An object of class `'alt'` created by the `WeibullR.ALT` package
#'   and fitted with `alt.parallel()`.
#' @param showConf Show Fisher-matrix confidence bounds (TRUE) or not (FALSE).
#'   Default is TRUE.
#' @param showGrid Show grid (TRUE) or hide grid (FALSE). Default is TRUE.
#' @param main Main title. Default is "ALT Probability Plot".
#' @param xlab X-axis label. Default is "Time to Failure".
#' @param ylab Y-axis label. Default is "Probability".
#' @param gridCol Color of the grid. Default is "lightgray".
#' @param signif Significant digits for hover text. Default is 3.
#' @param cols Optional character vector of colors, one per stress level. Recycled
#'   to match the number of stress levels. When NULL a 10-color default palette is used.
#' @return A `plotly` object representing the interactive ALT probability plot.
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
#' plotly_alt(obj)
#' @import WeibullR.ALT
#' @import WeibullR
#' @import plotly
#' @importFrom stats pweibull plnorm qnorm qweibull qlnorm
#' @export

plotly_alt <- function(alt_obj,
                       showConf = TRUE,
                       showGrid = TRUE,
                       main     = "ALT Probability Plot",
                       xlab     = "Time to Failure",
                       ylab     = "Probability",
                       gridCol  = "lightgray",
                       signif   = 3,
                       cols     = NULL) {

  if (!inherits(alt_obj, "alt")) {
    stop("Argument 'alt_obj' is not of class 'alt'.")
  }
  if (is.null(alt_obj$parallel_par)) {
    stop("'alt_obj' must be fitted with alt.parallel() before plotting.")
  }

  pp        <- alt_obj$parallel_par
  n         <- nrow(pp)
  dist_type <- alt_obj$dist

  # Per-stress-level colors
  default_palette <- c(
    "#1f77b4", "#ff7f0e", "#2ca02c", "#d62728", "#9467bd",
    "#8c564b", "#e377c2", "#7f7f7f", "#bcbd22", "#17becf"
  )
  cols <- rep(if (is.null(cols)) default_palette else cols, length.out = n)

  # Y-axis probability ticks (identical to plotly_wblr)
  yticks <- c(
    0.000001, 0.00001, 0.0001, 0.001, 0.01, 0.05, 0.1, 0.2, 0.5, 1,
    2, 5, 10, 20, 50, 90, 99, 99.999
  )
  if (dist_type == "lognormal") {
    yticks_trans <- qnorm(yticks / 100)
    yaxis_scale  <- "linear"
  } else {
    yticks_trans <- log(1 / (1 - yticks / 100))
    yaxis_scale  <- "log"
  }

  show_grid <- is.null(showGrid) || isTRUE(showGrid)

  # Collect all failure times for global x range (extended by fit line extremes)
  all_failures <- unlist(lapply(alt_obj$data, function(d) {
    dat <- d$data
    rep(dat$left[dat$right >= 0], dat$qty[dat$right >= 0])
  }))

  p <- plot_ly()

  # Track x-range across all stress levels
  all_t_seq <- numeric(0)

  for (i in seq_len(n)) {
    stress_i <- pp$stress[i]
    P1_i     <- pp$P1[i]
    P2_i     <- pp$P2[i]
    col_i    <- cols[i]
    grp      <- as.character(i)

    # Match stress level to raw data entry
    data_idx <- which(sapply(alt_obj$data, function(d) d$stress) == stress_i)
    dat      <- alt_obj$data[[data_idx]]$data

    fail_rows <- dat[dat$right >= 0, ]
    susp_rows <- dat[dat$right <  0, ]
    failures_i    <- rep(fail_rows$left, fail_rows$qty)
    suspensions_i <- rep(susp_rows$left, susp_rows$qty)

    # Empirical plotting positions via WeibullR
    wblr_i <- if (length(suspensions_i) > 0) {
      WeibullR::wblr(failures_i, suspensions_i)
    } else {
      WeibullR::wblr(failures_i)
    }
    time_pts <- wblr_i$data$dpoints$time
    ppp_pts  <- wblr_i$data$dpoints$ppp

    # Transform to probability-paper coordinates
    prob_trans <- if (dist_type == "lognormal") {
      qnorm(ppp_pts)
    } else {
      log(1 / (1 - ppp_pts))
    }

    # Theoretical fit line spanning ~0.1% to 99.9% of the fitted CDF
    if (dist_type == "lognormal") {
      t_lo <- exp(P1_i + qnorm(0.001) * P2_i)
      t_hi <- exp(P1_i + qnorm(0.999) * P2_i)
    } else {
      t_lo <- P1_i * qweibull(0.001, shape = P2_i)
      t_hi <- P1_i * qweibull(0.999, shape = P2_i)
    }
    t_seq <- exp(seq(log(t_lo), log(t_hi), length.out = 200))
    all_t_seq <- c(all_t_seq, t_seq)

    if (dist_type == "lognormal") {
      F_seq   <- plnorm(t_seq, meanlog = P1_i, sdlog = P2_i)
      F_trans <- qnorm(F_seq)
    } else {
      F_seq   <- pweibull(t_seq, shape = P2_i, scale = P1_i)
      F_trans <- log(1 / (1 - F_seq))
    }

    # Remove non-finite values at CDF extremes
    keep    <- is.finite(F_trans)
    t_seq   <- t_seq[keep]
    F_trans <- F_trans[keep]

    p <- p %>%
      add_trace(
        x = time_pts, y = prob_trans,
        type = "scatter", mode = "markers",
        marker = list(color = col_i),
        name = paste0("Stress ", stress_i),
        legendgroup = grp,
        text = paste0(
          "Stress: ", stress_i,
          ", Time: ", round(time_pts, signif),
          ", Prob: ", round(ppp_pts * 100, signif), "%"
        ),
        hoverinfo = "text"
      ) %>%
      add_trace(
        x = t_seq, y = F_trans,
        type = "scatter", mode = "lines",
        line = list(color = col_i),
        name = paste0("Fit ", stress_i),
        legendgroup = grp,
        showlegend = FALSE,
        hoverinfo = "skip"
      )

    # Optional Fisher-matrix confidence bounds
    if (isTRUE(showConf)) {
      tryCatch({
        wblr_fit_i <- WeibullR::wblr.fit(wblr_i, method.fit = "mle")
        wblr_fit_i <- WeibullR::wblr.conf(wblr_fit_i, method.conf = "fm")
        conf_data  <- wblr_fit_i$fit[[1]]$conf[[1]]$bounds

        if (!is.null(conf_data) &&
            !is.null(conf_data$Lower) && !is.null(conf_data$Upper)) {
          conf_unrel  <- conf_data$unrel
          conf_lower  <- conf_data$Lower
          conf_upper  <- conf_data$Upper

          conf_trans <- if (dist_type == "lognormal") {
            qnorm(conf_unrel)
          } else {
            log(1 / (1 - conf_unrel))
          }

          keep_conf   <- is.finite(conf_trans)
          conf_trans  <- conf_trans[keep_conf]
          conf_lower  <- conf_lower[keep_conf]
          conf_upper  <- conf_upper[keep_conf]

          fillcolor <- plotly::toRGB(col_i, 0.2)

          p <- p %>%
            add_trace(
              x = conf_lower, y = conf_trans,
              type = "scatter", mode = "lines",
              line = list(color = col_i, width = 1),
              showlegend = FALSE, legendgroup = grp,
              hoverinfo = "skip"
            ) %>%
            add_trace(
              x = conf_upper, y = conf_trans,
              type = "scatter", mode = "lines",
              fill = "tonexty", fillcolor = fillcolor,
              line = list(color = col_i, width = 1),
              showlegend = FALSE, legendgroup = grp,
              hoverinfo = "skip"
            )
        }
      }, error = function(e) NULL)
    }
  }

  # X-axis range from fit line extremes (covers the full 0.1%–99.9% range)
  xmin <- log10(min(all_t_seq, all_failures))
  xmax <- log10(max(all_t_seq, all_failures))

  p %>%
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
}
