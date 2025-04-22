# 🚢 Titanic SurvivR

`titanicShinySurvivR` is the backend package for the **Titanic SurvivR** Shiny app—an interactive tool that lets users explore and predict Titanic survival outcomes using various machine learning models.

This project was created during my placement year as a **statistical programmer in the pharmaceutical industry** to deepen my understanding of applied machine learning, statistics, structured app development, and reproducible workflows.

---

## 🎯 Purpose

This wasn’t just about building a Titanic app—it was about simulating a realistic machine learning pipeline, with a focus on:

- Clean preprocessing and thoughtful feature engineering  
- Hands-on model selection and evaluation  
- User-friendly design with technical depth under the hood  

---

## ⚙️ App Features

- Upload the classic Kaggle Titanic dataset—or your own compatible data  
- Choose from multiple ML models:
  - **Logistic Regression** (with stepwise selection)
  - **Decision Tree** (with pruning)
  - **Random Forest** (tuned for tree count and depth)  
- Control train/test split via random seed
- Adjust classification threshold and instantly see its effect  
- Visualisations for model performance:  
  - Accuracy, Precision, Recall, F1 Score, Confusion Matrix, ROC-AUC  
- Feature importance output: see which variables drive predictions  
- Clean UI with collapsing panels, intuitive layout, and clear guidance  
- Extensive error handling and input validation throughout  

---

## 💻 Try the App

▶️ [**Launch Titanic SurvivR (hosted on shinyapps.io)**](https://kaizera-dev.shinyapps.io/titanicshinysurvivr-app/)

---

## 📦 Skills Developed

- Full Shiny app architecture: clear separation of concerns (UI/server/helpers)  
- R package development with `{usethis}`, `{devtools}`, and internal documentation using roxygen2  
- ML pipeline construction with `{recipes}`, `{rpart}`, and `{randomForest}`  
- Debugging and reactive logic troubleshooting in dynamic environments  
- UX thinking: simplified layout based on tester feedback  

---

## 🚀 How to Run Locally

```r
# install.packages("devtools")
devtools::install_github("kaizera-dev/titanicShinySurvivR")
titanicShinySurvivR::launch_titanic_survivr_app()
