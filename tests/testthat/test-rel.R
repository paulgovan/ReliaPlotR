# Shared mock 'alt' object for relationship plot tests.
# Must have gone through alt.fit() — needs $alt_coef and $parallel_par.
mock_alt_rel <- list(
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
  alt_coef     = c(11.206, -0.01606),
  goal         = NULL
)
class(mock_alt_rel) <- "alt"

# Power Law variant
mock_alt_power <- mock_alt_rel
mock_alt_power$alt.model <- "power"

# Lognormal variant
mock_alt_lnorm_rel <- mock_alt_rel
mock_alt_lnorm_rel$dist         <- "lognormal"
mock_alt_lnorm_rel$parallel_par <- data.frame(
  P1     = log(c(615.97, 231.86)),
  P2     = c(0.55, 0.55),
  stress = c(300, 350),
  wt     = c(3L, 3L)
)

# Variant with a goal condition
mock_alt_goal <- mock_alt_rel
mock_alt_goal$goal <- list(
  stress = 250,
  data   = data.frame(left = numeric(0), right = numeric(0), qty = integer(0))
)

# --- Tests -------------------------------------------------------------------

test_that("plotly_rel throws error for incorrect input class", {
  expect_error(plotly_rel(list()), "not of class 'alt'")
})

test_that("plotly_rel throws error when alt_coef is missing", {
  obj <- mock_alt_rel
  obj$alt_coef <- NULL
  expect_error(plotly_rel(obj), "alt.fit\\(\\)")
})

test_that("plotly_rel returns a plotly object", {
  p <- plotly_rel(mock_alt_rel)
  expect_s3_class(p, "plotly")
})

test_that("plotly_rel has more traces when showPerc = TRUE than FALSE", {
  p_with  <- plotly_rel(mock_alt_rel, showPerc = TRUE)
  p_without <- plotly_rel(mock_alt_rel, showPerc = FALSE)
  expect_gt(length(p_with$x$attrs), length(p_without$x$attrs))
})

test_that("plotly_rel showPerc = FALSE has fewer traces than showPerc = TRUE", {
  p_with    <- plotly_rel(mock_alt_rel, showPerc = TRUE)
  p_without <- plotly_rel(mock_alt_rel, showPerc = FALSE)
  # showPerc=TRUE adds one trace per percentile vs. showPerc=FALSE
  expect_gt(length(p_with$x$attrs), length(p_without$x$attrs))
})

test_that("plotly_rel custom percentiles change trace count", {
  p_two  <- plotly_rel(mock_alt_rel, percentiles = c(10, 90))
  p_one  <- plotly_rel(mock_alt_rel, percentiles = 50)
  # 2 percentile traces vs 1
  expect_gt(length(p_two$x$attrs), length(p_one$x$attrs))
})

test_that("plotly_rel showGoal adds a trace when goal is present", {
  p_no_goal <- plotly_rel(mock_alt_goal, showGoal = FALSE)
  p_goal    <- plotly_rel(mock_alt_goal, showGoal = TRUE)
  expect_gt(length(p_goal$x$attrs), length(p_no_goal$x$attrs))
})

test_that("plotly_rel uses log x-axis for Power Law model", {
  p <- plotly_rel(mock_alt_power)
  expect_equal(p$x$layoutAttrs[[1]]$xaxis$type, "log")
})

test_that("plotly_rel uses linear x-axis for Arrhenius model", {
  p <- plotly_rel(mock_alt_rel)
  expect_equal(p$x$layoutAttrs[[1]]$xaxis$type, "linear")
})

test_that("plotly_rel y-axis is always log scale", {
  p <- plotly_rel(mock_alt_rel)
  expect_equal(p$x$layoutAttrs[[1]]$yaxis$type, "log")
})

test_that("plotly_rel works with lognormal distribution", {
  p <- plotly_rel(mock_alt_lnorm_rel)
  expect_s3_class(p, "plotly")
})

test_that("plotly_rel respects showGrid = FALSE", {
  p <- plotly_rel(mock_alt_rel, showGrid = FALSE)
  expect_equal(p$x$layoutAttrs[[1]]$xaxis$showgrid, FALSE)
  expect_equal(p$x$layoutAttrs[[1]]$yaxis$showgrid, FALSE)
})
