# Interactive Duane Plot.

This function creates an interactive Duane plot for a `duane` object.
The plot displays observed cumulative MTBF against cumulative test time
on a log-log scale alongside the fitted Duane line and optional
confidence bounds. Positive slope on the log-log scale indicates
reliability growth.

## Usage

``` r
plotly_duane(
  duane_obj,
  showConf = TRUE,
  showGrid = TRUE,
  main = "Duane Plot",
  xlab = "Cumulative Time",
  ylab = "Cumulative MTBF",
  pointCol = "black",
  fitCol = "black",
  confCol = "black",
  gridCol = "lightgray",
  signif = 3
)
```

## Arguments

- duane_obj:

  An object of class 'duane'. This object is created using the \`duane\`
  function from the ReliaGrowR package.

- showConf:

  Show the confidence bounds (TRUE) or not (FALSE). Default is TRUE.

- showGrid:

  Show grid (TRUE) or hide grid (FALSE). Default is TRUE.

- main:

  Main title. Default is "Duane Plot".

- xlab:

  X-axis label. Default is "Cumulative Time".

- ylab:

  Y-axis label. Default is "Cumulative MTBF".

- pointCol:

  Color of the point values. Default is "black".

- fitCol:

  Color of the model fit. Default is "black".

- confCol:

  Color of the confidence bounds. Default is "black".

- gridCol:

  Color of the grid. Default is "lightgray".

- signif:

  Significant digits of results. Default is 3. Must be a positive
  integer.

## Value

A \`plotly\` object representing the interactive Duane plot.

## Details

The Duane model fits a power-law relationship between cumulative MTBF
and cumulative test time: \\\text{MTBF}\_c = K \cdot T^\alpha\\. On a
log-log plot this appears as a straight line with slope \\\alpha\\ (the
growth rate) and intercept \\\log(K)\\. A slope near 0 indicates no
growth; a slope near 0.5 is typical for a managed development program.

## See also

\[plotly_rga()\] for the Crow-AMSAA NHPP growth model on the same data.

## Examples

``` r
library(ReliaGrowR)
times <- c(100, 200, 300, 400, 500)
failures <- c(1, 2, 1, 3, 2)
fit <- duane(times, failures)
plotly_duane(fit)

{"x":{"visdat":{"1a4d192faf8d":["function () ","plotlyVisDat"]},"cur_data":"1a4d192faf8d","attrs":{"1a4d192faf8d":{"x":[100,300,600,1000,1500],"y":[100,100,150,142.85714285714286,166.66666666666666],"mode":"markers","marker":{"color":"black"},"showlegend":false,"text":{},"hoverinfo":"text","name":"","alpha_stroke":1,"sizes":[10,100],"spans":[1,20],"type":"scatter"},"1a4d192faf8d.1":{"x":[100,300,600,1000,1500],"y":[93.843667638482202,117.07417410749903,134.6064197924525,149.18643298391433,161.87537584216511],"mode":"markers+lines","marker":{"color":"transparent"},"showlegend":false,"text":{},"hoverinfo":"text","name":"","alpha_stroke":1,"sizes":[10,100],"spans":[1,20],"type":"scatter","line":{"color":"black"},"inherit":true},"1a4d192faf8d.2":{"x":[100,300,600,1000,1500],"y":[67.430125132333814,96.664973669304459,112.9727602132493,120.3934104690364,124.24135180485612],"mode":"markers+lines","marker":{"color":"transparent"},"showlegend":false,"text":{},"hoverinfo":"text","name":"","alpha_stroke":1,"sizes":[10,100],"spans":[1,20],"type":"scatter","line":{"color":"black"},"inherit":true},"1a4d192faf8d.3":{"x":[100,300,600,1000,1500],"y":[130.60385011237344,141.79243755699065,160.38280568820684,184.86553125918851,210.90914517092372],"mode":"markers+lines","marker":{"color":"transparent"},"showlegend":false,"text":{},"hoverinfo":"text","name":"","alpha_stroke":1,"sizes":[10,100],"spans":[1,20],"type":"scatter","fill":"tonexty","fillcolor":"rgba(0,0,0,0.2)","line":{"color":"black"},"inherit":true}},"layout":{"margin":{"b":40,"l":60,"t":25,"r":10},"title":"Duane Plot","xaxis":{"domain":[0,1],"automargin":true,"type":"log","title":"Cumulative Time","showline":true,"mirror":"ticks","showgrid":true,"gridcolor":"lightgray"},"yaxis":{"domain":[0,1],"automargin":true,"type":"log","title":"Cumulative MTBF","showline":true,"mirror":"ticks","showgrid":true,"gridcolor":"lightgray"},"hovermode":"closest","showlegend":false},"source":"A","config":{"modeBarButtonsToAdd":["hoverclosest","hovercompare"],"showSendToCloud":false},"data":[{"x":[100,300,600,1000,1500],"y":[100,100,150,142.85714285714286,166.66666666666666],"mode":"markers","marker":{"color":"black","line":{"color":"rgba(31,119,180,1)"}},"showlegend":false,"text":["MTBF: (100, 100)","MTBF: (300, 100)","MTBF: (600, 150)","MTBF: (1000, 142.857)","MTBF: (1500, 166.667)"],"hoverinfo":["text","text","text","text","text"],"name":"","type":"scatter","error_y":{"color":"rgba(31,119,180,1)"},"error_x":{"color":"rgba(31,119,180,1)"},"line":{"color":"rgba(31,119,180,1)"},"xaxis":"x","yaxis":"y","frame":null},{"x":[100,300,600,1000,1500],"y":[93.843667638482202,117.07417410749903,134.6064197924525,149.18643298391433,161.87537584216511],"mode":"markers+lines","marker":{"color":"transparent","line":{"color":"rgba(255,127,14,1)"}},"showlegend":false,"text":["Fit: (100, 93.844)","Fit: (300, 117.074)","Fit: (600, 134.606)","Fit: (1000, 149.186)","Fit: (1500, 161.875)"],"hoverinfo":["text","text","text","text","text"],"name":"","type":"scatter","line":{"color":"black"},"error_y":{"color":"rgba(255,127,14,1)"},"error_x":{"color":"rgba(255,127,14,1)"},"xaxis":"x","yaxis":"y","frame":null},{"x":[100,300,600,1000,1500],"y":[67.430125132333814,96.664973669304459,112.9727602132493,120.3934104690364,124.24135180485612],"mode":"markers+lines","marker":{"color":"transparent","line":{"color":"rgba(44,160,44,1)"}},"showlegend":false,"text":["Lower: (100, 67.43)","Lower: (300, 96.665)","Lower: (600, 112.973)","Lower: (1000, 120.393)","Lower: (1500, 124.241)"],"hoverinfo":["text","text","text","text","text"],"name":"","type":"scatter","line":{"color":"black"},"error_y":{"color":"rgba(44,160,44,1)"},"error_x":{"color":"rgba(44,160,44,1)"},"xaxis":"x","yaxis":"y","frame":null},{"fillcolor":"rgba(0,0,0,0.2)","x":[100,300,600,1000,1500],"y":[130.60385011237344,141.79243755699065,160.38280568820684,184.86553125918851,210.90914517092372],"mode":"markers+lines","marker":{"color":"transparent","line":{"color":"rgba(214,39,40,1)"}},"showlegend":false,"text":["Upper: (100, 130.604)","Upper: (300, 141.792)","Upper: (600, 160.383)","Upper: (1000, 184.866)","Upper: (1500, 210.909)"],"hoverinfo":["text","text","text","text","text"],"name":"","type":"scatter","fill":"tonexty","line":{"color":"black"},"error_y":{"color":"rgba(214,39,40,1)"},"error_x":{"color":"rgba(214,39,40,1)"},"xaxis":"x","yaxis":"y","frame":null}],"highlight":{"on":"plotly_click","persistent":false,"dynamic":false,"selectize":false,"opacityDim":0.20000000000000001,"selected":{"opacity":1},"debounce":0},"shinyEvents":["plotly_hover","plotly_click","plotly_selected","plotly_relayout","plotly_brushed","plotly_brushing","plotly_clickannotation","plotly_doubleclick","plotly_deselect","plotly_afterplot","plotly_sunburstclick"],"base_url":"https://plot.ly"},"evals":[],"jsHooks":[]}
```
