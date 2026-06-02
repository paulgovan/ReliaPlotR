## Dev utility — run once to generate hex sticker PNGs in man/figures/
## Requires: install.packages(c("hexSticker", "ggplot2"))

library(ggplot2)
library(hexSticker)

## ------------------------------------------------------------------
## Concept 1: Crosshair hover on Weibull S-curve
## Metaphor: hovering over a point snaps crosshair lines to its value
## Dark navy fill, steel-blue border, white CDF curve, orange crosshair
## ------------------------------------------------------------------
x <- seq(0.05, 3, length.out = 200)
y <- 1 - exp(-(x)^2)
hx <- 1.5
hy <- 1 - exp(-(hx)^2)

p1 <- ggplot(data.frame(x, y), aes(x, y)) +
  geom_line(color = "white", linewidth = 1.2) +
  geom_segment(x = hx, xend = hx, y = min(y), yend = hy,
               color = "#ff7f0e", linewidth = 0.7, linetype = "dashed") +
  geom_segment(x = min(x), xend = hx, y = hy, yend = hy,
               color = "#ff7f0e", linewidth = 0.7, linetype = "dashed") +
  geom_point(data = data.frame(x = hx, y = hy), aes(x, y),
             color = "#ff7f0e", size = 3) +
  theme_void() +
  theme_transparent()

sticker(p1, package = "ReliaPlotR",
        p_size = 18, p_color = "white",
        s_x = 1, s_y = 0.75, s_width = 1.4, s_height = 0.9,
        h_fill = "#0d2b45", h_color = "#1f77b4",
        filename = "man/figures/logo1.png")

## ------------------------------------------------------------------
## Concept 2: Tooltip popup on probability plot
## Metaphor: floating tooltip box above a selected data point
## Matplotlib blue fill, dark border, orange points, white fit line
## ------------------------------------------------------------------
set.seed(42)
n <- 15
df2 <- data.frame(
  x = sort(rnorm(n, mean = 1.5, sd = 0.5)),
  y = qnorm(ppoints(n))
)
tip_x <- df2$x[10]
tip_y <- df2$y[10]

p2 <- ggplot(df2, aes(x, y)) +
  geom_point(color = "#ff7f0e", size = 1.2) +
  geom_smooth(method = "lm", se = FALSE, color = "white", linewidth = 0.9) +
  geom_point(data = data.frame(x = tip_x, y = tip_y), aes(x, y),
             color = "white", size = 3) +
  annotate("rect",
           xmin = tip_x + 0.05, xmax = tip_x + 0.5,
           ymin = tip_y + 0.15, ymax = tip_y + 0.6,
           fill = "white", color = NA, alpha = 0.92) +
  annotate("text", x = tip_x + 0.275, y = tip_y + 0.375,
           label = "η=2.1\nF=67%", size = 1.8, color = "#1f77b4",
           lineheight = 0.85) +
  theme_void() +
  theme_transparent()

sticker(p2, package = "ReliaPlotR",
        p_size = 18, p_color = "white",
        s_x = 1, s_y = 0.75, s_width = 1.4, s_height = 0.9,
        h_fill = "#1f77b4", h_color = "#0a3d62",
        filename = "man/figures/logo2.png")

## ------------------------------------------------------------------
## Concept 3: Zoom selection box on reliability growth curve
## Metaphor: the orange dashed drag-to-zoom rectangle from plotly
## Forest green fill, bright green border, white curve, orange points
## ------------------------------------------------------------------
x3 <- seq(0.1, 5, length.out = 100)
y3 <- 1 - exp(-0.5 * x3^0.7)

p3 <- ggplot(data.frame(x3, y3), aes(x3, y3)) +
  geom_line(color = "white", linewidth = 1.3) +
  geom_point(data = data.frame(x3 = c(1, 2.5, 4),
                                y3 = 1 - exp(-0.5 * c(1, 2.5, 4)^0.7)),
             aes(x3, y3), color = "#ff7f0e", size = 2) +
  annotate("rect",
           xmin = 0.1, xmax = 2.0, ymin = 0.0, ymax = 0.62,
           fill = "#ff7f0e", color = "#ff7f0e",
           alpha = 0.12, linewidth = 0.6, linetype = "dashed") +
  theme_void() +
  theme_transparent()

sticker(p3, package = "ReliaPlotR",
        p_size = 18, p_color = "white",
        s_x = 1, s_y = 0.75, s_width = 1.4, s_height = 0.9,
        h_fill = "#1a4d2e", h_color = "#2ca02c",
        filename = "man/figures/logo3.png")

message("Done — check man/figures/logo1.png, logo2.png, logo3.png")
