# Exercise 12

# Question 1:
# Baseline values are rather different. The second group
# has more "room" to improve. This should be considered in the analysis
# within an adequate model.

# Question 2:
# standard error, SE. This is the standard deviation of the mean in this case.

# Question 3:
library(ggplot2)

# Define parameters for each time point for Acapella Only group
data_acapella <- data.frame(
  time = c("Baseline", "8 weeks", "20 weeks"),
  mean = c(343.3, 338.7, 343.3),
  sd = c(44.4, 42.2, 39.8)
)

# Generate 1000 random samples for each time point for Acapella Only group
expanded_data_acapella <- data.frame(
  distance = c(rnorm(1000, mean = data_acapella$mean[1], sd = data_acapella$sd[1]),
               rnorm(1000, mean = data_acapella$mean[2], sd = data_acapella$sd[2]),
               rnorm(1000, mean = data_acapella$mean[3], sd = data_acapella$sd[3])),
  time = rep(data_acapella$time, each = 1000),
  group = "Acapella Only"
)

# Define parameters for each time point for Acapella + Pulmonary Rehab group
data_pr <- data.frame(
  time = c("Baseline", "8 weeks", "20 weeks"),
  mean = c(287.5, 344.2, 367.5),
  sd = c(50.6, 115.5, 61.5)
)

# Generate 1000 random samples for each time point for Acapella + Pulmonary Rehab group
expanded_data_pr <- data.frame(
  distance = c(rnorm(1000, mean = data_pr$mean[1], sd = data_pr$sd[1]),
               rnorm(1000, mean = data_pr$mean[2], sd = data_pr$sd[2]),
               rnorm(1000, mean = data_pr$mean[3], sd = data_pr$sd[3])),
  time = rep(data_pr$time, each = 1000),
  group = "Acapella + Pulmonary Rehab"
)

# Combine data for both groups
combined_data <- rbind(expanded_data_acapella, expanded_data_pr)

ggplot(combined_data, aes(x = distance, color = time, linetype = group)) +
  geom_density() +
  labs(title = "Normal Distributions for Both Groups at Different Time Points",
       x = "Distance (m)", y = "Density") +
  theme_minimal() + 
  theme(plot.title = element_text(hjust = 0.5)) +
  scale_linetype_manual(values = c("solid", "dashed"))  # Solid lines for one group, dashed for the other

# We can see that in the Acapella only group, there is not discernable difference
# from baseline to 8/20 weeks, whereas
# in the Acapella + Pulmonary Rehab group, there is a clear shift to the right
# (higher distance)


# Question 4:
# Figure 2 and Table 2:
# The "(m)" stands for meters.
# The bars seem not to be the estimate +/- standard error (=s/sqrt(n)).
# What they probably meant was an approximate 95% confidence interval
# for the mean, which is:
# x_bar +/- t_{n-1, 0.975} * s / sqrt(n)
# https://en.wikipedia.org/wiki/Standard_error

# Mean +/- SE
344.2 + 115.5 / sqrt(12) # 377.542 -> upper end of bar? seems to be relatively exactly at 400
344.2 - 115.5 / sqrt(12) # 310.858 -> lower end of bar? bar seems to be below 300 in Figure 2a

# Example at 8 weeks:
344.2 + qt(0.975, 11) * 115.5 / sqrt(12) # 417.5852
344.2 - qt(0.975, 11) * 115.5 / sqrt(12) # 270.8148

# or (approximately):
344.2 + qnorm(0.975) * 115.5 / sqrt(12) # 409.5491
344.2 - qnorm(0.975) * 115.5 / sqrt(12) # 278.8509
# These seem to fit the bars better.



# Question 5:
n_sim <- 1000
diffs <- numeric(n_sim)
for(i in 1:n_sim){
  x_gr1_8_weeks <- rnorm(15, 338.7, sd = 42.2)
  x_gr2_8_weeks <- rnorm(12, 344.2, sd = 115.5)
 
  diffs[i] <- mean(x_gr1_8_weeks) - mean(x_gr2_8_weeks)  
}

hist(diffs, breaks = 30, col = "steelblue", border = "black", 
     xlab = "Difference in means", main = "Histogram of differences in means")
quantile(diffs, c(0.015, 0.985)) # ~97% interval

# How would the distribution change if we took the same group means?