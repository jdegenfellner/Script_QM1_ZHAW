library(ggplot2)

n <- 35

# Solution per hand:--------------
x <- rnorm(n, mean = 10, sd = 7)
hist(x, breaks = 50, main = "Histogram of Simulated Data", 
     xlab = "Value", col = "lightblue")

z <- (x - mean(x)) / sd(x)
hist(z, breaks = 50, main = "Histogram of Z-scores", 
     xlab = "Z-score", col = "lightgreen",
     xlim = c(-4, 4))
shapiro.test(z)

# GPT-------------

# Function to calculate z-scores
calculate_z_scores <- function(data) {
  z_scores <- (data - mean(data)) / sd(data) # (x_i - mean(x)) / sd(x)
  return(z_scores)
}

# Simulation settings
set.seed(123)  # For reproducibility
n <- 10000     # Sample size

# Parameters for different normal distributions
parameters <- list(
  list(mu = 0, sigma = 1), # standard normal
  list(mu = 5, sigma = 2), # 
  list(mu = -3, sigma = 1)
)

# Loop through each parameter set, simulate data, calculate z-scores, and plot
z_score_plots <- lapply(parameters, function(param) {
  # Simulate data
  data <- rnorm(n, mean = param$mu, sd = param$sigma)
  
  # Calculate z-scores
  z_scores <- calculate_z_scores(data)
  
  # Plot histogram of z-scores
  ggplot(data.frame(z_scores), aes(x = z_scores)) +
    geom_histogram(aes(y = after_stat(density)), bins = 30, 
                   color = "black", fill = "skyblue") +
    stat_function(fun = dnorm, args = list(mean = 0, sd = 1), 
                  color = "red", linewidth = 1) +
    labs(title = paste("Z-scores with original N(", param$mu, ", ", param$sigma^2, ")", sep = ""),
         x = "Z-score", y = "Density") +
    theme_minimal()
})

ggarrange(plotlist = z_score_plots, ncol = 3, nrow = 1)
