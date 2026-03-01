
# 5.9.7  Exercise 7 – NHST, QM1
# coverage frequency of CI
#
# • Create a sample (vary the sample size, start small) from a
#   normal distribution with mean 0 and standard deviation 1.
#
# • Calculate the 93% confidence interval for the mean.
#
# • Repeat this 1000 times.
#
# • How often was the true mean (0) contained in the constructed
#   interval?


#set.seed(123)

# Function that estimates CI coverage for a given sample size n
coverage_for_n <- function(n, B = 1000, mu_true = 0, sigma_true = 1) {
  
  covered <- logical(B)
  
  for (b in 1:B) {
    # Draw sample
    x <- rnorm(n, mean = mu_true, sd = sigma_true)
    
    # Sample mean and sd
    m  <- mean(x)
    s  <- sd(x)
    
    # 93% t-based CI for the mean
    alpha <- 0.07
    t_crit <- qt(1 - alpha/2, df = n - 1)
    se     <- s / sqrt(n)
    
    lower <- m - t_crit * se
    upper <- m + t_crit * se
    
    covered[b] <- (mu_true >= lower & mu_true <= upper)
  }
  
  mean(covered)
}

# Try several sample sizes (start small)
ns <- c(5, 10, 20, 50, 100)

# Estimated coverage for each n
sapply(ns, coverage_for_n)

