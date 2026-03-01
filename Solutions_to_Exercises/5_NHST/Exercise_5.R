
# Exercise 5 – NHST, QM1
# proportions test 2
#
# • Use the data from the smokers proportions test example above.
#   (Here we only need the chi-square distribution part.)
#
# • Draw a χ² distribution with 3 degrees of freedom
#   and calculate the probability of observing a value of 12.6 or larger.
#
# • Plot the density curve using ggplot and shade the area
#   corresponding to X ≥ 12.6.


library(ggplot2)
library(dplyr)

# Degrees of freedom
df <- 3

# Threshold
x0 <- 12.6
x0 <- 6

# Probability of X ≥ 12.6 under χ²(df = 3)
p_value <- pchisq(x0, df = df, lower.tail = FALSE)
p_value

# Create data frame for plotting
x_vals <- seq(0, 30, by = 0.01)

df_plot <- data.frame(
  x = x_vals,
  density = dchisq(x_vals, df = df),
  shade = x_vals >= x0
)

ggplot(df_plot, aes(x = x, y = density)) +
  geom_line(size = 1.2) +
  geom_area(data = subset(df_plot, shade == TRUE),
            aes(x = x, y = density),
            fill = "red", alpha = 0.4) +
  geom_vline(xintercept = x0, linetype = "dashed", color = "red") +
  annotate("text", x = x0 + 7, y = 0.02,
           label = paste0("P(X ≥ ", x0, ") = ", round(p_value, 4)),
           color = "red", size = 5) +
  labs(title = expression(paste("Chi-square distribution  ", 
                                chi^2, "(df = 3)")),
       x = expression(paste(chi^2, "(df = 3)")),
       y = "Density") +
  theme_minimal(base_size = 14)
