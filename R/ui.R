
titanic_ui <- function() {

  fluidPage(
  titlePanel("Titanic SurvivR (Beta)"),
  sidebarLayout(
    sidebarPanel(
      fileInput("upload", "Upload Dataset (.csv Only)", accept = ".csv"),
      actionButton("default", "Use Example Dataset"),
      selectInput("pclass", "Passenger Class:",
                  choices = c("1st Class" = 1, "2nd Class" = 2, "3rd Class" = 3)),
      selectInput("sex", "Sex:",
                  choices = c("Male" = "male", "Female" = "female")),
      sliderInput("age", "Age:",
                  min = 0, max = 100, value = 25),
      numericInput("sibsp", "Number of Siblings/Spouses Aboard:",
                   value = 0, min = 0),
      numericInput("parch", "Number of Parents/Children Aboard:",
                   value = 0, min = 0),
      numericInput("fare", "Fare Paid (£):",
                   value = 50, min = 0),
      selectInput("embark", "Port of Embarkation:",
                  choices = c("Cherbourg" = "C", "Queenstown" = "Q", "Southampton" = "S")),
      selectInput("cabin_deck", "Cabin Deck:",
                  choices = c("Any" = "U", "A Deck" = "A", "B Deck" = "B",
                              "C Deck" = "C", "D Deck" = "D", "E Deck" = "E",
                              "F Deck" = "F", "G Deck" = "G")),
      selectInput("model", "Select Prediction Model:",
                  choices = c("Logistic Regression" = "Logistic Regression",
                              "Decision Tree" = "Decision Tree",
                              "Random Forest" = "Random Forest")),
      checkboxInput("show_advanced", "Show Advanced Options", value = FALSE),
      conditionalPanel(
        condition = "input.show_advanced == true",
        numericInput("seed", "Set a test/training split seed", value = 19120415),
        sliderInput("threshold", "Choose Classification Threshold",
                    min = 0, max = 1, value = 0.50)
      )
    ),

    mainPanel(
      tabsetPanel(
        tabPanel("Introduction",
                 uiOutput("intro")),
        tabPanel("Prediction",
                 verbatimTextOutput("pred")),
        tabPanel("Data Visualisation",
                 plotOutput("survival_plot"),
                 selectInput("metric", "Choose Plot Metric:",
                              choices = c("Pclass", "Sex", "Cabin", "Embarked", "Age", "Fare", "SibSp", "Parch"))
                 ),
        tabPanel("Confusion Matrix",
                 tableOutput("confus")),
        tabPanel("Model insights",
                 verbatimTextOutput("insights"),
                 plotOutput("auc_roc", width = "400px", height = "400px")),
        tabPanel("Data Preview",
                 tableOutput("data_preview")),
        tabPanel("Titanic Deck Layout",
                 img(src = "www/titanic_layout.jpg", height = "300px", width = "300px"))
      )
    )
  )
)
}
