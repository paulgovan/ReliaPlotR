test_that("plotly_wblr works with valid wblr object", {
  failures <- c(30, 49, 82, 90, 96)
  obj <- wblr.conf(wblr.fit(wblr(failures), method.fit = "mle"), method.conf = "lrb")
  p <- plotly_wblr(obj)
  expect_s3_class(p, "plotly")
})

test_that("plotly_wblr works with missing optional parameters", {
  failures <- c(30, 49, 82, 90, 96)
  obj <- wblr.conf(wblr.fit(wblr(failures), method.fit = "mle"), method.conf = "lrb")
  p <- plotly_wblr(obj, showConf = FALSE)
  expect_s3_class(p, "plotly")
})

test_that("plotly_wblr stops with invalid wblr object", {
  expect_error(plotly_wblr(list()), "Argument 'wblr_obj' is not of class 'wblr'.")
})

test_that("plotly_wblr stops with invalid susp argument", {
  failures <- c(30, 49, 82, 90, 96)
  obj <- wblr.conf(wblr.fit(wblr(failures), method.fit = "mle"), method.conf = "lrb")
  expect_error(plotly_wblr(obj, susp = "invalid"), "Argument 'susp' must be a numeric vector.")
})

test_that("plotly_wblr works with susp argument", {
  failures <- c(30, 49, 82, 90, 96)
  suspensions <- c(100, 150)
  obj <- wblr.conf(wblr.fit(wblr(failures), method.fit = "mle"), method.conf = "lrb")
  p <- plotly_wblr(obj, susp = suspensions)
  expect_s3_class(p, "plotly")
})

test_that("plotly_wblr generates plot with confidence intervals", {
  failures <- c(30, 49, 82, 90, 96)
  obj <- wblr.conf(wblr.fit(wblr(failures), method.fit = "mle"), method.conf = "lrb")
  p <- plotly_wblr(obj, showConf = TRUE)
  expect_s3_class(p, "plotly")
})

test_that("plotly_wblr generates plot without confidence intervals", {
  failures <- c(30, 49, 82, 90, 96)
  obj <- wblr.conf(wblr.fit(wblr(failures), method.fit = "mle"), method.conf = "lrb")
  p <- plotly_wblr(obj, showConf = FALSE)
  expect_s3_class(p, "plotly")
})

test_that("plotly_wblr works with different colors", {
  failures <- c(30, 49, 82, 90, 96)
  obj <- wblr.conf(wblr.fit(wblr(failures), method.fit = "mle"), method.conf = "lrb")
  p <- plotly_wblr(obj, probCol = "red", fitCol = "blue", confCol = "green", intCol = "purple", gridCol = "grey")
  expect_s3_class(p, "plotly")
})

test_that("plotly_wblr works with showGrid parameter", {
  failures <- c(30, 49, 82, 90, 96)
  obj <- wblr.conf(wblr.fit(wblr(failures), method.fit = "mle"), method.conf = "lrb")
  p <- plotly_wblr(obj, showGrid = TRUE)
  expect_s3_class(p, "plotly")
})

test_that("plotly_wblr handles subLayouts correctly", {
  failures <- c(30, 49, 82, 90, 96)
  suspensions <- c(100, 150)
  obj <- wblr.conf(wblr.fit(wblr(failures), method.fit = "mle"), method.conf = "lrb")

  p1 <- plotly_wblr(obj, showSusp = TRUE)
  expect_s3_class(p1, "plotly")

  p2 <- plotly_wblr(obj, showSusp = FALSE)
  expect_s3_class(p2, "plotly")
})

test_that("plotly_wblr accepts a list of wblr objects and returns a plotly object", {
  failures1 <- c(30, 49, 82, 90, 96)
  failures2 <- c(20, 40, 60, 80, 100)
  obj1 <- wblr.conf(wblr.fit(wblr(failures1), method.fit = "mle"), method.conf = "lrb")
  obj2 <- wblr.conf(wblr.fit(wblr(failures2), method.fit = "mle"), method.conf = "lrb")
  plot <- plotly_wblr(list(obj1, obj2))
  expect_s3_class(plot, "plotly")
})

test_that("plotly_wblr overlay produces more traces than single object", {
  failures1 <- c(30, 49, 82, 90, 96)
  failures2 <- c(20, 40, 60, 80, 100)
  obj1 <- wblr.conf(wblr.fit(wblr(failures1), method.fit = "mle"), method.conf = "lrb")
  obj2 <- wblr.conf(wblr.fit(wblr(failures2), method.fit = "mle"), method.conf = "lrb")
  single <- plotly_wblr(obj1)
  overlay <- plotly_wblr(list(obj1, obj2))
  expect_gt(length(overlay$x$attrs), length(single$x$attrs))
})

test_that("plotly_wblr overlay respects cols parameter", {
  failures1 <- c(30, 49, 82, 90, 96)
  failures2 <- c(20, 40, 60, 80, 100)
  obj1 <- wblr.conf(wblr.fit(wblr(failures1), method.fit = "mle"), method.conf = "lrb")
  obj2 <- wblr.conf(wblr.fit(wblr(failures2), method.fit = "mle"), method.conf = "lrb")
  plot <- plotly_wblr(list(obj1, obj2), cols = c("red", "blue"))
  expect_s3_class(plot, "plotly")
})

test_that("plotly_wblr throws error when mixing distribution types", {
  failures <- c(30, 49, 82, 90, 96)
  obj_weibull <- wblr.conf(wblr.fit(wblr(failures), method.fit = "mle"), method.conf = "lrb")
  obj_lognormal <- wblr.conf(
    wblr.fit(wblr(failures), method.fit = "mle", dist = "lognormal"),
    method.conf = "lrb"
  )
  expect_error(
    plotly_wblr(list(obj_weibull, obj_lognormal)),
    "All wblr objects must use the same distribution for overlay."
  )
})

test_that("plotly_wblr throws error for non-wblr input in list", {
  failures <- c(30, 49, 82, 90, 96)
  obj <- wblr.conf(wblr.fit(wblr(failures), method.fit = "mle"), method.conf = "lrb")
  expect_error(
    plotly_wblr(list(obj, list())),
    "All inputs must be of class 'wblr'."
  )
})

test_that("plotly_wblr warns and ignores susp when multiple objects provided", {
  failures1 <- c(30, 49, 82, 90, 96)
  failures2 <- c(20, 40, 60, 80, 100)
  obj1 <- wblr.conf(wblr.fit(wblr(failures1), method.fit = "mle"), method.conf = "lrb")
  obj2 <- wblr.conf(wblr.fit(wblr(failures2), method.fit = "mle"), method.conf = "lrb")
  expect_warning(
    plotly_wblr(list(obj1, obj2), susp = c(110, 120)),
    "'susp' is ignored"
  )
})

test_that("plotly_wblr hover text labels are correct for confidence bounds", {
  failures <- c(30, 49, 82, 90, 96)
  obj <- wblr.conf(wblr.fit(wblr(failures), method.fit = "mle"), method.conf = "lrb")
  p <- plotly_wblr(obj, showConf = TRUE)

  # Build to resolve lazy attrs into data
  built <- plotly::plotly_build(p)

  # Trace 3 is the lower bound, trace 4 is the upper bound
  lower_hover <- built$x$data[[3]]$text
  upper_hover <- built$x$data[[4]]$text
  expect_true(all(grepl("^Lower:", lower_hover)))
  expect_true(all(grepl("^Upper:", upper_hover)))
})
