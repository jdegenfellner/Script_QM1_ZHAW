
# 5.9.6  Exercise 6 – NHST, QM1
# correlation coefficient
#
# • Create a sample of 234 pairs of uncorrelated observations (x_i, y_i).
#   X_i and Y_i are drawn from a normal distribution with mean 0 and sd 1.
#
# • Calculate the sample correlation coefficient r.
#
# • Repeat this 1000 times.
#
# • How often was the sample correlation coefficient larger than 0.76?


set.seed(123)

n <- 234
B <- 1000

# Storage vector for correlation coefficients
r_vals <- numeric(B)

for (i in 1:B) {
  x <- rnorm(n, mean = 0, sd = 1)
  y <- rnorm(n, mean = 0, sd = 1)
  
  r_vals[i] <- cor(x, y)
}

# Proportion of correlations larger than 0.76
mean(r_vals > 0.76)

# Optional: Histogram of sample correlations
hist(r_vals,
     breaks = 30,
     main = "Sampling distribution of r under independence",
     xlab = "Correlation coefficient r")