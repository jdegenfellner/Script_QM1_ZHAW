  # Exercise 2 - NHST, QM1

# Setting: two-sample t-test.
#
# • Assume there is a small difference between the means 
#   of two groups.
#
# • Show via simulation that with increasing sample size, 
#   the p-value becomes smaller and smaller and will be 
#   "significant" at some point irrespective of how small 
#   the true mean difference is and how small the α-level is.

set.seed(123)

# True parameters: very small mean difference
mu1 <- 0
mu2 <- 0.1    # tiny effect
sd  <- 1

# Range of sample sizes per group
ns <- seq(10, 5000, by = 20)

# Storage for p-values
pvals <- numeric(length(ns))

for (i in seq_along(ns)) {
  
  n <- ns[i]
  
  # Simulate data for the two groups
  x <- rnorm(n, mean = mu1, sd = sd)
  y <- rnorm(n, mean = mu2, sd = sd)
  
  # Two-sample t-test (equal variances for simplicity)
  pvals[i] <- t.test(x, y, var.equal = TRUE)$p.value
}

# Plot p-value vs. sample size
plot(ns, pvals, type = "l", lwd = 2,
     xlab = "Sample size per group (n)",
     ylab = "p-value",
     main = "Two-sample t-test: tiny mean difference, growing n")

# Add a few alpha levels
abline(h = 0.05,  lty = 2, col = "red")
abline(h = 0.01,  lty = 2, col = "blue")
abline(h = 0.001, lty = 2, col = "darkgreen")

legend("topright",
       legend = c("alpha = 0.05", "alpha = 0.01", "alpha = 0.001"),
       lty = 2,
       col = c("red", "blue", "darkgreen"),
       bty = "n")

# Show at which n the p-value first drops below the alpha levels
alpha_levels <- c(0.05, 0.01, 0.001)
names(alpha_levels) <- paste0("alpha_", alpha_levels)

threshold_ns <- sapply(alpha_levels, function(a) ns[min(which(pvals < a))])

threshold_ns