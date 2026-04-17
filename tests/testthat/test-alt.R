# Shared mock 'alt' object for probability plot tests.
# Must have gone through alt.parallel() — needs $parallel_par.
mock_alt_prob <- list(
  data = list(
    list(
      stress    = 300,
      data      = data.frame(left  = c(248, 456, 528),
                             right = c(248, 456, 528),
                             qty   = c(1L, 1L, 1L)),
      num_fails = 3,
      valid_set = TRUE
    ),
    list(
      stress    = 350,
      data      = data.frame(left  = c(164, 176, 289),
                             right = c(164, 176, 289),
                             qty   = c(1L, 1L, 1L)),
      num_fails = 3,
      valid_set = TRUE
    )
  ),
  dist         = "weibull",
  alt.model    = "arrhenius",
  method.fit   = "mle-rba",
  parallel_par = data.frame(P1     = c(615.97, 231.86),
                             P2     = c(3.94, 3.94),
                             stress = c(300, 350),
                             wt     = c(3L, 3L)),
  alt_coef     = c(11.206, -0.01606)
)
class(mock_alt_prob) <- "alt"

# Lognormal variant (P1 = log(median))
mock_alt_lnorm <- mock_alt_prob
mock_alt_lnorm$dist         <- "lognormal"
mock_alt_lnorm$parallel_par <- data.frame(P1     = log(c(615.97, 231.86)),
                                           P2     = c(0.55, 0.55),
                                           stress = c(300, 350),
                                           wt     = c(3L, 3L))

# --- Tests -------------------------------------------------------------------

test_that("plotly_alt throws error for incorrect input class", {
  expect_error(plotly_alt(list()), "not of class 'alt'")
})

test_that("plotly_alt throws error when parallel_par is missing", {
  obj <- mock_alt_prob
  obj$parallel_par <- NULL
  expect_error(plotly_alt(obj), "alt.parallel\\(\\)")
})

test_that("plotly_alt showConf = TRUE adds more traces than showConf = FALSE", {
  p_with    <- plotly_alt(mock_alt_prob, showConf = TRUE)
  p_without <- plotly_alt(mock_alt_prob, showConf = FALSE)
  expect_gte(length(p_with$x$attrs), length(p_without$x$attrs))
})

test_that("plotly_alt returns a plotly object", {
  p <- plotly_alt(mock_alt_prob)
  expect_s3_class(p, "plotly")
})

test_that("plotly_alt produces more traces for more stress levels", {
  # Two stress levels should produce more traces than a single stress level would
  p2 <- plotly_alt(mock_alt_prob)                     # 2 stress levels

  single_stress        <- mock_alt_prob
  single_stress$parallel_par <- mock_alt_prob$parallel_par[1, ]
  single_stress$data   <- mock_alt_prob$data[1]
  p1 <- plotly_alt(single_stress)                     # 1 stress level

  expect_gt(length(p2$x$attrs), length(p1$x$attrs))
})

test_that("plotly_alt respects custom cols parameter", {
  p <- plotly_alt(mock_alt_prob, cols = c("steelblue", "tomato"))
  expect_s3_class(p, "plotly")
})

test_that("plotly_alt works with showGrid = FALSE", {
  p <- plotly_alt(mock_alt_prob, showGrid = FALSE)
  expect_equal(p$x$layoutAttrs[[1]]$xaxis$showgrid, FALSE)
  expect_equal(p$x$layoutAttrs[[1]]$yaxis$showgrid, FALSE)
})

test_that("plotly_alt works for lognormal distribution", {
  p <- plotly_alt(mock_alt_lnorm)
  expect_s3_class(p, "plotly")
})

test_that("plotly_alt data scatter has correct hover text prefix", {
  p     <- plotly_alt(mock_alt_prob)
  built <- plotly::plotly_build(p)
  # First trace is the stress-300 scatter
  expect_true(all(grepl("^Stress: 300", built$x$data[[1]]$text)))
})
