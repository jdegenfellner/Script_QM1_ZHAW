# Load necessary libraries using pacman
if (!requireNamespace("pacman", quietly = TRUE)) install.packages("pacman")
pacman::p_load(ggplot2, MASS)

# 1) Generate a skewed continuous probability distribution
# We'll use the Gamma distribution as an example
set.seed(123)  # For reproducibility
n <- 1000  # Sample size
shape <- 2  # Shape parameter for skewness
rate <- 1  # Rate parameter




# Theoretical density values
x_values <- seq(0, 10, length.out = 500)  # Generate x values
theoretical_density <- dgamma(x_values, shape = shape, rate = rate)

# Plot the theoretical density
ggplot(data.frame(x_values, theoretical_density), aes(x = x_values, y = theoretical_density)) +
  geom_line(color = "blue", size = 1) +
  labs(
    title = "Theoretical Density of a Skewed Gamma Distribution",
    x = "Value",
    y = "Density"
  ) +
  theme_minimal()

# Sample from the distribution and check
sample <- rgamma(n, shape = shape, rate = rate)

# 2) Calculate mean, median, and mode
mean_value <- mean(sample)
median_value <- median(sample)

# Mode calculation using density
density_est <- density(sample)
mode_value <- density_est$x[which.max(density_est$y)]

# 3) Plot histogram with mean, median, and mode
ggplot(data.frame(sample), aes(x = sample)) +
  geom_histogram(aes(y = ..density..), bins = 30, fill = "lightblue", color = "black") +
  geom_density(color = "blue", size = 1) +
  geom_vline(aes(xintercept = mean_value, color = "Mean"), linetype = "dashed", size = 1) +
  geom_vline(aes(xintercept = median_value, color = "Median"), linetype = "dotted", size = 1) +
  geom_vline(aes(xintercept = mode_value, color = "Mode"), linetype = "solid", size = 1) +
  scale_color_manual(values = c("Mean" = "red", "Median" = "green", "Mode" = "purple")) +
  labs(
    title = "Histogram of a Skewed Distribution with Mean, Median, and Mode",
    x = "Value",
    y = "Density",
    color = "Statistics"
  ) +
  theme_minimal()

# Print the values for comparison
cat("Mean:", mean_value, "\n")
cat("Median:", median_value, "\n")
cat("Mode:", mode_value, "\n")
