# Package index

## Life Data Analysis

Weibull and lognormal probability plots and confidence contour plots for
fitting failure-time data.

- [`plotly_wblr()`](https://paulgovan.github.io/ReliaPlotR/reference/plotly_wblr.md)
  : Interactive Probability Plot.
- [`plotly_contour()`](https://paulgovan.github.io/ReliaPlotR/reference/plotly_contour.md)
  : Interactive Contour Plot

## Accelerated Life Testing

Probability plots and life-stress relationship plots for multi-stress
ALT experiments.

- [`plotly_alt()`](https://paulgovan.github.io/ReliaPlotR/reference/plotly_alt.md)
  : Interactive ALT Probability Plot.
- [`plotly_rel()`](https://paulgovan.github.io/ReliaPlotR/reference/plotly_rel.md)
  : Interactive ALT Life-Stress Relationship Plot.

## Reliability Growth

Crow-AMSAA NHPP and Duane cumulative-failure / MTBF plots for tracking
improvement over development test time.

- [`plotly_rga()`](https://paulgovan.github.io/ReliaPlotR/reference/plotly_rga.md)
  : Interactive Reliability Growth Plot.
- [`plotly_duane()`](https://paulgovan.github.io/ReliaPlotR/reference/plotly_duane.md)
  : Interactive Duane Plot.

## Repairable Systems

Nonparametric and parametric plots for repairable-system event data:
NHPP model fits, Mean Cumulative Function, and exposure rates.

- [`plotly_nhpp()`](https://paulgovan.github.io/ReliaPlotR/reference/plotly_nhpp.md)
  : Interactive NHPP Plot.
- [`plotly_mcf()`](https://paulgovan.github.io/ReliaPlotR/reference/plotly_mcf.md)
  : Interactive Mean Cumulative Function Plot.
- [`plotly_exposure()`](https://paulgovan.github.io/ReliaPlotR/reference/plotly_exposure.md)
  : Interactive Exposure Plot.

## Accessor Functions

Extract tidy data frames of parameter estimates, confidence bounds, and
goodness-of-fit metrics from fitted model objects for use in
reproducible research workflows.

- [`tidy_wblr()`](https://paulgovan.github.io/ReliaPlotR/reference/tidy_wblr.md)
  : Extract Tidy Parameter Estimates from a wblr Object.
- [`tidy_rga()`](https://paulgovan.github.io/ReliaPlotR/reference/tidy_rga.md)
  : Extract Tidy Fitted Values from an rga Object.
- [`tidy_alt()`](https://paulgovan.github.io/ReliaPlotR/reference/tidy_alt.md)
  : Extract Tidy Parameter Estimates from an alt Object.

## MCP Server

Launch a Model Context Protocol server that exposes Weibull and ALT
fitting as callable tools for AI assistants such as Claude Code and
Claude Desktop.

- [`reliapltr_mcp_server()`](https://paulgovan.github.io/ReliaPlotR/reference/reliapltr_mcp_server.md)
  : Launch a ReliaPlotR MCP Server.
