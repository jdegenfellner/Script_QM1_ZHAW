# Example from Script “Statistik und Wahrscheinlichkeitstheorie using R”, S.331 ff, Werner Gurker

# Problem Setup
# A manufacturer claims that the defect rate of their products is only 5%, 
# while the customer believes it to be 10%.

# Before the result of a sample inspection is known, we assign both rates an equal 50-50 chance:
# π(0.05) = π(0.10) = 0.5

# Assume that in a sample of size 20, there are 3 defective items.
# Using the binomial distribution B(20, θ), we calculate the data information:

# p(3|θ = 0.05) = choose(20, 3) * (0.05)^3 * (0.95)^17 = 0.0596
# p(3|θ = 0.10) = choose(20, 3) * (0.10)^3 * (0.90)^17 = 0.1901

# The marginal distribution of X (the number of defective items in the sample) for x = 3:
# m(3) = p(3|0.05)π(0.05) + p(3|0.10)π(0.10) = 0.1249

# Posterior probabilities:
# π(0.05 | X = 3) = p(3|0.05)π(0.05) / m(3) = 0.2387
# π(0.10 | X = 3) = p(3|0.10)π(0.10) / m(3) = 0.7613

# A priori, we had no preference for either of the two defect rates.
# After observing a defect rate of 3/20 = 15% in the sample, the posterior 
# probability for θ = 0.10 is approximately three times as likely as θ = 0.05.

# Visualization

# Load required libraries
library(ggplot2)

# A priori probabilities-----------
data_prior <- data.frame(
  theta = factor(c("theta[1] == 0.05", "theta[2] == 0.10"),
                 levels = c("theta[1] == 0.05", "theta[2] == 0.10")),
  probability = c(0.5, 0.5)
)

# A priori bar plot------------
ggplot(data_prior, aes(x = theta, y = probability, fill = theta)) +
  geom_bar(stat = "identity", width = 0.5) +
  scale_x_discrete(labels = c(expression(theta[1] == 0.05),
                              expression(theta[2] == 0.10))) +
  scale_y_continuous(name = "Probability", limits = c(0, 1)) +
  labs(x = NULL, y = "Probability") +
  theme_minimal(base_size = 14) +
  theme(
    legend.position = "none",
    panel.grid.minor = element_blank(),
    axis.text = element_text(size = 12, color = "black"),
    axis.title.y = element_text(size = 14, face = "bold")
  ) +
  ggtitle("A Priori Probabilities")



# Calculate posterior probabilities---------
# Define prior probabilities
pi_theta_1 <- 0.1  # Prior probability for theta = 0.05
pi_theta_2 <- 0.9  # Prior probability for theta = 0.10

# Define likelihoods
likelihood_theta_1 <- choose(20, 3) * (0.05)^3 * (0.95)^17  # P(X = 3 | theta = 0.05)
likelihood_theta_2 <- choose(20, 3) * (0.10)^3 * (0.90)^17  # P(X = 3 | theta = 0.10)

# Calculate marginal probability (denominator of Bayes' theorem)
marginal_prob <- likelihood_theta_1 * pi_theta_1 + likelihood_theta_2 * pi_theta_2

# Calculate posterior probabilities
posterior_theta_1 <- (likelihood_theta_1 * pi_theta_1) / marginal_prob
posterior_theta_2 <- (likelihood_theta_2 * pi_theta_2) / marginal_prob

# Display results
cat("Likelihood for theta = 0.05:", likelihood_theta_1, "\n")
cat("Likelihood for theta = 0.10:", likelihood_theta_2, "\n")
cat("Marginal probability m(3):", marginal_prob, "\n")
cat("Posterior probability for theta = 0.05:", posterior_theta_1, "\n")
cat("Posterior probability for theta = 0.10:", posterior_theta_2, "\n")


# A posteriori probabilities-------------
data_posterior <- data.frame(
  theta = factor(c("theta[1] == 0.05", "theta[2] == 0.10"),
                 levels = c("theta[1] == 0.05", "theta[2] == 0.10")),
  probability = c(posterior_theta_1, posterior_theta_2)
)

# A posteriori bar plot
ggplot(data_posterior, aes(x = theta, y = probability, fill = theta)) +
  geom_bar(stat = "identity", width = 0.5) +
  scale_x_discrete(labels = c(expression(theta[1] == 0.05),
                              expression(theta[2] == 0.10))) +
  scale_y_continuous(name = "Probability", limits = c(0, 1)) +
  labs(x = NULL, y = "Probability") +
  theme_minimal(base_size = 14) +
  theme(
    legend.position = "none",
    panel.grid.minor = element_blank(),
    axis.text = element_text(size = 12, color = "black"),
    axis.title.y = element_text(size = 14, face = "bold")
  ) +
  ggtitle("A Posteriori Probabilities")
