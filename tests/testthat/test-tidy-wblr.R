failures <- c(30, 49, 82, 90, 96)
obj_mle <- wblr.conf(wblr.fit(wblr(failures), method.fit = "mle"), method.conf = "lrb")
obj_rr  <- wblr.conf(wblr.fit(wblr(failures)))

test_that("tidy_wblr stops for non-wblr input", {
  expect_error(tidy_wblr(list()), "not of class 'wblr'")
})

test_that("tidy_wblr stops for unfitted wblr object", {
  expect_error(tidy_wblr(wblr(failures)), "wblr.fit")
})

test_that("tidy_wblr returns a list with estimates and bounds", {
  result <- tidy_wblr(obj_mle)
  expect_type(result, "list")
  expect_named(result, c("estimates", "bounds"))
})

test_that("tidy_wblr estimates is a data frame", {
  result <- tidy_wblr(obj_mle)
  expect_s3_class(result$estimates, "data.frame")
})

test_that("tidy_wblr estimates has correct columns", {
  result <- tidy_wblr(obj_mle)
  expected_cols <- c(
    "dist", "method_fit",
    "param1_name", "param1", "param2_name", "param2",
    "param3_name", "param3",
    "gof_metric", "gof_value", "method_conf", "n_failures"
  )
  expect_true(all(expected_cols %in% names(result$estimates)))
})

test_that("tidy_wblr extracts Weibull Beta and Eta for MLE", {
  result <- tidy_wblr(obj_mle)
  est <- result$estimates
  expect_equal(est$dist, "weibull")
  expect_equal(est$param1_name, "Beta")
  expect_equal(est$param2_name, "Eta")
  expect_true(is.numeric(est$param1) && est$param1 > 0)
  expect_true(is.numeric(est$param2) && est$param2 > 0)
})

test_that("tidy_wblr reports loglikelihood GoF for MLE", {
  result <- tidy_wblr(obj_mle)
  expect_equal(result$estimates$gof_metric, "loglikelihood")
  expect_true(is.numeric(result$estimates$gof_value))
})

test_that("tidy_wblr reports R2 GoF for rank regression", {
  result <- tidy_wblr(obj_rr)
  expect_equal(result$estimates$gof_metric, "R2")
  expect_true(result$estimates$gof_value >= 0 && result$estimates$gof_value <= 1)
})

test_that("tidy_wblr bounds is a data frame for single object", {
  result <- tidy_wblr(obj_mle)
  expect_s3_class(result$bounds, "data.frame")
})

test_that("tidy_wblr n_failures matches input", {
  result <- tidy_wblr(obj_mle)
  expect_equal(result$estimates$n_failures, length(failures))
})

test_that("tidy_wblr works with lognormal distribution", {
  obj_ln <- wblr.conf(wblr.fit(wblr(failures), dist = "lognormal", method.fit = "mle"),
                      method.conf = "fm")
  result  <- tidy_wblr(obj_ln)
  est     <- result$estimates
  expect_equal(est$dist, "lognormal")
  expect_equal(est$param1_name, "Mulog")
  expect_equal(est$param2_name, "Sigmalog")
})

test_that("tidy_wblr works with weibull3p distribution", {
  f3 <- c(25, 30, 42, 49, 55, 67, 73, 82, 90, 96, 101, 110, 120, 132, 145)
  obj3p <- wblr.conf(wblr.fit(wblr(f3), dist = "weibull3p"))
  result  <- tidy_wblr(obj3p)
  est     <- result$estimates
  expect_equal(est$dist, "weibull3p")
  expect_equal(est$param3_name, "Gamma")
  expect_false(is.na(est$param3))
})

test_that("tidy_wblr with list returns one row per object", {
  obj2   <- wblr.conf(wblr.fit(wblr(c(20, 40, 60, 80, 100)), method.fit = "mle"),
                      method.conf = "lrb")
  result <- tidy_wblr(list(obj_mle, obj2))
  expect_equal(nrow(result$estimates), 2)
})

test_that("tidy_wblr with list returns list of bounds", {
  obj2   <- wblr.conf(wblr.fit(wblr(c(20, 40, 60, 80, 100)), method.fit = "mle"),
                      method.conf = "lrb")
  result <- tidy_wblr(list(obj_mle, obj2))
  expect_type(result$bounds, "list")
  expect_length(result$bounds, 2)
})
