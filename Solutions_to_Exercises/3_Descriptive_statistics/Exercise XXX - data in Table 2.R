
# 1. Probability of seeing a person of age 60 or older in a new sample (usual care group)
mean_age_usualcare <- 48
sd_age_usualcare <- 16
prob_age_60_or_older_usualcare <- 1 - pnorm(60, mean = mean_age_usualcare, sd = sd_age_usualcare)
prob_age_60_or_older_usualcare

mean_age_cft <- 47
sd_age_cft <- 15
prob_age_18_or_younger_cft <- pnorm(18, mean = mean_age_cft, sd = sd_age_cft)
prob_age_18_or_younger_cft

# 2. Probability of seeing a person of age 18 or younger in a new sample (CFT group)
mean_age_cft <- 47
sd_age_cft <- 15
prob_age_18_or_younger_cft <- pnorm(18, mean = mean_age_cft, sd = sd_age_cft)
prob_age_18_or_younger_cft

# 3. 99% confidence interval for the age in the CFT group
ci_99_age_cft <- qnorm(c(0.005, 0.995), mean = mean_age_cft, sd = sd_age_cft)
ci_99_age_cft

# 4. Probability that the next recruited person is a woman (Usual Care group)
p_sex_female <- 0.59
prob_female_next_usualcare <- p_sex_female
prob_female_next_usualcare

# 5. Probability of seeing no man in a sample of 10 in the CFT group
prob_no_man_in_10_cft <- dbinom(10, size = 10, prob = p_sex_female)
prob_no_man_in_10_cft

# 6. Sometimes you want balanced samples. How many patients would we need to
# recruit to get at least 45 women with a probability of at least 90%.
# (We could solve this with simulation.)
# Set parameters
p_woman <- 0.59  # Probability of recruiting a woman
required_women <- 45  # We need at least 45 women
prob_threshold <- 0.90  # Desired probability threshold
simulations <- 10000  # Number of simulations

# Function to simulate the number of women recruited
simulate_recruitment <- function(n, p_woman, required_women, simulations) {
  women_count <- rbinom(simulations, size = n, prob = p_woman)  # Simulate the number of women in each trial
  prob_at_least_required_women <- mean(women_count >= required_women)  # Estimate probability
  return(prob_at_least_required_women)
}

# Start with a small number of patients and increase
n_patients <- 45  # Start with 45 patients
success_prob <- 0  # Initialize success probability

# Iterate to find the minimum number of patients required to meet the probability threshold
while (success_prob < prob_threshold) {
  n_patients <- n_patients + 1  # Increase the number of patients
  success_prob <- simulate_recruitment(n_patients, p_woman, required_women, simulations)
}

# Output the result
cat("Minimum number of patients needed to recruit at least 45 women with 90% probability:", n_patients, "\n")




# Advanced -----------

# Define the bounds for the discretization of Pain Intensity
bounds <- seq(-0.5, 10.5, by = 1)
mean_pain <- 5.8
sd_pain <- 1.7

# Compute the probabilities for the discretized Pain Intensity
probabilities <- diff(pnorm(bounds, mean = mean_pain, sd = sd_pain))
sum(probabilities)  # The sum might not be exactly 1 due to truncation at the boundaries

# Simulate 10000 random numbers from the discretized normal distribution
set.seed(123)
discretized_samples <- sample(0:10, size = 10000, replace = TRUE, prob = probabilities)

# Simulate 10000 random numbers from the underlying normal distribution
normal_samples <- rnorm(10000, mean = mean_pain, sd = sd_pain)

# Compare the proportion of samples smaller than given thresholds (3, 3.5, 4, 4.5)
thresholds <- c(3, 3.5, 4, 4.5)
discretized_proportions <- sapply(thresholds, function(t) mean(discretized_samples < t))
normal_proportions <- sapply(thresholds, function(t) mean(normal_samples < t))

# Print results
comparison <- data.frame(
  Threshold = thresholds,
  Discretized_Proportion = discretized_proportions,
  Normal_Proportion = normal_proportions
)
print(comparison)

# Now assume Pain Intensity has only 3 levels (0 to 3) and repeat the analysis
bounds_3_levels <- seq(-0.5, 3.5, by = 1)
probabilities_3_levels <- diff(pnorm(bounds_3_levels, mean = mean_pain, sd = sd_pain))

# Simulate 10000 random numbers from the 3-level discretized normal distribution
discretized_samples_3_levels <- sample(0:3, size = 10000, replace = TRUE, prob = probabilities_3_levels)

# Compare the proportion of samples smaller than given thresholds (3, 3.5, 4, 4.5)
discretized_proportions_3_levels <- sapply(thresholds, function(t) mean(discretized_samples_3_levels < t))
normal_proportions_3_levels <- sapply(thresholds, function(t) mean(normal_samples < t))

# Print results for 3-level discretization
comparison_3_levels <- data.frame(
  Threshold = thresholds,
  Discretized_Proportion_3_Levels = discretized_proportions_3_levels,
  Normal_Proportion = normal_proportions_3_levels
)
print(comparison_3_levels)
