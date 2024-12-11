# Define the discrete probability distribution
X <- c(1, 2, 3, 4, 5)  # The possible outcomes
P_X <- c(0.1, 0.25, 0.3, 0.2, 0.15)  # The corresponding probabilities

# Check if probabilities sum to 1 (should be exactly 1)
sum(P_X)

# Calculate the expected value (mean) of the distribution
expected_value <- sum(X * P_X)
expected_value

# Calculate the variance of the distribution
variance <- sum(P_X * (X - expected_value)^2)
variance

# Print results
cat("Expected Value (E(X)):", expected_value, "\n")
cat("Variance (Var(X)):", variance, "\n")

# Visualize the probability distribution
library(ggplot2)
df <- data.frame(Items = X, Probability = P_X)

ggplot(df, aes(x = factor(Items), y = Probability)) +
  geom_bar(stat = "identity", fill = "blue", alpha = 0.7) +
  ggtitle("Discrete Probability Distribution") +
  xlab("Number of Items Purchased") +
  ylab("Probability") +
  theme_minimal()

# This could be a distribution of the number of items purchased by customers in a store.