# Parameterraum und Startprior
theta  <- c(0.05, 0.10)       # mögliche Defektraten
prior0 <- c(0.5, 0.5)         # π(0.05) = π(0.10) = 0.5

# Funktion für ein Bayes-Update mit Binomialverteilung
update_posterior <- function(prior, x, n = 20, theta) {
  lik  <- dbinom(x, size = n, prob = theta)  # p(x | θ)
  post_unnorm <- lik * prior                 # p(x | θ) * π(θ)
  post <- post_unnorm / sum(post_unnorm)     # normieren
  post
}

## 1) Erst 3/20, dann 7/20
post_after_3   <- update_posterior(prior0, x = 3, n = 20, theta = theta)
post_3_then_7  <- update_posterior(post_after_3, x = 7, n = 20, theta = theta)
post_3_then_7
# 0.004920291 0.995079709

## 2) Erst 7/20, dann 3/20
post_after_7   <- update_posterior(prior0, x = 7, n = 20, theta = theta)
post_after_7

post_7_then_3  <- update_posterior(post_after_7, x = 3, n = 20, theta = theta)
post_7_then_3
#0.004920291 0.995079709

