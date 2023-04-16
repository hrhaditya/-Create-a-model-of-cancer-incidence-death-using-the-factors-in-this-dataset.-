library(tidyverse)
library(readr)

data_url <- "https://raw.githubusercontent.com/hrhaditya/NAIVE-BAYES-THEOREM-FROM-SCRATCH/main/Cancer.csv.csv"
cancer_data <- read_csv(data_url)

#Most prone locations

cancer_data %>%
  group_by(State) %>%
  summarize(mean_incidence_rate = mean(incidenceRate, na.rm = TRUE)) %>%
  arrange(desc(mean_incidence_rate)) %>%
  head(5)

#Create a 4-level indicator variable for Median Income
library(dplyr)

cancer_data <- cancer_data %>%
  mutate(income_level = case_when(
    medIncome <= quantile(medIncome, 0.25, na.rm = TRUE) ~ "Very Low",
    medIncome > quantile(medIncome, 0.25, na.rm = TRUE) & medIncome <= quantile(medIncome, 0.5, na.rm = TRUE) ~ "Low",
    medIncome > quantile(medIncome, 0.5, na.rm = TRUE) & medIncome <= quantile(medIncome, 0.75, na.rm = TRUE) ~ "High",
    medIncome > quantile(medIncome, 0.75, na.rm = TRUE) ~ "Very High"
  ))
head(cancer_data)

#Factors affecting cancer by location
cancer_data %>%
  group_by(State) %>%
  summarize(mean_poverty = mean(PovertyEst, na.rm = TRUE),
            mean_med_income = mean(medIncome, na.rm = TRUE),
            mean_incidence_rate = mean(incidenceRate, na.rm = TRUE)) %>%
  arrange(desc(mean_incidence_rate))

#Correlation analysis
numeric_vars <- c("PovertyEst", "medIncome", "popEst2015", "incidenceRate", "avgAnnCount", "deathRate", "avgDeathsPerYear")
cor_matrix <- cor(cancer_data[numeric_vars], use = "complete.obs")
cor_matrix

#regression analysis
#incidence rate model
model_incidence <- lm(incidenceRate ~ PovertyEst + medIncome + popEst2015, data = cancer_data)
summary(model_incidence)
#Death rate model
model_death <- lm(deathRate ~ PovertyEst + medIncome + popEst2015, data = cancer_data)
summary(model_death)

#Follow the steps of model building and check the assumptions of your final model.
predicted_incidence <- predict(model_incidence)
plot(cancer_data$incidenceRate, predicted_incidence, main="Observed vs. Predicted Cancer Incidence Rates", xlab="Observed", ylab="Predicted")
abline(lm(predicted_incidence ~ cancer_data$incidenceRate), col="red")

# Predict death rates using the death model
predicted_death <- predict(model_death)

# Create a scatter plot of observed vs. predicted death rates
plot(cancer_data$deathRate, predicted_death, main="Observed vs. Predicted Cancer Death Rates", xlab="Observed", ylab="Predicted")

# Add a red regression line to the plot
abline(lm(predicted_death ~ cancer_data$deathRate), col="red")

