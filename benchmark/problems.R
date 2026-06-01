# Problem definitions for the agentic reliability pilot.
#
# Each problem is a list with:
#   id        : short identifier
#   domain    : life | alt | growth | repairable
#   prompt    : the natural-language question posed to the agent (data inline)
#   answer_key: character vector of numeric field names the agent must report
#   tol       : named relative-error tolerance per field (default applied in grade.R)
#   truth_fun : function() -> named numeric list; the canonical R ground truth
#               (used only by make_ground_truth.R, never shown to the agent)
#
# The truth_fun bodies deliberately mirror the pipelines wrapped by the MCP
# tools, so the "correct" answer is whatever the canonical packages produce.

suppressMessages({
  library(WeibullR)
  library(WeibullR.ALT)
  library(ReliaGrowR)
})

# Helper: extract beta/eta (or mulog/sigmalog) from a fitted wblr object.
.wblr_params <- function(failures, suspensions = NULL, dist = "weibull",
                         method_fit = "mle") {
  obj <- WeibullR::wblr(failures, suspensions)
  obj <- WeibullR::wblr.fit(obj, dist = dist, method.fit = method_fit)
  ReliaPlotR::tidy_wblr(obj)$estimates
}

PROBLEMS <- list(

  list(
    id = "01_weibull_mle",
    domain = "life",
    prompt = paste(
      "Five units were tested to failure with no censoring. The failure times",
      "in hours are: 30, 49, 82, 90, 96.",
      "Fit a two-parameter Weibull distribution by maximum likelihood (MLE)."
    ),
    answer_key = c("beta", "eta"),
    truth_fun = function() {
      e <- .wblr_params(c(30, 49, 82, 90, 96), dist = "weibull", method_fit = "mle")
      list(beta = e$param1, eta = e$param2)
    }
  ),

  list(
    id = "02_weibull_rr",
    domain = "life",
    prompt = paste(
      "Failure times (hours), complete data: 30, 49, 82, 90, 96.",
      "Fit a two-parameter Weibull distribution using median-rank regression",
      "(X-on-Y, 'rr-xony'). Report the shape, scale, and the R-squared",
      "goodness-of-fit value."
    ),
    answer_key = c("beta", "eta", "r2"),
    tol = c(r2 = 0.02),
    truth_fun = function() {
      e <- .wblr_params(c(30, 49, 82, 90, 96), dist = "weibull", method_fit = "rr-xony")
      list(beta = e$param1, eta = e$param2, r2 = e$gof_value)
    }
  ),

  list(
    id = "03_weibull_susp",
    domain = "life",
    prompt = paste(
      "A test produced 5 failures at 30, 49, 82, 90, 96 hours and 3 units were",
      "still running (right-censored / suspended) at 100, 120, and 150 hours.",
      "Fit a two-parameter Weibull distribution by MLE, accounting for the",
      "suspensions."
    ),
    answer_key = c("beta", "eta"),
    truth_fun = function() {
      e <- .wblr_params(c(30, 49, 82, 90, 96), c(100, 120, 150),
                        dist = "weibull", method_fit = "mle")
      list(beta = e$param1, eta = e$param2)
    }
  ),

  list(
    id = "04_lognormal_mle",
    domain = "life",
    prompt = paste(
      "Failure times (hours), complete data:",
      "120, 165, 210, 260, 310, 410, 520.",
      "Fit a lognormal distribution by MLE. Report the log-mean (mulog) and",
      "log-standard-deviation (sigmalog)."
    ),
    answer_key = c("mulog", "sigmalog"),
    truth_fun = function() {
      e <- .wblr_params(c(120, 165, 210, 260, 310, 410, 520),
                        dist = "lognormal", method_fit = "mle")
      list(mulog = e$param1, sigmalog = e$param2)
    }
  ),

  list(
    id = "05_weibull3p",
    domain = "life",
    prompt = paste(
      "Failure times (hours): 130, 149, 182, 190, 196, 210, 240.",
      "Fit a three-parameter Weibull distribution (with a location/threshold",
      "parameter gamma) by MLE. Report shape (beta), scale (eta), and the",
      "threshold (gamma)."
    ),
    answer_key = c("beta", "eta", "gamma"),
    tol = c(gamma = 0.10),
    truth_fun = function() {
      e <- .wblr_params(c(130, 149, 182, 190, 196, 210, 240),
                        dist = "weibull3p", method_fit = "mle")
      list(beta = e$param1, eta = e$param2, gamma = e$param3)
    }
  ),

  list(
    id = "06_b10_life",
    domain = "life",
    prompt = paste(
      "Failure times (hours), complete data: 30, 49, 82, 90, 96.",
      "Fit a two-parameter Weibull distribution by MLE and report the B10 life",
      "(the time by which 10% of the population is expected to fail), in hours."
    ),
    answer_key = c("b10"),
    truth_fun = function() {
      e <- .wblr_params(c(30, 49, 82, 90, 96), dist = "weibull", method_fit = "mle")
      list(b10 = e$param2 * (-log(0.90))^(1 / e$param1))
    }
  ),

  list(
    id = "07_alt_arrhenius",
    domain = "alt",
    prompt = paste(
      "An accelerated life test ran at three temperature stress levels (Kelvin).",
      "Failure times (hours) by stress:",
      "300 K: 248, 456, 528, 731, 813, 537;",
      "350 K: 164, 176, 289;",
      "400 K: 88, 112, 152.",
      "Fit a Weibull life distribution with an Arrhenius life-stress",
      "relationship. Report the two life-stress coefficients coef1 and coef2",
      "(the intercept and slope of the log-linear Arrhenius model)."
    ),
    answer_key = c("coef1", "coef2"),
    tol = c(coef2 = 0.10),
    truth_fun = function() {
      d1 <- WeibullR.ALT::alt.data(c(248, 456, 528, 731, 813, 537), stress = 300)
      d2 <- WeibullR.ALT::alt.data(c(164, 176, 289), stress = 350)
      d3 <- WeibullR.ALT::alt.data(c(88, 112, 152), stress = 400)
      obj <- WeibullR.ALT::alt.fit(WeibullR.ALT::alt.parallel(
        WeibullR.ALT::alt.make(list(d1, d2, d3), dist = "weibull",
                               alt.model = "arrhenius", view_dist_fits = FALSE),
        view_parallel_fits = FALSE))
      r <- ReliaPlotR::tidy_alt(obj)$relationship
      list(coef1 = r$coef1, coef2 = r$coef2)
    }
  ),

  list(
    id = "08_alt_power",
    domain = "alt",
    prompt = paste(
      "An accelerated life test applied three levels of a non-thermal stress",
      "(e.g. voltage). Failure times (hours) by stress:",
      "10: 980, 1230, 1410, 1620, 1875;",
      "20: 340, 410, 505, 590;",
      "30: 120, 160, 195, 240.",
      "Fit a Weibull life distribution with an inverse power law life-stress",
      "relationship. Report the two life-stress coefficients coef1 and coef2."
    ),
    answer_key = c("coef1", "coef2"),
    tol = c(coef1 = 0.10, coef2 = 0.10),
    truth_fun = function() {
      d1 <- WeibullR.ALT::alt.data(c(980, 1230, 1410, 1620, 1875), stress = 10)
      d2 <- WeibullR.ALT::alt.data(c(340, 410, 505, 590), stress = 20)
      d3 <- WeibullR.ALT::alt.data(c(120, 160, 195, 240), stress = 30)
      obj <- WeibullR.ALT::alt.fit(WeibullR.ALT::alt.parallel(
        WeibullR.ALT::alt.make(list(d1, d2, d3), dist = "weibull",
                               alt.model = "power", view_dist_fits = FALSE),
        view_parallel_fits = FALSE))
      r <- ReliaPlotR::tidy_alt(obj)$relationship
      list(coef1 = r$coef1, coef2 = r$coef2)
    }
  ),

  list(
    id = "09_crow_amsaa",
    domain = "growth",
    prompt = paste(
      "During a reliability growth test, failures were recorded at the",
      "following cumulative test times (hours): 100, 200, 300, 400, 500,",
      "with the number of failures at each time being 2, 1, 3, 1, 2",
      "respectively. Fit a Crow-AMSAA (Power Law NHPP) reliability growth",
      "model by least squares. Report the scale parameter lambda and the shape",
      "parameter beta."
    ),
    answer_key = c("lambda", "beta"),
    truth_fun = function() {
      obj <- ReliaGrowR::rga(c(100, 200, 300, 400, 500), c(2, 1, 3, 1, 2))
      p <- ReliaPlotR::tidy_rga(obj)$params
      list(lambda = p$lambda, beta = p$beta)
    }
  ),

  list(
    id = "10_duane",
    domain = "repairable",
    prompt = paste(
      "Cumulative failure data from a development program showing reliability",
      "growth: at cumulative test times (hours) 100, 300, 600, 1000, 1500 the",
      "cumulative number of failures was 5, 9, 12, 14, 16 respectively.",
      "Fit a Duane reliability growth model (log-log regression of cumulative",
      "MTBF vs cumulative time). Report the regression slope and intercept",
      "(on the log-log scale)."
    ),
    answer_key = c("slope", "intercept"),
    tol = c(slope = 0.08, intercept = 0.10),
    truth_fun = function() {
      # Duane: log(cum MTBF) ~ log(cum time); cum MTBF = cum_time / cum_failures
      t  <- c(100, 300, 600, 1000, 1500)
      cf <- c(5, 9, 12, 14, 16)
      fit <- stats::lm(log(t / cf) ~ log(t))
      list(intercept = unname(stats::coef(fit)[1]),
           slope     = unname(stats::coef(fit)[2]))
    }
  )
)
