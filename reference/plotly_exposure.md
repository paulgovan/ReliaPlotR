# Interactive Exposure Plot.

The function creates an interactive exposure plot for one or more
\`exposure\` objects. When a list of objects is provided the estimates
are overlaid on the same plot, each rendered in a distinct color. The
plot shows the cumulative event rate over time as a step function.

## Usage

``` r
plotly_exposure(
  exposure_obj,
  showGrid = TRUE,
  main = "Exposure Plot",
  xlab = "Time",
  ylab = "Event Rate",
  fitCol = "black",
  gridCol = "lightgray",
  signif = 3,
  cols = NULL
)
```

## Arguments

- exposure_obj:

  An object of class 'exposure', or a list of such objects. Each object
  is created using the \`exposure()\` function from the \`ReliaGrowR\`
  package.

- showGrid:

  Show grid (TRUE) or hide grid (FALSE). Default is TRUE.

- main:

  Main title. Default is "Exposure Plot".

- xlab:

  X-axis label. Default is "Time".

- ylab:

  Y-axis label. Default is "Event Rate".

- fitCol:

  Color of the event rate step function. Default is "black". Used only
  for a single exposure object; ignored when \`cols\` is provided or
  multiple objects are supplied.

- gridCol:

  Color of the grid. Default is "lightgray".

- signif:

  Significant digits of results. Default is 3. Must be a positive
  integer.

- cols:

  Optional character vector of colors, one per exposure object. When
  provided, each object's step function is drawn in the corresponding
  color. Recycled if shorter than the number of objects.

## Value

A \`plotly\` object representing the interactive exposure plot.

## Examples

``` r
if (FALSE) { # \dontrun{
library(ReliaGrowR)
ids <- c("A", "A", "A", "B", "B", "C", "C", "C", "C")
times <- c(50, 150, 350, 100, 300, 80, 200, 320, 450)
fit <- exposure(id = ids, time = times)
plotly_exposure(fit)

# Overlay two exposure objects
fit2 <- exposure(id = c("X", "X", "Y"), time = c(60, 220, 180))
plotly_exposure(list(fit, fit2), cols = c("steelblue", "tomato"))
} # }
```
