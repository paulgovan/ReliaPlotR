# Interactive Exposure Plot.

The function creates an interactive exposure plot for one or more
`exposure` objects. When a list of objects is provided the estimates are
overlaid on the same plot, each rendered in a distinct color. The plot
shows the instantaneous event rate (events per unit time per system at
risk) as a step function, calculated from recurrence data by dividing
the event count in each interval by the total system-time at risk during
that interval.

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

## Details

Unlike \[plotly_mcf()\] which shows cumulative events, the exposure plot
shows the instantaneous event rate: the number of events per unit time
per system at risk in each interval. A flat exposure plot suggests a
constant event rate (homogeneous Poisson process); a declining rate
suggests improvement; a rising rate suggests degradation. Use this plot
alongside \[plotly_mcf()\] to diagnose time-dependence in the event
process.

## See also

\[plotly_mcf()\] for the cumulative view; \[plotly_nhpp()\] for a
parametric NHPP model.

## Examples

``` r
library(ReliaGrowR)
ids <- c("A", "A", "A", "B", "B", "C", "C", "C", "C")
times <- c(50, 150, 350, 100, 300, 80, 200, 320, 450)
fit <- exposure(id = ids, time = times)
plotly_exposure(fit)

{"x":{"visdat":{"19d621e5f58":["function () ","plotlyVisDat"]},"cur_data":"19d621e5f58","attrs":{"19d621e5f58":{"alpha_stroke":1,"sizes":[10,100],"spans":[1,20],"type":"scatter","x":[50,80,100,150,200,300,320,350,450],"y":[0.0066666666666666671,0.0083333333333333332,0.01,0.0088888888888888889,0.0083333333333333332,0.0066666666666666671,0.0074468085106382982,0.0080000000000000002,0.0081818181818181825],"mode":"lines","line":{"color":"black","shape":"hv"},"showlegend":false,"legendgroup":"1","name":"Event Rate","text":["Rate: (50, 0.007)","Rate: (80, 0.008)","Rate: (100, 0.01)","Rate: (150, 0.009)","Rate: (200, 0.008)","Rate: (300, 0.007)","Rate: (320, 0.007)","Rate: (350, 0.008)","Rate: (450, 0.008)"],"hoverinfo":"text","inherit":true}},"layout":{"margin":{"b":40,"l":60,"t":25,"r":10},"title":"Exposure Plot","xaxis":{"domain":[0,1],"automargin":true,"title":"Time","showline":true,"mirror":"ticks","showgrid":true,"gridcolor":"lightgray"},"yaxis":{"domain":[0,1],"automargin":true,"title":"Event Rate","showline":true,"mirror":"ticks","showgrid":true,"gridcolor":"lightgray"},"hovermode":"closest","showlegend":false},"source":"A","config":{"modeBarButtonsToAdd":["hoverclosest","hovercompare"],"showSendToCloud":false},"data":[{"type":"scatter","x":[50,80,100,150,200,300,320,350,450],"y":[0.0066666666666666671,0.0083333333333333332,0.01,0.0088888888888888889,0.0083333333333333332,0.0066666666666666671,0.0074468085106382982,0.0080000000000000002,0.0081818181818181825],"mode":"lines","line":{"color":"black","shape":"hv"},"showlegend":false,"legendgroup":"1","name":"Event Rate","text":["Rate: (50, 0.007)","Rate: (80, 0.008)","Rate: (100, 0.01)","Rate: (150, 0.009)","Rate: (200, 0.008)","Rate: (300, 0.007)","Rate: (320, 0.007)","Rate: (350, 0.008)","Rate: (450, 0.008)"],"hoverinfo":["text","text","text","text","text","text","text","text","text"],"marker":{"color":"rgba(31,119,180,1)","line":{"color":"rgba(31,119,180,1)"}},"error_y":{"color":"rgba(31,119,180,1)"},"error_x":{"color":"rgba(31,119,180,1)"},"xaxis":"x","yaxis":"y","frame":null}],"highlight":{"on":"plotly_click","persistent":false,"dynamic":false,"selectize":false,"opacityDim":0.20000000000000001,"selected":{"opacity":1},"debounce":0},"shinyEvents":["plotly_hover","plotly_click","plotly_selected","plotly_relayout","plotly_brushed","plotly_brushing","plotly_clickannotation","plotly_doubleclick","plotly_deselect","plotly_afterplot","plotly_sunburstclick"],"base_url":"https://plot.ly"},"evals":[],"jsHooks":[]}
# Overlay two exposure objects
fit2 <- exposure(id = c("X", "X", "Y"), time = c(60, 220, 180))
plotly_exposure(list(fit, fit2), cols = c("steelblue", "tomato"))

{"x":{"visdat":{"19d611de515a":["function () ","plotlyVisDat"]},"cur_data":"19d611de515a","attrs":{"19d611de515a":{"alpha_stroke":1,"sizes":[10,100],"spans":[1,20],"type":"scatter","x":[50,80,100,150,200,300,320,350,450],"y":[0.0066666666666666671,0.0083333333333333332,0.01,0.0088888888888888889,0.0083333333333333332,0.0066666666666666671,0.0074468085106382982,0.0080000000000000002,0.0081818181818181825],"mode":"lines","line":{"color":"steelblue","shape":"hv"},"showlegend":true,"legendgroup":"1","name":"Event Rate 1","text":["Rate: (50, 0.007)","Rate: (80, 0.008)","Rate: (100, 0.01)","Rate: (150, 0.009)","Rate: (200, 0.008)","Rate: (300, 0.007)","Rate: (320, 0.007)","Rate: (350, 0.008)","Rate: (450, 0.008)"],"hoverinfo":"text","inherit":true},"19d611de515a.1":{"alpha_stroke":1,"sizes":[10,100],"spans":[1,20],"type":"scatter","x":[60,180,220],"y":[0.0083333333333333332,0.0055555555555555558,0.0074999999999999997],"mode":"lines","line":{"color":"tomato","shape":"hv"},"showlegend":true,"legendgroup":"2","name":"Event Rate 2","text":["Rate: (60, 0.008)","Rate: (180, 0.006)","Rate: (220, 0.007)"],"hoverinfo":"text","inherit":true}},"layout":{"margin":{"b":40,"l":60,"t":25,"r":10},"title":"Exposure Plot","xaxis":{"domain":[0,1],"automargin":true,"title":"Time","showline":true,"mirror":"ticks","showgrid":true,"gridcolor":"lightgray"},"yaxis":{"domain":[0,1],"automargin":true,"title":"Event Rate","showline":true,"mirror":"ticks","showgrid":true,"gridcolor":"lightgray"},"hovermode":"closest","showlegend":true},"source":"A","config":{"modeBarButtonsToAdd":["hoverclosest","hovercompare"],"showSendToCloud":false},"data":[{"type":"scatter","x":[50,80,100,150,200,300,320,350,450],"y":[0.0066666666666666671,0.0083333333333333332,0.01,0.0088888888888888889,0.0083333333333333332,0.0066666666666666671,0.0074468085106382982,0.0080000000000000002,0.0081818181818181825],"mode":"lines","line":{"color":"steelblue","shape":"hv"},"showlegend":true,"legendgroup":"1","name":"Event Rate 1","text":["Rate: (50, 0.007)","Rate: (80, 0.008)","Rate: (100, 0.01)","Rate: (150, 0.009)","Rate: (200, 0.008)","Rate: (300, 0.007)","Rate: (320, 0.007)","Rate: (350, 0.008)","Rate: (450, 0.008)"],"hoverinfo":["text","text","text","text","text","text","text","text","text"],"marker":{"color":"rgba(31,119,180,1)","line":{"color":"rgba(31,119,180,1)"}},"error_y":{"color":"rgba(31,119,180,1)"},"error_x":{"color":"rgba(31,119,180,1)"},"xaxis":"x","yaxis":"y","frame":null},{"type":"scatter","x":[60,180,220],"y":[0.0083333333333333332,0.0055555555555555558,0.0074999999999999997],"mode":"lines","line":{"color":"tomato","shape":"hv"},"showlegend":true,"legendgroup":"2","name":"Event Rate 2","text":["Rate: (60, 0.008)","Rate: (180, 0.006)","Rate: (220, 0.007)"],"hoverinfo":["text","text","text"],"marker":{"color":"rgba(255,127,14,1)","line":{"color":"rgba(255,127,14,1)"}},"error_y":{"color":"rgba(255,127,14,1)"},"error_x":{"color":"rgba(255,127,14,1)"},"xaxis":"x","yaxis":"y","frame":null}],"highlight":{"on":"plotly_click","persistent":false,"dynamic":false,"selectize":false,"opacityDim":0.20000000000000001,"selected":{"opacity":1},"debounce":0},"shinyEvents":["plotly_hover","plotly_click","plotly_selected","plotly_relayout","plotly_brushed","plotly_brushing","plotly_clickannotation","plotly_doubleclick","plotly_deselect","plotly_afterplot","plotly_sunburstclick"],"base_url":"https://plot.ly"},"evals":[],"jsHooks":[]}
```
