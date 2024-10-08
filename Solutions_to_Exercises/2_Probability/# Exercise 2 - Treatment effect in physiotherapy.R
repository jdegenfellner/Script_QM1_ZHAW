# Exercise 2 - Treatment effect in physiotherapy

# theta) = 0.3 # from previous studies we know that the therapy is effective in 30% of the cases
p_theta = 0.3 # Probability of a clinically relevant treatment effect.

#  p(data|theta) = # probability to see 20 out of 50 patients improve under the therapy
# This is binomially distributed

# p(data|theta) = dbinom(20, 50, 0.3)
p_data_theta = dbinom(20, 50, 0.3) # = 0.037 Probability to see 20 out of 50 patients improve under the therapy, assuming theta=0.3

# p(data) = sum(p(data|theta) * p(theta)) = dbinom(20, 50, 0.3) + dbinom(20, 50, 20/50)
# We restrict our options to two options: theta = 0.3 or theta = 20/50
p_data = dbinom(15, 50, 0.3) + dbinom(20, 50, 20/50) #  = 0.2369

# Bayes' Theorem: p(theta|data) = p(data|theta) * p(theta) / p(data)
p_theta_data = p_data_theta * p_theta / p_data
p_theta_data
