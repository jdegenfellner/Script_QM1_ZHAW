# Exercise 4 - NHST, QM1
# proportions test
#
# • Create a sample from a binomial distribution with n = 100 and p = 0.5.
# • Perform a proportions test with H0 : p = 0.5 and interpret the results.
# • Perform the proportions test for the whole range of possible proportions
#   H0 : p = 0.01 ... p = 0.99 in steps of 0.01.
#   Plot the p-values on the y-axis and the assumed proportion on the x-axis.
#   This is called a p-value function.


#set.seed(123)

# 1) Create one sample
n      <- 100
p_true <- 0.5
x      <- rbinom(1, n, p_true)
x
prop_hat <- x / n
prop_hat

# 2) Perform a proportions test under H0: p = 0.5
bt <- binom.test(x, n, p = 0.5, alternative = "two.sided")
bt

# 3) Compute p-values for a range of assumed H0 proportions
p_grid <- seq(0.01, 0.99, by = 0.01)

p_values <- sapply(p_grid, function(p0) {
  binom.test(x, n, p = p0, alternative = "two.sided")$p.value
})

# 4) Plot the p-value function
plot(p_grid, p_values, type = "l", lwd = 2,
     xlab = "Assumed proportion p0",
     ylab = "p-value",
     main = "p-value function for the binomial test")
abline(h = 0.05, col = "red", lty = 2)
abline(v = prop_hat, col = "blue", lty = 2)
text(0.8, 0.09, "0.05", col = "red")
text(prop_hat + 0.15, 0.9, paste0("prop_hat = ", 
                                  round(prop_hat, 2)), 
     col = "blue")
