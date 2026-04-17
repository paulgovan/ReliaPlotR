# Create a mock 'mcf' class object for testing
mock_mcf_obj <- list(
  time         = c(50, 150, 250, 350, 450),
  mcf          = c(0.2, 0.5, 0.9, 1.3, 1.8),
  variance     = c(0.01, 0.03, 0.06, 0.10, 0.15),
  lower_bounds = c(0.1, 0.3, 0.6, 0.9, 1.3),
  upper_bounds = c(0.4, 0.8, 1.3, 1.8, 2.4),
  conf_level   = 0.95,
  n_systems    = 3L,
  n_events     = 9L,
  end_times    = c(A = 500, B = 500, C = 500)
)
class(mock_mcf_obj) <- "mcf"

# Unit tests
test_that("plotly_mcf throws an error for incorrect input class", {
  incorrect_obj <- list(time = 1:5, mcf = 1:5)
  expect_error(plotly_mcf(incorrect_obj), "All inputs must be of class 'mcf'.")
})

test_that("plotly_mcf returns a plotly object", {
  plot <- plotly_mcf(mock_mcf_obj)
  expect_s3_class(plot, "plotly")
})

test_that("plotly_mcf works with default parameters", {
  plot <- plotly_mcf(mock_mcf_obj)
  expect_true(!is.null(plot))
  expect_s3_class(plot, "plotly")
})

test_that("plotly_mcf works with custom color parameters", {
  plot <- plotly_mcf(mock_mcf_obj, fitCol = "blue", confCol = "green", gridCol = "yellow")
  expect_s3_class(plot, "plotly")
})

test_that("plotly_mcf respects the showGrid parameter", {
  plot_with_grid    <- plotly_mcf(mock_mcf_obj, showGrid = TRUE)
  plot_without_grid <- plotly_mcf(mock_mcf_obj, showGrid = FALSE)

  expect_equal(plot_with_grid$x$layoutAttrs[[1]]$xaxis$showgrid, TRUE)
  expect_equal(plot_with_grid$x$layoutAttrs[[1]]$yaxis$showgrid, TRUE)
  expect_equal(plot_without_grid$x$layoutAttrs[[1]]$xaxis$showgrid, FALSE)
  expect_equal(plot_without_grid$x$layoutAttrs[[1]]$yaxis$showgrid, FALSE)
})

test_that("plotly_mcf includes hover text for MCF trace", {
  plot <- plotly_mcf(mock_mcf_obj)
  hover_data <- plot$x$data[[1]]$text
  expect_true(all(grepl("MCF: \\(", hover_data)))
})

test_that("plotly_mcf respects showConf = FALSE", {
  plot_with_conf    <- plotly_mcf(mock_mcf_obj, showConf = TRUE)
  plot_without_conf <- plotly_mcf(mock_mcf_obj, showConf = FALSE)

  # With confidence: MCF + lower + upper = 3 traces
  # Without confidence: MCF = 1 trace
  expect_gt(length(plot_with_conf$x$attrs), length(plot_without_conf$x$attrs))
})

test_that("plotly_mcf accepts a list of mcf objects and returns a plotly object", {
  plot <- plotly_mcf(list(mock_mcf_obj, mock_mcf_obj))
  expect_s3_class(plot, "plotly")
})

test_that("plotly_mcf overlay produces more traces than single object", {
  single  <- plotly_mcf(mock_mcf_obj)
  overlay <- plotly_mcf(list(mock_mcf_obj, mock_mcf_obj))
  expect_gt(length(overlay$x$attrs), length(single$x$attrs))
})

test_that("plotly_mcf overlay respects cols parameter", {
  plot <- plotly_mcf(list(mock_mcf_obj, mock_mcf_obj), cols = c("red", "blue"))
  expect_s3_class(plot, "plotly")
})

test_that("plotly_mcf throws error for non-mcf input in list", {
  expect_error(
    plotly_mcf(list(mock_mcf_obj, list())),
    "All inputs must be of class 'mcf'."
  )
})
