
titanic_ui <- function() {

  fluidPage(
  titlePanel("Titanic SurvivR"),
  sidebarLayout(
    sidebarPanel(
      fileInput("upload", "Upload Dataset (.csv Only)", accept = ".csv"),
      actionButton("default", "Use Kaggle Dataset"),
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
                  choices = c("Any / Unknown" = "U", "A Deck" = "A", "B Deck" = "B",
                              "C Deck" = "C", "D Deck" = "D", "E Deck" = "E",
                              "F Deck" = "F", "G Deck" = "G")),
      selectInput("model", "Select Prediction Model:",
                  choices = c("Logistic Regression",
                              "Decision Tree",
                              "Random Forest")),
      checkboxInput("show_advanced", "Show Advanced Options", value = FALSE),
      conditionalPanel(
        condition = "input.show_advanced == true",

        numericInput("seed", "Set a test/training split seed", value = 19120415),
        sliderInput("threshold", "Select Classification Threshold",
                    min = 0, max = 1, value = 0.50)
      ),
      shinyBS::bsTooltip("seed",
                         "This seed changes the randomisation of rows assigned to test and training datasets.",
                         "right",
                         options = list(container = "body")
      ),
      shinyBS::bsTooltip("threshold",
                         "This value sets the probability cutoff for classifying survival. Predictions above this value are labeled as survived.",
                         "right",
                         options = list(container = "body")
      )
    ),

    mainPanel(
      tabsetPanel(
        tabPanel(
          title = tagList(icon("info-circle"), "Introduction"),
          uiOutput("intro")
        ),
        tabPanel(
          title = tagList(icon("magic"), "Prediction"),
          verbatimTextOutput("pred")
        ),
        tabPanel(
          title = tagList(icon("chart-bar"), "Survival Patterns"),
          shinyBS::bsCollapse(id = "collapse_survival",
                              shinyBS::bsCollapsePanel(
                                "Survival by Feature (Not Affected by Advanced Options)",
                                plotOutput("survival_plot"),
                                selectInput("metric", "Choose Plot Metric:",
                                            choices = c("Passenger Class" = "Pclass",
                                                        "Sex",
                                                        "Cabin Deck" = "Cabin",
                                                        "Port of Embarkation" = "Embarked",
                                                        "Age",
                                                        "Fare",
                                                        "Number of Siblings/Spouses Aboard" = "SibSp",
                                                        "Number of Parents/Children Aboard" = "Parch"))
                              )
          ),
          shinyBS::bsCollapse(id = "collapse_probability",
                              shinyBS::bsCollapsePanel(
                                "Predicted Probability Distribution For Model",
                                plotOutput("probability_plot")
                              )
          )
        ),
        tabPanel(
          title = tagList(icon("table"), "Confusion Matrix"),
          verbatimTextOutput("confus")
        ),
        tabPanel(
          title = tagList(icon("chart-line"), "ROC-AUC"),
          plotOutput("roc_auc_graph", width = "400px", height = "400px"),
          verbatimTextOutput("roc_auc_value")
        ),
        tabPanel(
          title = tagList(icon("database"), "Data Preview"),
          tableOutput("data_preview")
        ),
        tabPanel(
          title = tagList(icon("ship"), "Titanic Deck Layout"),
          imageOutput("DeckImage")
        )
      )
    )

  )
)
}
