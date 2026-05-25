# Repairable Systems Analysis

To run a repairable systems analysis, start by loading `ReliaGrowR` and
`ReliaPlotR`:

``` r

library(ReliaGrowR)
library(ReliaPlotR)
```

The examples below use a fleet of five field units. Each row records
which unit failed and when:

``` r

id    <- c("U1","U1","U1","U2","U2","U3","U3","U3","U4","U5","U5")
time  <- c( 120, 310, 560, 200, 480, 95, 280, 430, 370, 150, 490)
```

## Mean Cumulative Function

The Mean Cumulative Function (MCF) is a non-parametric estimate of the
expected cumulative number of failures per system by time *t*. It is
computed using the Nelson-Aalen estimator, which accounts for systems
that are still operating (censored) at the end of the observation
window.

``` r

end_times <- c(U1 = 600, U2 = 600, U3 = 600, U4 = 600, U5 = 600)
fit_mcf   <- mcf(id = id, time = time, end_time = end_times)
plotly_mcf(fit_mcf)
```

The shaded band shows the pointwise confidence interval. Hover over the
step function to read exact MCF values at each event time.

## Exposure Analysis

The exposure plot tracks the cumulative event rate — total failures
divided by total system-time — over the observation period. A rising
rate indicates a deteriorating fleet; a flat or falling rate indicates
stability or improvement.

``` r

fit_exp <- exposure(id = id, time = time)
plotly_exposure(fit_exp)
```

## NHPP — Power Law Model

The Non-Homogeneous Poisson Process (NHPP) fits a parametric model to
the recurrent failure process. The Power Law model (also called the
Crow-AMSAA model for repairable systems) describes how the failure
intensity changes over time:

``` math
\lambda(t) = \lambda \beta \, t^{\beta - 1}
```

A shape parameter $`\beta < 1`$ indicates reliability improvement;
$`\beta > 1`$ indicates deterioration; $`\beta = 1`$ reduces to a
homogeneous Poisson process.

``` r

times  <- c(120, 200, 310, 370, 430, 480, 490, 560)
events <- c(  1,   1,   1,   1,   1,   1,   1,   1)
fit_nhpp <- nhpp(time = times, event = events, model_type = "Power Law")
plotly_nhpp(fit_nhpp)
```

## NHPP — Piecewise Model

When a corrective action or design change is introduced mid-program, the
failure process may shift. A piecewise NHPP fits separate Power Law
segments on either side of a specified breakpoint, shown as a vertical
dotted line:

``` r

# Dense failures before the design change (t < 500), sparse afterwards
times2  <- c(30, 65, 105, 150, 200, 255, 315, 380, 450, 800, 1300, 1950, 2800)
events2 <- rep(1, 13)
fit_nhpp2 <- nhpp(time = times2, event = events2, breaks = 500, method = "LS")
plotly_nhpp(fit_nhpp2, fitCol = "steelblue", confCol = "steelblue", breakCol = "red")
```

## Overlay

Multiple MCF or NHPP estimates can be overlaid on the same plot by
passing a list of objects. This is useful for comparing two fleets, two
time periods, or a before/after scenario.

``` r

id2   <- c("A","A","B","B","B","C")
time2 <- c(180, 420, 90, 310, 530, 260)
end2  <- c(A = 600, B = 600, C = 600)
fit_mcf2 <- mcf(id = id2, time = time2, end_time = end2)

plotly_mcf(list(fit_mcf, fit_mcf2), cols = c("steelblue", "tomato"))
```
