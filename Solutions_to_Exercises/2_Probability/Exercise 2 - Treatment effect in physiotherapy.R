# Exercise 2 - Treatment effect in physiotherapy

# For simplicity, let's just test two theta values: 0.3 (as in the previous study) and 0.4

# Prior probability for theta = 0.3
p_theta1 <- 0.5 # 50% chance of theta = 0.3

# Prior probability for theta = 20/50 = 0.4
p_theta2 <- 0.5 # 50% chance of theta = 0.4

# Likelihood of the data given theta = 0.3
p_data_theta1 <- dbinom(22, 50, 0.3) # theta1 = 0.3

# Likelihood of the data given theta = 20/50 = 0.4
p_data_theta2 <- dbinom(22, 50, 0.4) # theta2 = 0.4

# Marginal likelihood p(data), as a weighted sum of likelihoods
p_data_theta_marginal <- p_data_theta1 * p_theta1 + p_data_theta2 * p_theta2

# Bayes' Theorem: p(theta|data) = p(data|theta) * p(theta) / p(data)
p_theta1_data <- p_data_theta1 * p_theta1 / p_data_theta_marginal
p_theta2_data <- p_data_theta2 * p_theta2 / p_data_theta_marginal

p_theta1_data # 0.1178669 # Probability that theta = 0.3 after seeing the new data (22 out of 50)
p_theta2_data # 0.8821331 # Probability that theta = 0.4 after seeing the new data (22 out of 50)

# -> theta 2 (=0.4) is comparatively more likely given our prior knowledge 
#    and the new data we have observed

# Given a model selection problem in which one wishes to choose between 
# two models on the basis of observed data D, the plausibility of the two 
# different models M1 and M2, parametrised by model parameter vectors theta1 and 
# theta2, is assessed by the Bayes factor K given by
# Bayes factor: p(data|theta1) / p(data|theta2) = 
p_data_theta1 / p_data_theta2
