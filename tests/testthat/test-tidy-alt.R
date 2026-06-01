mock_alt_full <- list(
  data = list(
    list(stress = 300, data = data.frame(left  = c(248, 456, 528),
                                         right = c(248, 456, 528),
                                         qty   = c(1L, 1L, 1L)),
         num_fails = 3L, valid_set = TRUE),
    list(stress = 350, data = data.frame(left  = c(164, 176, 289),
                                         right = c(164, 176, 289),
                                         qty   = c(1L, 1L, 1L)),
         num_fails = 3L, valid_set = TRUE)
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
class(mock_alt_full) <- "alt"

mock_alt_no_fit <- mock_alt_full
mock_alt_no_fit$alt_coef <- NULL

test_that("tidy_alt stops for non-alt input", {
  expect_error(tidy_alt(list()), "not of class 'alt'")
})

test_that("tidy_alt stops when parallel_par is missing", {
  obj <- mock_alt_full
  obj$parallel_par <- NULL
  expect_error(tidy_alt(obj), "alt.parallel\\(\\)")
})

test_that("tidy_alt returns a list with parallel and relationship", {
  result <- tidy_alt(mock_alt_full)
  expect_type(result, "list")
  expect_named(result, c("parallel", "relationship"))
})

test_that("tidy_alt parallel is a data frame", {
  result <- tidy_alt(mock_alt_full)
  expect_s3_class(result$parallel, "data.frame")
})

test_that("tidy_alt parallel has correct columns", {
  result <- tidy_alt(mock_alt_full)
  expect_true(all(c("stress", "P1", "P2", "wt", "n_failures") %in%
                    names(result$parallel)))
})

test_that("tidy_alt parallel has one row per stress level", {
  result <- tidy_alt(mock_alt_full)
  expect_equal(nrow(result$parallel), 2)
})

test_that("tidy_alt parallel stress values are correct", {
  result <- tidy_alt(mock_alt_full)
  expect_equal(result$parallel$stress, c(300, 350))
})

test_that("tidy_alt parallel P1 values are correct", {
  result <- tidy_alt(mock_alt_full)
  expect_equal(result$parallel$P1, c(615.97, 231.86))
})

test_that("tidy_alt parallel n_failures matches mock", {
  result <- tidy_alt(mock_alt_full)
  expect_equal(result$parallel$n_failures, c(3L, 3L))
})

test_that("tidy_alt relationship is a data frame when alt_coef present", {
  result <- tidy_alt(mock_alt_full)
  expect_s3_class(result$relationship, "data.frame")
})

test_that("tidy_alt relationship has correct columns", {
  result <- tidy_alt(mock_alt_full)
  expect_true(all(c("model", "coef1", "coef2") %in% names(result$relationship)))
})

test_that("tidy_alt relationship coef values are correct", {
  result <- tidy_alt(mock_alt_full)
  expect_equal(result$relationship$coef1, 11.206)
  expect_equal(result$relationship$coef2, -0.01606)
})

test_that("tidy_alt relationship is NULL when alt.fit not called", {
  expect_message(result <- tidy_alt(mock_alt_no_fit), "alt.fit")
  expect_null(result$relationship)
})

test_that("tidy_alt parallel still returned when relationship is NULL", {
  suppressMessages(result <- tidy_alt(mock_alt_no_fit))
  expect_s3_class(result$parallel, "data.frame")
  expect_equal(nrow(result$parallel), 2)
})
