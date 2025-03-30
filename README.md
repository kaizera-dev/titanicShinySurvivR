# 🚢 titanicShinySurvivR

`titanicShinySurvivR` is a package that is the backend for the `Titanic SurvivR` Shiny app, an app that is based on the classic Kaggle Titanic dataset, and allows the user to select a machine learning model and predict survival based on user-selected inputs. 
The package itself handles preprocessing, modelling, and evaluation in an organised pipeline.

This project was built during my placement year as a statistical programmer in the pharmaceutical industry to **deepen my understanding of applied machine learning, statistics, structured app development, and data workflows.**

---

## 🎯 Purpose

The aim of this project wasn`t just about building a Titanic app—it was to simulate the core components of a typical machine learning workflow, with an emphasis on structure and clarity:

- Clean data preprocessing and feature engineering  
- Easy comparison of models through a UI-driven interface  
- Encapsulating logic in modular functions to improve clarity and maintainability within the app
---

## ⚙️ App Features

- Choose from multiple classification models:
  - Logistic Regression  
  - Decision Tree  
  - Random Forest  
- Model selection interface with dynamic prediction results
- Visualisations of accuracy and confusion matrix
- Built-in preprocessing and feature engineering using the `{titanicShinySurvivR}` package  
- Optional file upload: test the models on your own Titanic-format data  

---

## 📦 Skills Demonstrated

- Shiny app structured with clear separation between UI, server logic, and machine learning components—e.g., data validation, preprocessing, modeling, and output generation.
- R package development with `{usethis}` and `{devtools}`  
- Applied ML using `{recipes}`, `{rpart}`, and `{randomForest}`  
- Practicing modular design and documenting custom functions tailored to the Titanic dataset

---

## 🚀 How to Run

### Option 1: From RStudio

```r
# install.packages("devtools")
devtools::install_github("yourusername/titanicShinySurvivR")
titanicShinySurvivR::launch_app()
