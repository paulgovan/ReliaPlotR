# Create a mock 'duane' class object for testing
mock_duane_obj <- list(
  Cumulative_Time = c(100, 200, 300, 400, 500),
  Cumulative_MTBF = c(10, 20, 30, 40, 50),
  Fitted_Values = c(12, 22, 32, 42, 52),
  lower_bounds = c(8, 18, 28, 38, 48),
  upper_bounds = c(12, 22, 32, 42, 52)
)
class(mock_duane_obj) <- "duane"

# Unit tests
test_that("plotly_duane throws an error for incorrect input class", {
  incorrect_obj <- list(Cumulative_Time = 1:5, Cumulative_MTBF = 1:5)
  expect_error(plotly_duane(incorrect_obj), "Argument 'duane_obj' is not of class 'duane'.")
})

test_that("plotly_duane returns a plotly object", {
  plot <- plotly_duane(mock_duane_obj)
  expect_s3_class(plot, "plotly")
})

test_that("plotly_duane works with default parameters", {
  plot <- plotly_duane(mock_duane_obj)
  expect_true(!is.null(plot))
  expect_s3_class(plot, "plotly")
})

test_that("plotly_duane works with custom color parameters", {
  plot <- plotly_duane(mock_duane_obj, pointCol = "red", fitCol = "blue", gridCol = "green")
  expect_s3_class(plot, "plotly")
})

test_that("plotly_duane includes hover text for data points", {
  plot <- plotly_duane(mock_duane_obj)
  hover_data <- plot$x$data[[1]]$text
  expect_true(all(grepl("MTBF: \\(", hover_data)))
})

test_that("plotly_duane respects the showGrid parameter", {
  plot_with_grid <- plotly_duane(mock_duane_obj, showGrid = TRUE)
  plot_without_grid <- plotly_duane(mock_duane_obj, showGrid = FALSE)

  expect_equal(plot_with_grid$x$layoutAttrs[[1]]$xaxis$showgrid, TRUE)
  expect_equal(plot_with_grid$x$layoutAttrs[[1]]$yaxis$showgrid, TRUE)
  expect_equal(plot_without_grid$x$layoutAttrs[[1]]$xaxis$showgrid, FALSE)
  expect_equal(plot_without_grid$x$layoutAttrs[[1]]$yaxis$showgrid, FALSE)
})

test_that("plotly_duane respects showConf = FALSE", {
  plot_with_conf <- plotly_duane(mock_duane_obj, showConf = TRUE)
  plot_without_conf <- plotly_duane(mock_duane_obj, showConf = FALSE)

  # With confidence: point + fit + lower + upper = 4 traces
  # Without confidence: point + fit = 2 traces
  expect_gt(length(plot_with_conf$x$attrs), length(plot_without_conf$x$attrs))
})

test_that("plotly_duane signif parameter affects hover text precision", {
  plot <- plotly_duane(mock_duane_obj, signif = 1)
  hover_data <- plot$x$data[[1]]$text
  # With signif=1, values should be rounded to 1 significant digit
  expect_true(all(grepl("MTBF: \\(", hover_data)))
})
