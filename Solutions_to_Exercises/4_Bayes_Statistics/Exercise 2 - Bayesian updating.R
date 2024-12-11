# Load required libraries
library(ggplot2)

# Define the prior (uniform)
prior <- function(theta) {
  ifelse(theta >= 0 & theta <= 1, 1, 0)
}

# Define the likelihood function
likelihood <- function(theta, successes, trials) {
  choose(trials, successes) * theta^successes * (1 - theta)^(trials - successes)
}

# Numerical integration to compute posterior
compute_posterior <- function(theta_values, prior_func, successes, trials) {
  # Compute the unnormalized posterior
  unnormalized_posterior <- sapply(theta_values, function(theta) {
    prior_func(theta) * likelihood(theta, successes, trials)
  })
  
  # Compute the normalizing constant using numerical integration
  normalizing_constant <- sum(unnormalized_posterior) * diff(range(theta_values)) / length(theta_values)
  
  # Normalize the posterior
  posterior <- unnormalized_posterior / normalizing_constant
  return(posterior)
}

# Define theta range for numerical integration
theta_values <- seq(0, 1, length.out = 1000)

# Compute prior density
prior_density <- sapply(theta_values, prior)

# Update path 1: Prior -> Experiment 1 -> Posterior1 -> Experiment 2 -> Posterior12
posterior1 <- compute_posterior(theta_values, prior, successes = 17, trials = 50)
posterior12 <- compute_posterior(theta_values, function(theta) posterior1[which.min(abs(theta_values - theta))], successes = 23, trials = 50)

# Update path 2: Prior -> Experiment 2 -> Posterior2 -> Experiment 1 -> Posterior21
posterior2 <- compute_posterior(theta_values, prior, successes = 23, trials = 50)
posterior21 <- compute_posterior(theta_values, function(theta) posterior2[which.min(abs(theta_values - theta))], successes = 17, trials = 50)

# Create a data frame for plotting
df <- data.frame(
  theta = theta_values,
  prior = prior_density,
  posterior12 = posterior12,
  posterior21 = posterior21
)

# Plot the prior and posterior distributions
ggplot(df, aes(x = theta)) +
  geom_line(aes(y = prior, color = "Prior"), size = 1.2, linetype = "dotted") +
  geom_line(aes(y = posterior12, color = "Posterior 12"), size = 1.2) +
  geom_line(aes(y = posterior21, color = "Posterior 21"), size = 1.2, linetype = "dashed") +
  labs(
    title = "Prior and Posterior Distributions (Numerical Integration)",
    x = expression(theta),
    y = "Density",
    color = "Legend"
  ) +
  scale_color_manual(values = c("Prior" = "black", "Posterior 12" = "blue", "Posterior 21" = "red")) +
  theme_minimal(base_size = 14) +
  theme(
    plot.title = element_text(face = "bold", size = 16, hjust = 0.5),
    axis.title = element_text(face = "bold")
  )