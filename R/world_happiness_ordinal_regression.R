library(MASS)
library(dplyr)
library(corrplot)
library(readr)
library(ggplot2)
library(brant)
library(ordinal)
library(janitor)

data <- read_csv("data/world_happiness_report_2024.csv")

data$Happiness_Level <- cut(data$`Ladder score`,
                            breaks = c(0, 5, 7, 10),
                            labels = c("low", "medium", "high"),
                            ordered_result = TRUE)

table(data$Happiness_Level)

# Handle Missing Values
colSums(is.na(data))

data <- na.omit(data)

colSums(is.na(data))

# Cleaning Data Names
data <- clean_names(data)

# Histogram of Ladder Score
ggplot(data, aes(x = ladder_score)) +
  geom_histogram(binwidth = 0.3, fill = "skyblue", color = "black") +
  labs(title = "Ladder Score Distribution", x = "Ladder Score", y = "Number of Countries") +
  theme_minimal()

# Bar Chart of Average Happiness per region
data %>%
  group_by(regional_indicator) %>%
  summarise(mean_score = mean(ladder_score, na.rm = TRUE)) %>%
  ggplot(aes(x = reorder(regional_indicator, mean_score), y = mean_score)) +
  geom_col(fill = "steelblue") +
  coord_flip() +
  labs(title = "Ladder Score Average based on Region", x = "Region", y = "Ladder Score Average") +
  theme_minimal()

# Correlation Heatmap
num_data <- data %>%
  select(where(is.numeric))

corr_matrix <- cor(num_data, use = "complete.obs")

corrplot(corr_matrix, method="color", type = "upper", tl.cex = 0.6)

# Boxplot: Happiness by Region
ggplot(data, aes(x = regional_indicator, y = ladder_score)) +
  geom_boxplot(fill = "lightgreen") +
  coord_flip() +
  labs(title = "Ladder Score Distribution by Region", x = "Region", y = "Ladder Score") +
  theme_minimal()

# Model Ordinal Regression
model_ordinal <- polr(happiness_level ~ social_support + freedom_to_make_life_choices +
                        generosity + perceptions_of_corruption + 
                        healthy_life_expectancy + log_gdp_per_capita, 
                      data = data, Hess = TRUE)

summary(model_ordinal)

# Tambahkan p-value
ctable <- coef(summary(model_ordinal))
pvals <- pnorm(abs(ctable[, "t value"]), lower.tail = FALSE) * 2
ctable <- cbind(ctable, "p value" = pvals)
print(ctable)

# Odds Ratio
exp(coef(model_ordinal))

# Uji Brant
brant(model_ordinal)

# Model Evaluation
library(caret)
library(ggplot2)
library(lattice)

predicted <- predict(model_ordinal, newdata = data)

table(Predicted = predicted, Actual = data$happiness_level)

actual <- factor(data$happiness_level, levels = levels(predicted))
cm <- confusionMatrix(data = predicted, reference = actual)
cm$overall
print(cm)

# Likelihood Ratio Test
model_null <- polr(happiness_level ~ 1, data=data,
                   Hess = TRUE, method = "logistic")

LL_full <- logLik(model_ordinal)
LL_null <- logLik(model_null)

LRT_stat <- 2*(as.numeric(LL_full)-as.numeric(LL_null))
df_diff <- attr(LL_full, "df") - attr(LL_null, "df")
p_value <- pchisq(LRT_stat, df=df_diff, lower.tail = FALSE)

cat("LRT statistic:", LRT_stat,"\n")
cat("df:", df_diff, "\n")
cat("P-value:", round(p_value,4), "\n")

# Wald Test
coefs <- summary(model_ordinal)$coefficients
z_values <- coefs[, "Value"] / coefs[, "Std. Error"]
p_values <- 2 * (1 - pnorm(abs(z_values)))  # two-tailed test

wald_test_table <- cbind(coefs, "p-value" = p_values)
print(wald_test_table)
 