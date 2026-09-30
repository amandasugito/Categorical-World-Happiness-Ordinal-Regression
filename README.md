# Categorical Analysis of Global Happiness Using Ordinal Logistic Regression

## Description

This project analyzes the relationship between economic and social factors and categorical happiness levels across countries using data from the **World Happiness Report 2024**. The continuous happiness score is transformed into ordered categories (low, medium, and high), followed by exploratory analysis and ordinal logistic regression.

## Objectives

- Explore the distribution of happiness scores and selected explanatory variables.
- Categorize countries into ordered happiness levels.
- Examine relationships among numerical indicators using correlation analysis.
- Fit an ordinal logistic regression model to identify associations between economic and social factors and happiness level.
- Evaluate the model using proportional-odds, likelihood-ratio, Wald, and classification-based diagnostics.

## Methodology

The analysis uses the following predictors:

- Log GDP per capita
- Social support
- Healthy life expectancy
- Freedom to make life choices
- Generosity
- Perceptions of corruption

The response variable, `happiness_level`, is an ordered categorical variable derived from the 2024 Ladder Score.

## Repository Structure

```text
Categorical-World-Happiness-Ordinal-Regression/
├── R/
│   └── world_happiness_ordinal_regression.R
├── data/
│   ├── world_happiness_report_2024.csv
│   └── DATA_SOURCE.txt
├── .gitignore
└── README.md
```

## Requirements

The analysis is implemented in **R**. Required packages include:

```r
MASS
dplyr
corrplot
readr
ggplot2
brant
ordinal
janitor
caret
lattice
```

## How to Run

1. Open the project directory in RStudio or another R environment.
2. Install the required packages if they are not already installed.
3. Run:

```r
source("R/world_happiness_ordinal_regression.R")
```

The script reads the dataset from the repository's `data/` directory.

## Data Source

World Happiness Report 2024:

https://worldhappiness.report/ed/2024/

## Notes

This repository contains the analysis code and the public dataset required to reproduce the analysis. Personal academic documents, contributor information, and other non-essential project files are intentionally excluded.
