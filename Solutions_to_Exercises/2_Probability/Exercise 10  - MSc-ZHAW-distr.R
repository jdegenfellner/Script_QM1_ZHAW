library(tictoc)

# Define the probability function based on the given distribution
P <- function(X) {
  if (X == 0) {
    return(1/6)
  } else {
    return((5/3) * (0.2^abs(X)))
  }
}

# Create a sequence of X values from -10 to 10
X_values <- -10:10

# Compute the probabilities for each X value
probabilities <- sapply(X_values, P)

# Plot the probabilities as a vertical line plot
plot(X_values, probabilities, type = "h", lwd = 2, col = "blue",
     xlab = "X", ylab = "Probability",
     main = "MSc-ZHAW Probability Distribution of X from -10 to 10")
points(X_values, probabilities, pch = 19, col = "red")

# Check if the sum of probabilities for a larger range sums to 1 (approximately)
x_values <- -1000:1000
total_probability_sum <- sum(sapply(x_values, P))
cat("Total probability sum over a large range:", total_probability_sum, "\n")

# Questions:------------

# 1) Create sufficiently many random numbers (sample) from the MSc-ZHAW-distribution ---------
# (see above) and see if you can produce values outside of ± 6.
sample_from_distribution <- function() {
  # Create a large set of possible X values
  X_values <- -1000:1000
  
  # Compute probabilities for each X value
  probabilities <- sapply(X_values, P)
  
  # Normalize the probabilities so they sum to 1
  probabilities <- probabilities / sum(probabilities)
  
  # Sample one value from the distribution
  sample(X_values, size = 1, prob = probabilities)
}

# Initialize counter and sample variable
counter <- 0
sample_value <- 0

# Use a while loop to keep sampling until we get a value outside the range [-6, 6]
tic()
while (sample_value >= -6 && sample_value <= 6) {
  sample_value <- sample_from_distribution()
  counter <- counter + 1
}
toc() # 6s/38s/35.79 sec

# Output the results
cat("Value found outside [-6, 6]:", sample_value, "\n") # -7
cat("Number of iterations to find the value:", counter, "\n") # Number of iterations to find the value: 46065 




# 2) What is the mode of this distribution and how could we estimate it -----
# from the sample?
# Define the probability function based on the given distribution
P <- function(X) {
  if (X == 0) {
    return(1/6)
  } else {
    return((5/3) * (0.2^abs(X)))
  }
}

# Create a sequence of X values from -10 to 10
X_values <- -1000:1000

# Compute the probabilities for each X value
probabilities <- sapply(X_values, P)
# Normalize the probabilities so they sum to 1
probabilities <- probabilities / sum(probabilities)
sum(probabilities) # 1 check

sample_values <- sample(X_values, size = 10000, prob = probabilities, replace = TRUE)
table(sample_values) # Häufigkeitstabelle
# -> sample mode would be -1 or 1 depending on your luck
# The theoretical modes are -1 and 1, as they have the highest probability mass.
# This is a so-called bimodal distribution.


# for later.....
interquantile_range <- quantile(sample_values, probs = c(0.25, 0.75))
interquantile_range # -1 to 1
# i.e., approximately 50% of values should be in the range [-1, 1]
sum(sample_values >= -1 & sample_values <= 1)/length(sample_values) # 0.5
# As we can see, the heavy concentration of values on -1 and 1 makes this interpretation difficult.
# For a continuous distribution, this problem would likely not persist.

# See definition of https://en.wikipedia.org/wiki/Quantile
# Example: 25% quantile per hand
sum(sapply(-1000:-2, P)) # = 0.0833; P(X < -1)
sum(sapply(-1000:-1, P)) # = 0.4166; P(X <= -1)
sum(sapply(-1000:0, P)) # 0.5833333; P(X <= 0)
# -1 fulfills the definition of the 25% quantile since 
# P(X < -1) <= 0.25 AND P(X <= -1) >= 0.25

# The single probability masses at -1 and 1 are well estimated:
sum(sample_values == -1)/length(sample_values) # 0.3278 # estimated probability mass at -1
P(1) # true probability
