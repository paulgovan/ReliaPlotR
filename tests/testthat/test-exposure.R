# Create a mock 'exposure' class object for testing
mock_exposure_obj <- list(
  time           = c(50, 150, 250, 350, 450),
  n_at_risk      = c(5L, 5L, 4L, 3L, 3L),
  cum_exposure   = c(250, 750, 1150, 1450, 1750),
  cum_events     = c(1, 3, 5, 7, 9),
  event_rate     = c(0.004, 0.004, 0.00435, 0.00483, 0.00514),
  total_exposure = 1750,
  total_events   = 9L,
  n_systems      = 5L,
  end_times      = c(A = 500, B = 500, C = 500, D = 400, E = 500)
)
class(mock_exposure_obj) <- "exposure"

# Unit tests
test_that("plotly_exposure throws an error for incorrect input class", {
  incorrect_obj <- list(time = 1:5, event_rate = 1:5)
  expect_error(plotly_exposure(incorrect_obj), "All inputs must be of class 'exposure'.")
})

test_that("plotly_exposure returns a plotly object", {
  plot <- plotly_exposure(mock_exposure_obj)
  expect_s3_class(plot, "plotly")
})

test_that("plotly_exposure works with default parameters", {
  plot <- plotly_exposure(mock_exposure_obj)
  expect_true(!is.null(plot))
  expect_s3_class(plot, "plotly")
})

test_that("plotly_exposure works with custom color parameters", {
  plot <- plotly_exposure(mock_exposure_obj, fitCol = "blue", gridCol = "yellow")
  expect_s3_class(plot, "plotly")
})

test_that("plotly_exposure respects the showGrid parameter", {
  plot_with_grid    <- plotly_exposure(mock_exposure_obj, showGrid = TRUE)
  plot_without_grid <- plotly_exposure(mock_exposure_obj, showGrid = FALSE)

  expect_equal(plot_with_grid$x$layoutAttrs[[1]]$xaxis$showgrid, TRUE)
  expect_equal(plot_with_grid$x$layoutAttrs[[1]]$yaxis$showgrid, TRUE)
  expect_equal(plot_without_grid$x$layoutAttrs[[1]]$xaxis$showgrid, FALSE)
  expect_equal(plot_without_grid$x$layoutAttrs[[1]]$yaxis$showgrid, FALSE)
})

test_that("plotly_exposure includes hover text for event rate trace", {
  plot <- plotly_exposure(mock_exposure_obj)
  hover_data <- plot$x$data[[1]]$text
  expect_true(all(grepl("Rate: \\(", hover_data)))
})

test_that("plotly_exposure accepts a list of exposure objects and returns a plotly object", {
  plot <- plotly_exposure(list(mock_exposure_obj, mock_exposure_obj))
  expect_s3_class(plot, "plotly")
})

test_that("plotly_exposure overlay produces more traces than single object", {
  single  <- plotly_exposure(mock_exposure_obj)
  overlay <- plotly_exposure(list(mock_exposure_obj, mock_exposure_obj))
  expect_gt(length(overlay$x$attrs), length(single$x$attrs))
})

test_that("plotly_exposure overlay respects cols parameter", {
  plot <- plotly_exposure(list(mock_exposure_obj, mock_exposure_obj), cols = c("red", "blue"))
  expect_s3_class(plot, "plotly")
})

test_that("plotly_exposure throws error for non-exposure input in list", {
  expect_error(
    plotly_exposure(list(mock_exposure_obj, list())),
    "All inputs must be of class 'exposure'."
  )
})
