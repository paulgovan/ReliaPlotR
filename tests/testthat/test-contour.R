# Shared fixtures
failures  <- c(30, 49, 82, 90, 96)
failures2 <- c(20, 40, 60, 80, 100)
wblr_obj  <- wblr.conf(wblr.fit(wblr(failures),  method.fit = "mle"), method.conf = "lrb")
wblr_obj2 <- wblr.conf(wblr.fit(wblr(failures2), method.fit = "mle"), method.conf = "lrb")
wblr_lnorm <- wblr.conf(wblr.fit(wblr(failures), method.fit = "mle", dist = "lognormal"),
                         method.conf = "lrb")

test_that("plotly_contour runs without errors", {
  expect_silent(plotly_contour(wblr_obj))
})

test_that("plotly_contour returns a plotly object", {
  plot <- plotly_contour(wblr_obj)
  expect_s3_class(plot, "plotly")
})

test_that("plotly_contour handles invalid wblr_obj", {
  invalid_wblr_obj <- list(a = 1, b = 2)
  expect_error(plotly_contour(invalid_wblr_obj), "All inputs must be of class 'wblr'.")
})

test_that("plotly_contour handles wblr_obj without contours", {
  no_contour_wblr_obj <- wblr(failures)
  expect_error(plotly_contour(no_contour_wblr_obj), "Each wblr object must have contours generated using method.conf='lrb'.")
})

test_that("plotly_contour accepts a list of wblr objects", {
  plot <- plotly_contour(list(wblr_obj, wblr_obj2))
  expect_s3_class(plot, "plotly")
})

test_that("plotly_contour overlay produces more traces than single object", {
  single  <- plotly_contour(wblr_obj)
  overlay <- plotly_contour(list(wblr_obj, wblr_obj2))
  expect_gt(length(overlay$x$attrs), length(single$x$attrs))
})

test_that("plotly_contour overlay respects cols parameter", {
  plot <- plotly_contour(list(wblr_obj, wblr_obj2), cols = c("red", "blue"))
  expect_s3_class(plot, "plotly")
})

test_that("plotly_contour works with lognormal distribution", {
  plot <- plotly_contour(wblr_lnorm)
  expect_s3_class(plot, "plotly")
})

test_that("plotly_contour respects showGrid = FALSE", {
  plot <- plotly_contour(wblr_obj, showGrid = FALSE)
  expect_equal(plot$x$layoutAttrs[[1]]$xaxis$showgrid, FALSE)
  expect_equal(plot$x$layoutAttrs[[1]]$yaxis$showgrid, FALSE)
})

test_that("plotly_contour respects custom main, xlab, ylab", {
  plot <- plotly_contour(wblr_obj, main = "My Contour", xlab = "Scale", ylab = "Shape")
  expect_equal(plot$x$layoutAttrs[[1]]$title, "My Contour")
  expect_equal(plot$x$layoutAttrs[[1]]$xaxis$title, "Scale")
  expect_equal(plot$x$layoutAttrs[[1]]$yaxis$title, "Shape")
})

test_that("plotly_contour signif parameter rounds estimate hover text", {
  plot  <- plotly_contour(wblr_obj, signif = 2)
  built <- plotly::plotly_build(plot)
  # Second trace is the MLE estimate marker
  est_text <- built$x$data[[2]]$text
  expect_true(grepl("^Estimate:", est_text))
})
