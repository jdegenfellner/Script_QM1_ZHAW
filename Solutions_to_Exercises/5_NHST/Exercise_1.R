# Exercise 1 - NHST, QM1

# • Create 1000 random samples from a binomial distribution 
#   with n = 100 and p = 0.38.

# • Calculate the 96% confidence interval for each sample 
#   using R

# • How often was the true parameter (p = 0.38) contained 
#   in the constructed interval?
#---


# Number of simulations
B <- 1000

# True parameters
n <- 10
p_true <- 0.38

# 96% CI
ci96_wilson <- function(x, n) {
  prop.test(x, n, conf.level = 0.96, correct = FALSE)$conf.int
}

# 96% CI (exact via binom.test)
ci96_exact <- function(x, n) {
  binom.test(x, n, conf.level = 0.96)$conf.int
}

contained_wilson <- logical(B)
contained_exact  <- logical(B)

#set.seed(123)   # for reproducibility

for (i in 1:B) { # i runs from 1 to 1000
  # Draw one sample
  x <- rbinom(1, n, p_true)
  
  # Wilson CI
  ci_w <- ci96_wilson(x, n)
  contained_wilson[i] <- (p_true >= ci_w[1] & p_true <= ci_w[2]) # does the CI contain the true p?
  
  # Exact CI
  ci_e <- ci96_exact(x, n)
  contained_exact[i] <- (p_true >= ci_e[1] & p_true <= ci_e[2])
}

# Proportion of intervals that contain the true parameter
mean(contained_wilson)
mean(contained_exact) # pearson clopper intervals


