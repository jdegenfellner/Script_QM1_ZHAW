# Task 1: Draw a sample of 165 persons from a normal distribution
# with mean = 60 and standard deviation = 7.4

set.seed(42)  # Setting seed for reproducibility
sample_size <- 165
mean_true <- 60
sd_true <- 7.4

# Draw the sample
( sample <- rnorm(sample_size, mean = mean_true, sd = sd_true) ) # rnorm...

hist(sample)

# Calculate mean and standard deviation of the sample
( sample_mean <- mean(sample) ) # 59.65796; very close!
( sample_sd <- sd(sample) ) # 7.31563; rather close


# Task 2: Replace 5 values in the sample with outliers (score of 100)
set.seed(42)  # Ensure reproducibility for replacing values
outlier_indices <- sample(seq_len(sample_size), 5) # choose 5 random indices
sample_with_outliers <- sample
sample_with_outliers[outlier_indices] <- 100 # replace with outliers
sample_with_outliers[outlier_indices]

# Calculate mean and standard deviation of the sample with replaced outliers
( mean_with_outliers <- mean(sample_with_outliers) ) # 60.86253; slightly higher
( sd_with_outliers <- sd(sample_with_outliers) ) #  10.01284; much higher


# Task 3: Estimate the impact of outliers on the median
# Define a function to replace a specified number of values with outliers
# and calculate the resulting median
replace_outliers_and_calculate_median <- function(outlier_value, num_outliers) {
  sample_replaced <- sample
  replace_indices <- sample(seq_len(sample_size), num_outliers)
  sample_replaced[replace_indices] <- outlier_value
  return(median(sample_replaced))
}

# Target median increase
target_median_increase <- 5
original_median <- median(sample)

# Finding the number of outliers required to shift the median by 5 points
num_outliers_needed <- 0
while (TRUE) { # potential infinite loop
  num_outliers_needed <- num_outliers_needed + 1
  new_median <- replace_outliers_and_calculate_median(100, num_outliers_needed)
  if (abs(new_median - original_median) >= target_median_increase) {
    break
  }
}

cat("Number of outliers needed to replace to shift the median by 5 points:", 
    num_outliers_needed, "\n")
