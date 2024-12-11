# Set working directory to source file location
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

library(gtsummary)
library(gt)
library(dplyr)
library(writexl)

# *) Create fake data for the study mentioned above in R.-------

# Set seed for reproducibility
set.seed(123)

# Number of fake patients
n_usual_care <- 165
n_CFT <- 327

# 1. Age - Assume normal distribution based on mean and SD
age_usualcare <- rnorm(n_usual_care, mean = 48, sd = 16)  # Usual care group
age_cft <- rnorm(n_CFT, mean = 47, sd = 15)               # CFT group

# 2. Sex - Assume binomial distribution (59% female)
sex_usualcare <- rbinom(n_usual_care, 1, prob = 0.59)  # 1 = Female, 0 = Male
sex_cft <- rbinom(n_CFT, 1, prob = 0.59)

# 3. University Education - Assume binomial distribution (54% in usual care, 48% in CFT)
education_usualcare <- rbinom(n_usual_care, 1, prob = 0.54)
education_cft <- rbinom(n_CFT, 1, prob = 0.48)

# 4. Confidence in treatment - Generate ordinal variable (use multinomial)
confidence_levels <- c("very unconfident", "unconfident", "uncertain", "somewhat confident", "confident", "very confident")
confidence_probs_usualcare <- c(0.10, 0.19, 0.46, 0.06, 0.13, 0.06)
confidence_probs_cft <- c(0.01, 0.01, 0.28, 0.27, 0.30, 0.13)

confidence_usualcare <- sample(confidence_levels, n_usual_care, replace = TRUE, prob = confidence_probs_usualcare)
confidence_cft <- sample(confidence_levels, n_CFT, replace = TRUE, prob = confidence_probs_cft)

# 5. Duration of Care Seeking - Generate from a log-normal distribution and compute median (IQR)
duration_care_usualcare <- rlnorm(n_usual_care, meanlog = log(4), sdlog = 1)
duration_care_cft <- rlnorm(n_CFT, meanlog = log(4), sdlog = 1)

# 6. Length of Current Episode - Assume normal distribution and discretize
length_episode_usualcare <- round(rnorm(n_usual_care, mean = 5, sd = 1.8))
length_episode_cft <- round(rnorm(n_CFT, mean = 5, sd = 1.4))

# 7. Pain Intensity - Assume normal distribution and discretize to nearest integer
pain_intensity_usualcare <- round(rnorm(n_usual_care, mean = 5.8, sd = 1.6))
pain_intensity_cft <- round(rnorm(n_CFT, mean = 5.8, sd = 1.7))

# 8. Pain Catastrophizing - Assume normal distribution
pain_catastrophizing_usualcare <- rnorm(n_usual_care, mean = 24.3, sd = 12.4)
pain_catastrophizing_cft <- rnorm(n_CFT, mean = 24.7, sd = 12.6)

# 9. Cognitive Flexibility - Assume normal distribution
cognitive_flexibility_usualcare <- rnorm(n_usual_care, mean = 59.9, sd = 7.4)
cognitive_flexibility_cft <- rnorm(n_CFT, mean = 58.3, sd = 7.6)

# 10. Activity Limitation - Assume normal distribution based on mean and SD
activity_limitation_usualcare <- rnorm(n_usual_care, mean = 13.5, sd = 5.4)
activity_limitation_cft <- rnorm(n_CFT, mean = 13.6, sd = 5.1)

# 11. Pain Self-Efficacy - Assume normal distribution
pain_self_efficacy_usualcare <- rnorm(n_usual_care, mean = 36.4, sd = 13.5)
pain_self_efficacy_cft <- rnorm(n_CFT, mean = 34.0, sd = 13.9)

# Create a group column
group_usualcare <- rep("Usual Care", n_usual_care)
group_cft <- rep("CFT", n_CFT)

# Combine into a single data frame for both groups
fake_data <- data.frame(
  Group = c(group_usualcare, group_cft),
  Sex = c(ifelse(sex_usualcare == 1, "Female", "Male"), ifelse(sex_cft == 1, "Female", "Male")),
  Age = c(age_usualcare, age_cft),
  DurationCare = c(duration_care_usualcare, duration_care_cft),
  LengthEpisode = c(length_episode_usualcare, length_episode_cft),
  Education = c(ifelse(education_usualcare == 1, "University", "Non-University"), ifelse(education_cft == 1, "University", "Non-University")),
  Confidence = c(confidence_usualcare, confidence_cft),
  ActivityLimitation = c(activity_limitation_usualcare, activity_limitation_cft),
  CognitiveFlexibility = c(cognitive_flexibility_usualcare, cognitive_flexibility_cft),
  PainIntensity = c(pain_intensity_usualcare, pain_intensity_cft),
  PainSelfEfficacy = c(pain_self_efficacy_usualcare, pain_self_efficacy_cft),
  PainCatastrophizing = c(pain_catastrophizing_usualcare, pain_catastrophizing_cft)
)

# *) Recreate Table 2 of the paper mentioned above with fake data in R (using -----------
# GPT, the R package gtsummary and other useful packages). This is rather useful later on in your master thesis.

# Load necessary libraries
library(gtsummary)
library(gt)
library(dplyr)
library(writexl)
library(flextable)

# *) Recreate Table 2 of the paper mentioned above with fake data in R

# Ensure "Usual Care" is the first level in the Group variable
fake_data$Group <- factor(fake_data$Group, levels = c("Usual Care", "CFT"))

# Summarize the fake data using gtsummary with the correct order of variables
summary_table <- 
  fake_data %>%
  tbl_summary(
    by = Group, 
    statistic = list(
      all_continuous() ~ "{median} ({p25} to {p75})", 
      DurationCare ~ "{median} ({p25} to {p75})",       # Ensure median (IQR) for Duration of care
      LengthEpisode ~ "{median} ({p25} to {p75})",      # Ensure median (IQR) for Length of current episode
      all_categorical() ~ "{n} ({p}%)"
    ),
    label = list(
      Age ~ "Age (years)",
      Sex ~ "Sex, n (%) Female",
      Education ~ "University education, n (%)",
      Confidence ~ "Confidence in treatment assigned, n (%)",
      DurationCare ~ "Duration of care seeking (y), median (IQR)",
      LengthEpisode ~ "Length of current episode (y), median (IQR)",
      ActivityLimitation ~ "Activity limitation (0 to 24), mean (SD)",
      CognitiveFlexibility ~ "Cognitive flexibility (12 to 72), mean (SD)",
      PainIntensity ~ "Pain intensity (0 to 10), mean (SD)",
      PainSelfEfficacy ~ "Pain self-efficacy (0 to 60), mean (SD)",
      PainCatastrophizing ~ "Pain catastrophizing (0 to 52), mean (SD)"
    )
  )

# Export summary table to Word
summary_table %>%
  as_flex_table() %>%
  flextable::save_as_docx(path = "summary_table.docx")

# Optional: Export to Excel as well if needed
summary_table_df <- 
  fake_data %>%
  tbl_summary(
    by = Group, 
    statistic = list(
      all_continuous() ~ "{median} ({p25} to {p75})", 
      all_categorical() ~ "{n} ({p}%)"
    ),
    label = list(
      Age ~ "Age (years)",
      Sex ~ "Sex, n (%) Female",
      Education ~ "University education, n (%)",
      Confidence ~ "Confidence in treatment assigned, n (%)",
      DurationCare ~ "Duration of care seeking (y), median (IQR)",
      LengthEpisode ~ "Length of current episode (y), mean (SD)",
      ActivityLimitation ~ "Activity limitation (0 to 24), mean (SD)",
      CognitiveFlexibility ~ "Cognitive flexibility (12 to 72), mean (SD)",
      PainIntensity ~ "Pain intensity (0 to 10), mean (SD)",
      PainSelfEfficacy ~ "Pain self-efficacy (0 to 60), mean (SD)",
      PainCatastrophizing ~ "Pain catastrophizing (0 to 52), mean (SD)"
    )
  ) %>%
  as_tibble() # Convert gtsummary object to a tibble (data frame)

write_xlsx(summary_table_df, "summary_table.xlsx")
