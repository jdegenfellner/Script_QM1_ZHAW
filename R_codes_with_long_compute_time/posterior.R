# Load required libraries
library(ggplot2)
library(gganimate)
library(gifski)
library(magick)

# Parameters
set.seed(123)  # For reproducibility
true_theta <- 0.77  # True probability of heads
total_samples <- 100  # Total number of samples
prior <- function(theta) ifelse(theta >= 0 & theta <= 1, 1, 0)  # Uniform prior

# Simulate coin flips
samples <- rbinom(total_samples, size = 1, prob = true_theta)

# Define a function for numeric integration to normalize the posterior
normalize <- function(posterior, theta_values) {
  sum(posterior) * diff(range(theta_values)) / length(theta_values)
}

# Compute the posterior using numeric integration
compute_posterior <- function(theta_values, prior_func, successes, trials) {
  # Calculate the unnormalized posterior
  unnormalized_posterior <- sapply(theta_values, function(theta) {
    prior_func(theta) * theta^successes * (1 - theta)^(trials - successes)
  })
  # Normalize the posterior
  normalization_constant <- normalize(unnormalized_posterior, theta_values)
  unnormalized_posterior / normalization_constant
}

# Define the range of theta
theta_values <- seq(0, 1, length.out = 1000)

# Prepare data for animation
posterior_data <- data.frame()

for (n in 1:total_samples) {
  successes <- sum(samples[1:n])  # Count successes up to step n
  posterior <- compute_posterior(theta_values, prior, successes, n)
  
  posterior_data <- rbind(
    posterior_data,
    data.frame(
      theta = theta_values,
      posterior = posterior,
      step = n,
      successes = successes,
      trials = n
    )
  )
}

# Fix the subtitle mapping by ensuring dynamic references to successes and trials
posterior_data <- posterior_data %>%
  group_by(step) %>%
  mutate(label = paste("Step:", step, "| Successes:", successes, "/", trials)) %>%
  ungroup()

# Create the animation plot
plot <- ggplot(posterior_data, aes(x = theta, y = posterior, group = step)) +
  geom_line(color = "blue", size = 1.2) +
  geom_area(fill = "lightblue", alpha = 0.5) +
  labs(
    title = "Bayesian Updating Process (Numeric Integration)",
    subtitle = "{closest_state}",  # Use closest_state for smooth updating
    x = expression(theta),
    y = "Density"
  ) +
  theme_minimal(base_size = 14) +
  theme(
    plot.title = element_text(face = "bold", size = 16, hjust = 0.5),
    axis.title = element_text(face = "bold")
  ) +
  transition_states(
    states = step,
    transition_length = 2,
    state_length = 1
  ) +
  ease_aes('linear')  # Smooth transitions

# Save the animation as a GIF
gif_path <- "bayesian_updating_fixed.gif"
anim_save(gif_path, animate(plot, nframes = total_samples, fps = 5, renderer = gifski_renderer()))

# Display the GIF in R
img <- magick::image_read(gif_path)
print(img)

cat("GIF saved as 'bayesian_updating_fixed.gif'\n")