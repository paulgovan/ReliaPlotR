# Create mock 'nhpp' class objects for testing
mock_nhpp_obj <- list(
  time          = c(100, 200, 300, 400, 500),
  event         = c(1, 2, 1, 3, 2),
  cum_events    = c(1, 3, 4, 7, 9),
  fitted_values = c(1.2, 3.1, 4.5, 7.2, 9.1),
  lower_bounds  = c(0.8, 2.5, 3.8, 6.1, 7.8),
  upper_bounds  = c(1.8, 4.0, 5.5, 8.6, 10.7),
  breakpoints   = NULL,
  model_type    = "Power Law",
  method        = "MLE",
  conf_level    = 0.95
)
class(mock_nhpp_obj) <- "nhpp"

mock_nhpp_bp <- list(
  time          = c(100, 200, 300, 400, 500),
  event         = c(1, 2, 1, 3, 2),
  cum_events    = c(1, 3, 4, 7, 9),
  fitted_values = c(1.2, 3.1, 4.5, 7.2, 9.1),
  lower_bounds  = c(0.8, 2.5, 3.8, 6.1, 7.8),
  upper_bounds  = c(1.8, 4.0, 5.5, 8.6, 10.7),
  breakpoints   = log(c(200, 400)),
  model_type    = "Power Law",
  method        = "MLE",
  conf_level    = 0.95
)
class(mock_nhpp_bp) <- "nhpp"

# Unit tests
test_that("plotly_nhpp throws an error for incorrect input class", {
  incorrect_obj <- list(time = 1:5, cum_events = 1:5)
  expect_error(plotly_nhpp(incorrect_obj), "All inputs must be of class 'nhpp'.")
})

test_that("plotly_nhpp returns a plotly object", {
  plot <- plotly_nhpp(mock_nhpp_obj)
  expect_s3_class(plot, "plotly")
})

test_that("plotly_nhpp works with default parameters", {
  plot <- plotly_nhpp(mock_nhpp_obj)
  expect_true(!is.null(plot))
  expect_s3_class(plot, "plotly")
})

test_that("plotly_nhpp works with custom color parameters", {
  plot <- plotly_nhpp(mock_nhpp_obj,
                      pointCol = "red", fitCol = "blue",
                      confCol = "green", gridCol = "yellow", breakCol = "purple")
  expect_s3_class(plot, "plotly")
})

test_that("plotly_nhpp respects the showGrid parameter", {
  plot_with_grid    <- plotly_nhpp(mock_nhpp_obj, showGrid = TRUE)
  plot_without_grid <- plotly_nhpp(mock_nhpp_obj, showGrid = FALSE)

  expect_equal(plot_with_grid$x$layoutAttrs[[1]]$xaxis$showgrid, TRUE)
  expect_equal(plot_with_grid$x$layoutAttrs[[1]]$yaxis$showgrid, TRUE)
  expect_equal(plot_without_grid$x$layoutAttrs[[1]]$xaxis$showgrid, FALSE)
  expect_equal(plot_without_grid$x$layoutAttrs[[1]]$yaxis$showgrid, FALSE)
})

test_that("plotly_nhpp includes hover text for data points", {
  plot <- plotly_nhpp(mock_nhpp_obj)
  hover_data <- plot$x$data[[1]]$text
  expect_true(all(grepl("Events: \\(", hover_data)))
})

test_that("plotly_nhpp respects showConf = FALSE", {
  plot_with_conf    <- plotly_nhpp(mock_nhpp_obj, showConf = TRUE)
  plot_without_conf <- plotly_nhpp(mock_nhpp_obj, showConf = FALSE)

  # With confidence: data + fit + lower + upper = 4 traces
  # Without confidence: data + fit = 2 traces
  expect_gt(length(plot_with_conf$x$attrs), length(plot_without_conf$x$attrs))
})

test_that("plotly_nhpp renders breakpoint shapes", {
  plot_no_bp <- plotly_nhpp(mock_nhpp_obj)
  plot_bp    <- plotly_nhpp(mock_nhpp_bp)

  shapes_no_bp <- plot_no_bp$x$layoutAttrs[[1]]$shapes
  shapes_bp    <- plot_bp$x$layoutAttrs[[1]]$shapes

  expect_equal(length(shapes_no_bp), 0)
  expect_equal(length(shapes_bp), 2)
})

test_that("plotly_nhpp accepts a list of nhpp objects and returns a plotly object", {
  plot <- plotly_nhpp(list(mock_nhpp_obj, mock_nhpp_obj))
  expect_s3_class(plot, "plotly")
})

test_that("plotly_nhpp overlay produces more traces than single object", {
  single  <- plotly_nhpp(mock_nhpp_obj)
  overlay <- plotly_nhpp(list(mock_nhpp_obj, mock_nhpp_obj))
  expect_gt(length(overlay$x$attrs), length(single$x$attrs))
})

test_that("plotly_nhpp overlay respects cols parameter", {
  plot <- plotly_nhpp(list(mock_nhpp_obj, mock_nhpp_obj), cols = c("red", "blue"))
  expect_s3_class(plot, "plotly")
})

test_that("plotly_nhpp throws error for non-nhpp input in list", {
  expect_error(
    plotly_nhpp(list(mock_nhpp_obj, list())),
    "All inputs must be of class 'nhpp'."
  )
})
