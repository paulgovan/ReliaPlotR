## Dev utility — run once to generate hex sticker PNGs in man/figures/
## Requires: install.packages(c("hexSticker", "ggplot2"))

library(ggplot2)
library(hexSticker)

## ------------------------------------------------------------------
## Concept 1: Weibull S-curve
## Dark navy fill, steel-blue border, white CDF curve
## ------------------------------------------------------------------
x <- seq(0.05, 3, length.out = 200)
y <- 1 - exp(-(x)^2)

p1 <- ggplot(data.frame(x, y), aes(x, y)) +
  geom_line(color = "white", linewidth = 1.2) +
  theme_void() +
  theme_transparent()

sticker(p1, package = "ReliaPlotR",
        p_size = 18, p_color = "white",
        s_x = 1, s_y = 0.75, s_width = 1.4, s_height = 0.9,
        h_fill = "#0d2b45", h_color = "#1f77b4",
        filename = "man/figures/logo1.png")

## ------------------------------------------------------------------
## Concept 2: Probability plot — points + fit line
## Matplotlib blue fill, dark border, orange points, white line
## ------------------------------------------------------------------
set.seed(42)
n <- 15
df2 <- data.frame(
  x = sort(rnorm(n, mean = 1.5, sd = 0.5)),
  y = qnorm(ppoints(n))
)

p2 <- ggplot(df2, aes(x, y)) +
  geom_point(color = "#ff7f0e", size = 1.2) +
  geom_smooth(method = "lm", se = FALSE, color = "white", linewidth = 0.9) +
  theme_void() +
  theme_transparent()

sticker(p2, package = "ReliaPlotR",
        p_size = 18, p_color = "white",
        s_x = 1, s_y = 0.75, s_width = 1.4, s_height = 0.9,
        h_fill = "#1f77b4", h_color = "#0a3d62",
        filename = "man/figures/logo2.png")

## ------------------------------------------------------------------
## Concept 3: Reliability growth curve (NHPP / Duane shape)
## Forest green fill, bright green border, white curve, orange points
## ------------------------------------------------------------------
x3 <- seq(0.1, 5, length.out = 100)
y3 <- 1 - exp(-0.5 * x3^0.7)

p3 <- ggplot(data.frame(x3, y3), aes(x3, y3)) +
  geom_line(color = "white", linewidth = 1.3) +
  geom_point(data = data.frame(x3 = c(1, 2.5, 4),
                                y3 = 1 - exp(-0.5 * c(1, 2.5, 4)^0.7)),
             color = "#ff7f0e", size = 2) +
  theme_void() +
  theme_transparent()

sticker(p3, package = "ReliaPlotR",
        p_size = 18, p_color = "white",
        s_x = 1, s_y = 0.75, s_width = 1.4, s_height = 0.9,
        h_fill = "#1a4d2e", h_color = "#2ca02c",
        filename = "man/figures/logo3.png")

message("Done — check man/figures/logo1.png, logo2.png, logo3.png")
