# Exercise 2 - Treatment effect in physiotherapy

# For simplicity, let's just test two theta values: 0.3 (as in the previous study) and 0.4

# Prior probability for theta = 0.3
p_theta1 <- 0.5 # 50% chance of theta = 0.3

# Prior probability for theta = 20/50 = 0.4
p_theta2 <- 0.5 # 50% chance of theta = 0.4

# Likelihood of the data given theta = 0.3
p_data_theta1 <- dbinom(22, 50, 0.3)

# Likelihood of the data given theta = 20/50 = 0.4
p_data_theta2 <- dbinom(22, 50, 20/50)

# Marginal likelihood p(data), as a weighted sum of likelihoods
p_data_theta_marginal <- p_data_theta1 * p_theta1 + p_data_theta2 * p_theta2

# Bayes' Theorem: p(theta|data) = p(data|theta) * p(theta) / p(data)
p_theta1_data <- p_data_theta1 * p_theta1 / p_data_theta_marginal
p_theta2_data <- p_data_theta2 * p_theta2 / p_data_theta_marginal

p_theta1_data
p_theta2_data

