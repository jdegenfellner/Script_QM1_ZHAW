# 1) simple solution----------
# Load necessary libraries
if (!require(pacman)) install.packages("pacman")
pacman::p_load(tidyverse, cubature)

# Define the original (unnormalized) piecewise linear PDF
original_pdf <- function(x) {
  ifelse(x <= 0.5, 2 * x, 2 * (1 - x))
}

# Visualize the original piecewise linear PDF
x_vals <- seq(0, 1, length.out = 1000)
y_vals <- sapply(x_vals, original_pdf)
data.frame(x = x_vals, density = y_vals) %>%
  ggplot(aes(x = x, y = density)) +
  geom_line(color = "blue", linewidth = 1) +
  ggtitle("Unnormalized Piecewise Linear PDF") +
  xlab("X") +
  ylab("Density") +
  theme_minimal() + 
  theme(plot.title = element_text(hjust = 0.5))
# max at 1
# Area under the curve is 0.5!

# Calculate the normalization constant by integrating the unnormalized PDF over [0, 1]
normalization_constant <- adaptIntegrate(original_pdf, 
                                         lowerLimit = 0, upperLimit = 1)$integral

# Define the normalized PDF, probability density function
pdf <- function(x) {
  original_pdf(x) / normalization_constant
}

# Expected value function for E(X)
expected_value_function <- function(x) {
  x * pdf(x) # x*f(x)
}

# Numerically calculate the expected value E(X)
E_X <- adaptIntegrate(expected_value_function, 
                      lowerLimit = 0, upperLimit = 1)$integral

# Variance function for Var(X) using the calculated E(X)
variance_function <- function(x) {
  (x - E_X)^2 * pdf(x) # expected quadratic deviation from the mean
}

# Numerically calculate the variance Var(X)
Var_X <- adaptIntegrate(variance_function, lowerLimit = 0, upperLimit = 1)$integral

# Output results
cat("Expected Value (E(X)):", E_X, "\n")
cat("Variance (Var(X)):", Var_X, "\n")
cat("Standard Deviation (SD(X)):", sqrt(Var_X), "\n")

# Visualize the piecewise linear PDF
x_vals <- seq(0, 1, length.out = 1000)
y_vals <- sapply(x_vals, pdf)
data.frame(x = x_vals, density = y_vals) %>%
ggplot(aes(x = x, y = density)) +
  geom_line(color = "blue", size = 1) +
  ggtitle("Normalized Piecewise Linear PDF") +
  xlab("X") +
  ylab("Density") +
  theme_minimal() +
  geom_vline(xintercept = E_X, color = "red", linetype = "dashed") +
  annotate("text", x = E_X + 0.05, y = max(y_vals)/2, label = paste("E(X) =", round(E_X, 2)), color = "red")+
  theme(plot.title = element_text(hjust = 0.5))






# 2) A more complicated solution----------

# Load necessary libraries
if (!require(pacman)) install.packages("pacman")
pacman::p_load(ggplot2, cubature)

# Define the original polynomial function (not yet normalized)
original_pdf <- function(x) {
  12 * x^2 - 6 * x^3
}

# Numerically integrate to find the normalization constant
normalization_constant <- adaptIntegrate(original_pdf, lowerLimit = 0, upperLimit = 1)$integral

# Define the normalized PDF
pdf <- function(x) {
  (12 * x^2 - 6 * x^3) / normalization_constant
}

# Check if it integrats to 1:
adaptIntegrate(pdf, lowerLimit = 0, upperLimit = 1)$integral # 1

# Expected value function for E(X)
expected_value_function <- function(x) {
  x * pdf(x)
}

# Numerically calculate the expected value E(X)
E_X <- adaptIntegrate(expected_value_function, lowerLimit = 0, upperLimit = 1)$integral

# Variance function for Var(X) using the calculated E(X)
variance_function <- function(x) {
  (x - E_X)^2 * pdf(x)
}

# Numerically calculate the variance Var(X)
Var_X <- adaptIntegrate(variance_function, lowerLimit = 0, upperLimit = 1)$integral

# Output results
cat("Expected Value (E(X)):", E_X, "\n")
cat("Variance (Var(X)):", Var_X, "\n")

# Visualize the polynomial PDF
x_vals <- seq(0, 1, length.out = 1000)
y_vals <- pdf(x_vals)

# Create a data frame for plotting
data.frame(x = x_vals, density = y_vals) %>%
ggplot(aes(x = x, y = density)) +
  geom_line(color = "blue", size = 1) +
  ggtitle("Normalized Polynomial PDF: f(x) = 12x^2 - 6x^3") +
  xlab("X") +
  ylab("Density") +
  theme_minimal() +
  geom_vline(xintercept = E_X, color = "red", linetype = "dashed") +
  annotate("text", x = E_X + 0.05, y = max(y_vals)/2, label = paste("E(X) =", round(E_X, 2)), color = "red") + 
  theme(plot.title = element_text(hjust = 0.5))
