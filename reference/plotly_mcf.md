# Interactive Mean Cumulative Function Plot.

The function creates an interactive Mean Cumulative Function (MCF) plot
for one or more \`mcf\` objects. When a list of objects is provided the
models are overlaid on the same plot, each rendered in a distinct color.
The MCF is rendered as a step function. Optional confidence bounds are
shown as a shaded band around the estimate.

## Usage

``` r
plotly_mcf(
  mcf_obj,
  showConf = TRUE,
  showGrid = TRUE,
  main = "Mean Cumulative Function Plot",
  xlab = "Time",
  ylab = "Mean Cumulative Function",
  fitCol = "black",
  confCol = "black",
  gridCol = "lightgray",
  signif = 3,
  cols = NULL
)
```

## Arguments

- mcf_obj:

  An object of class 'mcf', or a list of such objects. Each object is
  created using the \`mcf()\` function from the \`ReliaGrowR\` package.

- showConf:

  Show the confidence bounds (TRUE) or not (FALSE). Default is TRUE.

- showGrid:

  Show grid (TRUE) or hide grid (FALSE). Default is TRUE.

- main:

  Main title. Default is "Mean Cumulative Function Plot".

- xlab:

  X-axis label. Default is "Time".

- ylab:

  Y-axis label. Default is "Mean Cumulative Function".

- fitCol:

  Color of the MCF step function. Default is "black". Used only for a
  single mcf object; ignored when \`cols\` is provided or multiple
  objects are supplied.

- confCol:

  Color of the confidence bounds. Default is "black". Used only for a
  single mcf object; ignored when \`cols\` is provided or multiple
  objects are supplied.

- gridCol:

  Color of the grid. Default is "lightgray".

- signif:

  Significant digits of results. Default is 3. Must be a positive
  integer.

- cols:

  Optional character vector of colors, one per mcf object. When
  provided, each object's step function and confidence bounds are drawn
  in the corresponding color. Recycled if shorter than the number of
  objects.

## Value

A \`plotly\` object representing the interactive MCF plot.

## Examples

``` r
if (FALSE) { # \dontrun{
library(ReliaGrowR)
ids <- c("A", "A", "A", "B", "B", "C", "C", "C", "C")
times <- c(50, 150, 350, 100, 300, 80, 200, 320, 450)
fit <- mcf(id = ids, time = times)
plotly_mcf(fit)

# Overlay two MCF objects
fit2 <- mcf(id = c("X", "X", "Y"), time = c(60, 220, 180))
plotly_mcf(list(fit, fit2), cols = c("steelblue", "tomato"))
} # }
```
