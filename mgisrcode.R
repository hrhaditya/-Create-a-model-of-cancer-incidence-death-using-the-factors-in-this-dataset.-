#preprocessing the data
library(dplyr)
library(tidyr)
library(readr)
url <- "https://raw.githubusercontent.com/hrhaditya/-Create-a-model-of-cancer-incidence-death-using-the-factors-in-this-dataset.-/main/Cancer.csv.csv?token=GHSAT0AAAAAACBBW7OP4OUNOJGTIEQT33C2ZB4LV4A"
download.file(url, "Cancer.csv")
data <- read_csv("Cancer.csv", na = c("*", "**", "�"))
head(data)

# Check for missing values
colSums(is.na(data))

# Handle missing values (e.g., using median imputation)
data <- data %>%
  mutate(across(where(is.numeric), ~ ifelse(is.na(.), median(., na.rm = TRUE), .)))

# Standardize numeric variables (mean = 0, sd = 1)
data <- data %>%
  mutate(across(all_of(numeric_vars), scale))

#Convert the "State" variable into a factor:
data$State <- as.factor(data$State)

#Investigate multicollinearity among the independent variables:
library(car)
vif(model_incidence)
vif(model_death)

# Log-transform the popEst2015 variable
data$log_popEst2015 <- log(data$popEst2015)

median_popEst2015 <- median(data$popEst2015, na.rm = TRUE)
data$popEst2015[is.na(data$popEst2015) | data$popEst2015 <= 0] <- median_popEst2015
data$log_popEst2015 <- log(data$popEst2015)



# Update the models
model_incidence <- lm(incidenceRate ~ PovertyEst + medIncome + log_popEst2015, data = cancer_data)
vif(model_incidence)

model_death <- lm(deathRate ~ PovertyEst + medIncome + log_popEst2015, data = cancer_data)
vif(model_death)


#Consider transforming highly skewed independent variables
data <- data %>%
  mutate(log_popEst2015 = log1p(popEst2015),
         log_avgAnnCount = log1p(avgAnnCount),
         log_avgDeathsPerYear = log1p(avgDeathsPerYear))




library(tidyverse)
library(readr) 
data_url <- "https://raw.githubusercontent.com/hrhaditya/-Create-a-model-of-cancer-incidence-death-using-the-factors-in-this-dataset.-/main/Cancer.csv.csv"
cancer_data <- read_csv(data_url)

#Q1 : Exploratory Data Analysis

#A : Most prone locations

cancer_data %>%
  group_by(State) %>%
  summarize(mean_incidence_rate = mean(incidenceRate, na.rm = TRUE)) %>%
  arrange(desc(mean_incidence_rate)) %>%
  head(5)


#B : Create a 4-level indicator variable for Median Income
library(dplyr)

cancer_data <- cancer_data %>%
  mutate(income_level = case_when(
    medIncome <= quantile(medIncome, 0.25, na.rm = TRUE) ~ "Very Low",
    medIncome > quantile(medIncome, 0.25, na.rm = TRUE) & medIncome <= quantile(medIncome, 0.5, na.rm = TRUE) ~ "Low",
    medIncome > quantile(medIncome, 0.5, na.rm = TRUE) & medIncome <= quantile(medIncome, 0.75, na.rm = TRUE) ~ "High",
    medIncome > quantile(medIncome, 0.75, na.rm = TRUE) ~ "Very High"
  ))
head(cancer_data)

#C : Factors affecting cancer by location
cancer_data %>%
  group_by(State) %>%
  summarize(mean_poverty = mean(PovertyEst, na.rm = TRUE),
            mean_med_income = mean(medIncome, na.rm = TRUE),
            mean_incidence_rate = mean(incidenceRate, na.rm = TRUE)) %>%
  arrange(desc(mean_incidence_rate))

#D : Correlation analysis
numeric_vars <- c("PovertyEst", "medIncome", "popEst2015", "incidenceRate", "avgAnnCount", "deathRate", "avgDeathsPerYear")
cor_matrix <- cor(cancer_data[numeric_vars], use = "complete.obs")
cor_matrix

#Q2 : regression analysis

#A : incidence rate model
model_incidence <- lm(incidenceRate ~ PovertyEst + medIncome + popEst2015, data = cancer_data)
summary(model_incidence)
#B : Death rate model
model_death <- lm(deathRate ~ PovertyEst + medIncome + popEst2015, data = cancer_data)
summary(model_death)

#checking the assumptions of your final model.
predicted_incidence <- predict(model_incidence)
plot(cancer_data$incidenceRate, predicted_incidence, main="Observed vs. Predicted Cancer Incidence Rates", xlab="Observed", ylab="Predicted")
abline(lm(predicted_incidence ~ cancer_data$incidenceRate), col="red")

# Predict death rates using the death model
predicted_death <- predict(model_death)

# Create a scatter plot of observed vs. predicted death rates
plot(cancer_data$deathRate, predicted_death, main="Observed vs. Predicted Cancer Death Rates", xlab="Observed", ylab="Predicted")

# Add a red regression line to the plot
abline(lm(predicted_death ~ cancer_data$deathRate), col="red")
