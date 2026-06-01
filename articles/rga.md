# Reliability Growth Analysis

To run a Reliability Growth Analysis, start by loading `ReliaGrowR` and
`ReliaPlotR`

``` r

library(ReliaGrowR)
library(ReliaPlotR)
```

## Statistical Background

The **Crow-AMSAA** model (Non-Homogeneous Poisson Process, Power Law)
describes the expected cumulative failures as

``` math
E[N(t)] = \lambda t^{\beta},
```

where $`\lambda > 0`$ is a scale parameter and $`\beta > 0`$ is the
shape parameter. A value $`\beta < 1`$ indicates **reliability growth**
(the failure rate $`\lambda\beta t^{\beta-1}`$ is decreasing over time);
$`\beta > 1`$ indicates degradation; $`\beta = 1`$ gives a homogeneous
Poisson process (constant rate). Parameters are estimated by fitting a
log-log linear regression to cumulative failures versus cumulative test
time (Crow 1974).

The **Duane model** predates the NHPP formulation and postulates that
the cumulative mean time between failures follows a power law in
cumulative test time: $`\text{CMTBF}(T) = K T^\alpha`$, where $`\alpha`$
is the growth rate. Empirically, managed reliability growth programs
tend to achieve $`\alpha \approx 0.3`$–$`0.5`$(Duane 1964).

**Piecewise NHPP.** When a design change or corrective action divides
the test program into distinct phases, separate Power Law parameters are
fit within each interval defined by the specified `breaks`. A vertical
dotted line marks each change point.

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

## References

## See Also

- [Life Data
  Analysis](https://paulgovan.github.io/ReliaPlotR/articles/weibull.md)
  — fit Weibull/lognormal models to failure-time data
- [Repairable Systems
  Analysis](https://paulgovan.github.io/ReliaPlotR/articles/repairable.md)
  — analyze recurrent events with MCF and NHPP models
- [Accelerated Life
  Testing](https://paulgovan.github.io/ReliaPlotR/articles/alt.md) —
  extrapolate life from accelerated stress conditions

Crow, Larry H. 1974. “Reliability Analysis for Complex Repairable
Systems.” In *Reliability and Biometry: Statistical Analysis of
Lifelength*, edited by F. Proschan and R. J. Serfling. SIAM.

Duane, J. T. 1964. “Learning Curve Approach to Reliability Monitoring.”
*IEEE Transactions on Aerospace* 2 (2): 563–66.
<https://doi.org/10.1109/TA.1964.4319640>.
