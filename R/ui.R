titanic_ui <- function() {

  shiny::fluidPage(
    shiny::titlePanel("Titanic SurvivR"),
    shiny::sidebarLayout(
      shiny::sidebarPanel(
        shiny::fileInput("upload", "Upload Dataset (.csv Only)", accept = ".csv"),
        shiny::actionButton("default", "Use Kaggle Dataset"),
        shiny::selectInput("pclass", "Passenger Class:",
                           choices = c("1st Class" = 1,
                                       "2nd Class" = 2,
                                       "3rd Class" = 3)),
        shiny::selectInput("sex", "Sex:",
                           choices = c("Male" = "male",
                                       "Female" = "female")),
        shiny::sliderInput("age", "Age:",
                           min = 0, max = 100, value = 25),
        shiny::numericInput("sibsp", "Number of Siblings/Spouses Aboard:",
                            value = 0, min = 0),
        shiny::numericInput("parch", "Number of Parents/Children Aboard:",
                            value = 0, min = 0),
        shiny::numericInput("fare", "Fare Paid (£):",
                            value = 50, min = 0),
        shiny::selectInput("embark", "Port of Embarkation:",
                           choices = c("Cherbourg" = "C",
                                       "Queenstown" = "Q",
                                       "Southampton" = "S")),
        shiny::selectInput("cabin_deck", "Cabin Deck:",
                           choices = c("Any / Unknown" = "U",
                                       "A Deck" = "A",
                                       "B Deck" = "B",
                                       "C Deck" = "C",
                                       "D Deck" = "D",
                                       "E Deck" = "E",
                                       "F Deck" = "F",
                                       "G Deck" = "G")),
        shiny::selectInput("model", "Select Prediction Model:",
                           choices = c("Logistic Regression",
                                       "Decision Tree",
                                       "Random Forest")),
        shiny::checkboxInput("show_advanced", "Show Advanced Options", value = FALSE),
        shiny::conditionalPanel(
          condition = "input.show_advanced == true",
          shiny::numericInput("seed", "Set a test/training split seed", value = 19120415),
          shiny::sliderInput("threshold", "Select Classification Threshold",
                             min = 0, max = 1, value = 0.50)
        ),
        shinyBS::bsTooltip("seed",
                           "This seed changes the randomisation of rows assigned to test and training datasets.",
                           "right", options = list(container = "body")),
        shinyBS::bsTooltip("threshold",
                           "This value sets the probability cutoff for classifying survival. Predictions above this value are labeled as survived.",
                           "right", options = list(container = "body"))
      ),

      shiny::mainPanel(
        shiny::tabsetPanel(
          shiny::tabPanel(
            title = shiny::tagList(shiny::icon("info-circle"), "Introduction"),
            shiny::fluidRow(
              shiny::column(
                width = 8,
                shiny::uiOutput("intro")
              ),
              shiny::column(
                width = 4,
                shiny::tags$div(
                  shiny::img(
                    src = "www/TTSR_logo.jpg",
                    height = "250px",
                    style = "display: block; margin: 0 auto;"
                  )
                )
              )
            )
          ),
          shiny::tabPanel(
            title = shiny::tagList(shiny::icon("magic"), "Prediction"),
            shiny::verbatimTextOutput("pred")
          ),
          shiny::tabPanel(
            title = shiny::tagList(shiny::icon("chart-bar"), "Survival Patterns"),
            shinyBS::bsCollapse(id = "collapse_survival",
                                shinyBS::bsCollapsePanel(
                                  "Survival by Feature (Not Affected by Advanced Options)",
                                  shiny::plotOutput("survival_plot"),
                                  shiny::selectInput("metric", "Choose Plot Metric:",
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
                                  shiny::plotOutput("probability_plot")
                                )
            )
          ),
          shiny::tabPanel(
            title = shiny::tagList(shiny::icon("table"), "Confusion Matrix"),
            shiny::verbatimTextOutput("confus")
          ),
          shiny::tabPanel(
            title = shiny::tagList(shiny::icon("chart-line"), "ROC-AUC"),
            shiny::plotOutput("roc_auc_graph", width = "400px", height = "400px"),
            shiny::verbatimTextOutput("roc_auc_value")
          ),
          shiny::tabPanel(
            title = shiny::tagList(shiny::icon("database"), "Data Preview"),
            shiny::tableOutput("data_preview")
          ),
          shiny::tabPanel(
            title = shiny::tagList(shiny::icon("ship"), "Titanic Deck Layout"),
            shiny::img(src = "www/titanic_layout.png", height = "800px", width = "525px")
          )
        )
      )
    )
  )
}
