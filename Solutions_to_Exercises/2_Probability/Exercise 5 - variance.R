# Exercise 5 - variance

library(pacman)
p_load(tidyverse, conflicted)

# Parameters
n_sim <- 10000  # Number of simulations
n_experiments <- 1000  # Number of researcher experiments
p_value <- 0.04  # Probability of finding a positive result when there is none

# Simulate the number of positive results in each simulation
set.seed(123)  # Set seed for reproducibility - with this, you always get the same results below.
results <- replicate(n_sim, sum(rbinom(n_experiments, 1, p_value)))

# Visualize the results in a histogram
hist(results, breaks = 50, main = "Histogram of Positive Results", 
     xlab = "Number of Positive Results", col = "lightblue", border = "black")
table(results)  # a nice frequency table: 40 came most often

# How often do we get 65 or more positive results?
sum(results >= 65) / n_sim

# How often do we get 15 or fewer positive results?
sum(results <= 15) / n_sim

# Calculate the 90% interval around the mean (40)
quantile(results, probs = c(0.05, 0.95)) # By definition, approx. 5% of results should be below 30 and 5% above 50
# 5% 95% 
#  30  50 
sum(results <= 30) / n_sim # approx. correct
sum(results >= 50) / n_sim # approx. correct

# Theoretical variance for the experiment (binomial distribution variance formula)
theoretical_variance <- n_experiments * p_value * (1 - p_value) # https://en.wikipedia.org/wiki/Binomial_distribution#Expected_value_and_variance
theoretical_variance # 38.4
# Standard deviation:
sqrt(theoretical_variance) # ~ 2/3 of results should be within 40 +/- 6.19
sum(results >= 40 - 6.19 & results <= 40 + 6.19) / n_sim # looks good

# Estimate the variance from the simulation
estimated_variance <- var(results)
estimated_variance # 38.36 (-> very close to thoeretical variance)
# Difference between theoretical and estimated variance:
theoretical_variance - estimated_variance # 0.035 or:
(theoretical_variance - estimated_variance) / theoretical_variance # 0.0009 or 0.09%
