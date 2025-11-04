# Solutions Chapter Probability

# https://github.com/jdegenfellner/Script_QM1_ZHAW/blob/main/Solutions_to_Exercises/2_Probability/Exercise%201%20-%20throwing%20a%20die%20very%20often.R

library(pacman)
p_load(tidyverse)

# Simulating 1000 throws of a fair die
set.seed(123)  # Set seed for reproducibility
throws <- sample(1:6, size = 1000, replace = TRUE)

# Calculating frequencies of each number
table(throws)
table(throws)/sum(table(throws)) # observed probabilities
rep(1/6, 6) # true probabilities
# differences:
table(throws)/sum(table(throws)) - rep(1/6, 6)

# Plotting the frequencies of each number after 1000 throws
barplot(table(throws)/sum(table(throws)), 
        main = "Frequency of Each Number (1-6) after 1000 Throws", 
        xlab = "Number", 
        ylab = "Frequency", 
        col = "lightblue")
# add horizontal line for true probability
abline(h = 1/6, col = "red", lwd = 2, lty = 2)

# Calculating the relative frequency of getting a 3 over time
relative_freq_3 <- cumsum(throws == 3) / 1:1000

# Plotting the relative frequency of 3s with respect to the number of throws
plot(1:1000, relative_freq_3, type = "l", col = "blue", lwd = 2,
     main = "Relative Frequency of Getting a 3 Converging to 1/6",
     xlab = "Number of Throws", ylab = "Relative Frequency of 3s")
abline(h = 1/6, col = "red", lwd = 2, lty = 2)  # Add horizontal line at 1/6

# https://en.wikipedia.org/wiki/Law_of_large_numbers