mock_rga_obj <- list(
  model = list(model = list(
    log_times        = log(c(100, 200, 300, 400, 500)),
    log_cum_failures = log(c(1, 3, 6, 10, 15))
  )),
  fitted_values = c(1.5, 3.5, 6.5, 10.5, 15.5),
  lower_bounds  = c(1.2, 3.2, 6.2, 10.2, 15.2),
  upper_bounds  = c(1.8, 3.8, 6.8, 10.8, 15.8),
  breakpoints   = c(200, 400)
)
class(mock_rga_obj) <- "rga"

test_that("tidy_rga stops for non-rga input", {
  expect_error(tidy_rga(list()), "class 'rga'")
})

test_that("tidy_rga returns a list with fitted and params", {
  result <- tidy_rga(mock_rga_obj)
  expect_type(result, "list")
  expect_named(result, c("fitted", "params"))
})

test_that("tidy_rga fitted is a data frame", {
  result <- tidy_rga(mock_rga_obj)
  expect_s3_class(result$fitted, "data.frame")
})

test_that("tidy_rga fitted has correct columns", {
  result <- tidy_rga(mock_rga_obj)
  expect_true(all(c("time", "cum_failures", "fitted", "lower", "upper") %in%
                    names(result$fitted)))
})

test_that("tidy_rga fitted has correct number of rows", {
  result <- tidy_rga(mock_rga_obj)
  expect_equal(nrow(result$fitted), 5)
})

test_that("tidy_rga recovers time on original scale", {
  result <- tidy_rga(mock_rga_obj)
  expect_equal(result$fitted$time, c(100, 200, 300, 400, 500))
})

test_that("tidy_rga recovers cum_failures on original scale", {
  result <- tidy_rga(mock_rga_obj)
  expect_equal(result$fitted$cum_failures, c(1, 3, 6, 10, 15))
})

test_that("tidy_rga fitted values match mock", {
  result <- tidy_rga(mock_rga_obj)
  expect_equal(result$fitted$fitted, c(1.5, 3.5, 6.5, 10.5, 15.5))
})

test_that("tidy_rga bounds match mock", {
  result <- tidy_rga(mock_rga_obj)
  expect_equal(result$fitted$lower, c(1.2, 3.2, 6.2, 10.2, 15.2))
  expect_equal(result$fitted$upper, c(1.8, 3.8, 6.8, 10.8, 15.8))
})

test_that("tidy_rga params is NULL or data frame", {
  result <- tidy_rga(mock_rga_obj)
  expect_true(is.null(result$params) || is.data.frame(result$params))
})

test_that("tidy_rga with list returns list of fitted data frames", {
  result <- tidy_rga(list(mock_rga_obj, mock_rga_obj))
  expect_type(result$fitted, "list")
  expect_length(result$fitted, 2)
  expect_s3_class(result$fitted[[1]], "data.frame")
})

test_that("tidy_rga with list returns list of params", {
  result <- tidy_rga(list(mock_rga_obj, mock_rga_obj))
  expect_type(result$params, "list")
  expect_length(result$params, 2)
})

test_that("tidy_rga throws error for non-rga input in list", {
  expect_error(tidy_rga(list(mock_rga_obj, list())), "class 'rga'")
})
