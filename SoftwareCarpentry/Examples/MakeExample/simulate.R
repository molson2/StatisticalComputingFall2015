# Create Figure of Data + Fit from a Linear Model #

library(ggplot2)

# Read Params
params <- read.csv("params.csv", header=T)
slope <- params$slope
intercept <- params$intercept

# Generate Data
x <- seq(0,1,by=0.01)
y <- intercept + slope*x + 0.5*rnorm(length(x))

# Make plot
plt <- qplot(x, y) + stat_smooth(method = "lm", formula = y ~ x)
ggsave("linePlot.pdf",plt)
