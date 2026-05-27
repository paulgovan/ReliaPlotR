# Interactive NHPP Plot.

The function creates an interactive Non-Homogeneous Poisson Process
(NHPP) plot for one or more \`nhpp\` objects. When a list of objects is
provided the models are overlaid on the same plot, each rendered in a
distinct color. The plot shows the nonparametric Mean Cumulative
Function (MCF) alongside the parametric model fit and optional
confidence bounds. Vertical lines indicate change points if breakpoints
are specified in the nhpp object.

## Usage

``` r
plotly_nhpp(
  nhpp_obj,
  showConf = TRUE,
  showGrid = TRUE,
  main = "NHPP Plot",
  xlab = "Cumulative Time",
  ylab = "Mean Cumulative Function",
  pointCol = "black",
  fitCol = "black",
  confCol = "black",
  gridCol = "lightgray",
  breakCol = "black",
  signif = 3,
  cols = NULL
)
```

## Arguments

- nhpp_obj:

  An object of class 'nhpp', or a list of such objects. Each object is
  created using the \`nhpp()\` function from the \`ReliaGrowR\` package.

- showConf:

  Show the confidence bounds (TRUE) or not (FALSE). Default is TRUE.

- showGrid:

  Show grid (TRUE) or hide grid (FALSE). Default is TRUE.

- main:

  Main title. Default is "NHPP Plot".

- xlab:

  X-axis label. Default is "Cumulative Time".

- ylab:

  Y-axis label. Default is "Mean Cumulative Function".

- pointCol:

  Color of the MCF data points. Default is "black". Used only for a
  single nhpp object; ignored when \`cols\` is provided or multiple
  objects are supplied.

- fitCol:

  Color of the model fit. Default is "black". Used only for a single
  nhpp object; ignored when \`cols\` is provided or multiple objects are
  supplied.

- confCol:

  Color of the confidence bounds. Default is "black". Used only for a
  single nhpp object; ignored when \`cols\` is provided or multiple
  objects are supplied.

- gridCol:

  Color of the grid. Default is "lightgray".

- breakCol:

  Color of the breakpoints. Default is "black". Used only for a single
  nhpp object; ignored when \`cols\` is provided or multiple objects are
  supplied.

- signif:

  Significant digits of results. Default is 3. Must be a positive
  integer.

- cols:

  Optional character vector of colors, one per nhpp object. When
  provided, each object's points, fit line, confidence bounds, and
  breakpoints are all drawn in the corresponding color. Recycled if
  shorter than the number of objects.

## Value

A \`plotly\` object representing the interactive NHPP plot.

## Examples

``` r
if (FALSE) { # \dontrun{
library(ReliaGrowR)
times <- c(100, 200, 300, 400, 500)
events <- c(1, 2, 1, 3, 2)
fit <- nhpp(time = times, event = events)
plotly_nhpp(fit)

# Piecewise model with a breakpoint
times2 <- c(100, 200, 300, 400, 500, 600, 700, 800, 900, 1000)
events2 <- c(1, 2, 1, 1, 1, 2, 3, 1, 2, 4)
fit2 <- nhpp(time = times2, event = events2, breaks = 500)
plotly_nhpp(fit2, breakCol = "red")

# Overlay two models
plotly_nhpp(list(fit, fit2))
} # }
```
