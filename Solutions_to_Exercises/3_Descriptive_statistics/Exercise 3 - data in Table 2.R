
# 1. Probability of seeing a person of age 60 or older in a new sample (usual care group)
mean_age_usualcare <- 48
sd_age_usualcare <- 16
prob_age_60_or_older_usualcare <- 1 - pnorm(60, mean = mean_age_usualcare, sd = sd_age_usualcare)
prob_age_60_or_older_usualcare

1 - pnorm(60, mean = 48, sd = 16)

# same for second group...
mean_age_usualcare_ <- 47
sd_age_usualcare_ <- 15
prob_age_60_or_older_usualcare_ <- 1 - pnorm(60, mean = mean_age_usualcare_, sd = sd_age_usualcare_)
prob_age_60_or_older_usualcare_

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

