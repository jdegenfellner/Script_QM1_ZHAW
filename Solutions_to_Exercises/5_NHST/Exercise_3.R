
# Exercise 3 - NHST, QM1
# binomial test
#
# • Create a sample from a binomial distribution with n = 54 and p = 0.68.
# • Perform a two-sided binomial test with H0 : p = 0.5.
# • Calculate the 90% confidence interval for the sample proportion.
# • Calculate the p-value for the two-sided test by "hand"
#   (using dbinom/pbinom in R).


set.seed(123)  # for reproducibility

# 1) Create one binomial sample
n      <- 54
p_true <- 0.68
x      <- rbinom(1, size = n, prob = p_true)   # number of "successes"
x
prop_hat <- x / n
prop_hat

# 2) Two-sided binomial test with H0: p = 0.5
bt <- binom.test(x, n, p = 0.5, 
                 alternative = "two.sided", 
                 conf.level = 0.90)
bt

# 3) 90% confidence interval for the sample proportion
bt$parameter # n
bt$statistic # test statistic
ci_90 <- bt$conf.int
ci_90

# 4) Calculate the p-value for the two-sided test by "hand"
# Definition of intervals: https://en.wikipedia.org/wiki/Binomial_proportion_confidence_interval#Clopper%E2%80%93Pearson_interval
pbinom(x, size = n, prob = 0.8513258)
1 - pbinom(x-1, size = n, prob = 0.6447398)
# one would search this numerically for the p....
