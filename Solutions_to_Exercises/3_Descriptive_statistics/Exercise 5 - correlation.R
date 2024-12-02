library(tidyverse)
library(ggpubr)

# Task 1

# Set parameters for the exercise
set.seed(1234)
test_rho_values <- c(0.2, 0.5, 0.8)
test_n_values <- c(50, 200, 1000)

# Create a data frame to store all points for plotting
all_data <- data.frame()

# Generate data for each combination of rho and n
for (r in test_rho_values) {
  for (s in test_n_values) {
    x <- rnorm(s)
    y <- r * x + sqrt(1 - r^2) * rnorm(s)
    
    # Add to data frame with labels for rho and n
    temp_data <- data.frame(x = x, y = y, rho = as.factor(r), n = as.factor(s))
    all_data <- rbind(all_data, temp_data)
  }
}

all_data

# Plot using facet_grid with rho in rows and n in columns
ggplot(all_data, aes(x = x, y = y)) +
  geom_point(alpha = 0.4, color = "blue") +
  facet_grid(rho ~ n, labeller = label_both) +
  labs(title = "Scatter plots of x and y for different values of rho and n",
       x = "x", y = "y") +
  theme_minimal()



# Task 2

par(mfrow = c(1, 1)) 

# Set parameters for the exercise
set.seed(1234)
n <- 200     # Sample size
rho <- 0.7      # True correlation
num_simulations <- 1000   # Number of simulations for histogram

# Function to generate correlated data and calculate correlation coefficient
generate_correlation <- function(n, rho) {
  x <- rnorm(n)
  y <- rho * x + sqrt(1 - rho^2) * rnorm(n)
  return(cor(x, y))
}

# Simulate correlation coefficients over 1000 trials and plot histogram
correlations <- replicate(num_simulations, generate_correlation(n, rho))

# Plot the histogram of the correlation coefficients
hist(correlations, breaks = 30, col = "skyblue", border = "white",
     main = paste("Histogram of Correlation Coefficients (rho =", rho, ")"),
     xlab = "Correlation Coefficient", ylab = "Frequency")

# Display mean and standard deviation of correlations
cat("Mean of simulated correlations:", mean(correlations), "\n")

quantile(correlations, c(0.02, 0.98)) 
# n = 20 (MSc-thesis)
# 2%           98% 
# 0.3657449 0.8872824 
IQR(correlations) # 0.1524189

# n = 200 (larger project)
#   2%             98% 
# 0.6154081 0.7633769 
IQR(correlations) # 0.04794111

# On average, the correlations are indeed close to the true rho.
# Variability is higher for smaller sample sizes, as expected, i.e.,
# In a smaller sample we are much more likely to find a correlation
# far away from the true correlation.

