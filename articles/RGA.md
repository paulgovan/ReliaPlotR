# Reliability Growth Analysis

To run a Reliability Growth Analysis, start by loading `ReliaGrowR` and
`ReliaPlotR`

``` r

library(ReliaGrowR)
library(ReliaPlotR)
```

## Crow-AMSAA Model

To run a Crow-AMSAA model, first set up some cumulative time and failure
data:

``` r

times <- c(100, 200, 300, 400, 500)
failures <- c(1, 2, 1, 3, 2)
```

Then run the rga and plot the results:

``` r

result <- rga(times, failures)
plotly_rga(result)
#> No trace type specified:
#>   Based on info supplied, a 'scatter' trace seems appropriate.
#>   Read more about this trace type -> https://plotly.com/r/reference/#scatter
#> No trace type specified:
#>   Based on info supplied, a 'scatter' trace seems appropriate.
#>   Read more about this trace type -> https://plotly.com/r/reference/#scatter
#> No trace type specified:
#>   Based on info supplied, a 'scatter' trace seems appropriate.
#>   Read more about this trace type -> https://plotly.com/r/reference/#scatter
```

## Piecewise NHPP Model

To run a Piecewise NHPP, first set up some cumulative time/failure data
and specify the breakpoint:

``` r

times <- c(25, 55, 97, 146, 201, 268, 341, 423, 513, 609, 710, 820, 940, 1072, 1217)
failures <- c(1, 1, 2, 4, 4, 1, 1, 2, 1, 4, 1, 1, 3, 3, 4)
breaks <- 500
```

Then run the rga and plot the results:

``` r

result <- rga(times, failures, model_type = "Piecewise NHPP", breaks = breaks)
plotly_rga(result, fitCol = "blue", confCol = "blue", breakCol = "red")
#> No trace type specified:
#>   Based on info supplied, a 'scatter' trace seems appropriate.
#>   Read more about this trace type -> https://plotly.com/r/reference/#scatter
#> No trace type specified:
#>   Based on info supplied, a 'scatter' trace seems appropriate.
#>   Read more about this trace type -> https://plotly.com/r/reference/#scatter
#> No trace type specified:
#>   Based on info supplied, a 'scatter' trace seems appropriate.
#>   Read more about this trace type -> https://plotly.com/r/reference/#scatter
```

## Duane Model

To run a Duane Model, first set up some cumulative time and failure
data:

``` r

times <- c(100, 200, 300, 400, 500)
failures <- c(1, 2, 1, 3, 2)
```

Then plot the results:

``` r

fit <- duane(times, failures)
plotly_duane(fit, fitCol = "darkgreen", confCol = "darkgreen")
```

## Overlay Models

Multiple `rga` models can be overlaid on the same plot by passing a list
of objects. Each model is rendered in a distinct color, and clicking a
legend entry toggles all traces for that model.

``` r

times1 <- c(100, 200, 300, 400, 500)
failures1 <- c(1, 2, 1, 3, 2)
result1 <- rga(times1, failures1)

times2 <- c(50, 150, 250, 350, 450)
failures2 <- c(2, 1, 3, 1, 2)
result2 <- rga(times2, failures2)

plotly_rga(list(result1, result2), cols = c("steelblue", "tomato"))
#> No trace type specified:
#>   Based on info supplied, a 'scatter' trace seems appropriate.
#>   Read more about this trace type -> https://plotly.com/r/reference/#scatter
#> No trace type specified:
#>   Based on info supplied, a 'scatter' trace seems appropriate.
#>   Read more about this trace type -> https://plotly.com/r/reference/#scatter
#> No trace type specified:
#>   Based on info supplied, a 'scatter' trace seems appropriate.
#>   Read more about this trace type -> https://plotly.com/r/reference/#scatter
#> No trace type specified:
#>   Based on info supplied, a 'scatter' trace seems appropriate.
#>   Read more about this trace type -> https://plotly.com/r/reference/#scatter
#> No trace type specified:
#>   Based on info supplied, a 'scatter' trace seems appropriate.
#>   Read more about this trace type -> https://plotly.com/r/reference/#scatter
#> No trace type specified:
#>   Based on info supplied, a 'scatter' trace seems appropriate.
#>   Read more about this trace type -> https://plotly.com/r/reference/#scatter
```
