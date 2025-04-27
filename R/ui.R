titanic_ui <- function() {
  shiny::fluidPage(
    theme = bslib::bs_theme(
      version = 5,
      bootswatch = "minty",
      primary = "#003366",
      secondary = "#e67e22",
      base_font = bslib::font_google("Roboto"),
      heading_font = bslib::font_google("Bebas Neue"),
      code_font = bslib::font_google("Fira Code")
    ),
    titlePanel(
      shiny::tagList(
        shiny::img(src = "www/TTSR_logo.png", height = "50px", style = "margin-right: 10px;"),
        shiny::tags$title("Titanic SurvivR")
      )
    ),
    shiny::sidebarLayout(
      shiny::sidebarPanel(
        width = 3,
        htmltools::div(
          class = "p-3 mb-3 bg-white rounded shadow-sm border",
          shiny::fileInput("upload", "Upload Dataset (.csv Only)", accept = ".csv"),
          shiny::actionButton("default", "Use Kaggle Dataset")
        ),
        htmltools::div(
          class = "p-3 mb-3 bg-white rounded shadow-sm border",
          shiny::selectInput("pclass", "Passenger Class:",
            choices = c(
              "1st Class" = 1,
              "2nd Class" = 2,
              "3rd Class" = 3
            )
          ),
          shiny::selectInput("sex", "Sex:",
                             choices = c("Male" = "male",
                                         "Female" = "female")),
          shiny::sliderInput("age", "Age:",
                             min = 0,
                             max = 100,
                             value = 25),
          shiny::numericInput("sibsp", "Number of Siblings/Spouses Aboard:",
                              value = 0,
                              min = 0),
          shiny::numericInput("parch", "Number of Parents/Children Aboard:",
                              value = 0,
                              min = 0),
          shiny::numericInput("fare", "Fare Paid (£):",
                              value = 50,
                              min = 0),
          shiny::selectInput("embark", "Port of Embarkation:",
                             choices = c("Cherbourg" = "C",
                                         "Queenstown" = "Q",
                                         "Southampton" = "S")),
          shiny::selectInput("cabin_deck",
                             "Cabin Deck:",
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
          shiny::checkboxInput("show_advanced", "Show Advanced Options",
                               value = FALSE),
          shiny::conditionalPanel(
            condition = "input.show_advanced == true",
            shiny::numericInput("seed", "Set a test/training split seed",
                                value = 19120415),
            shiny::sliderInput("threshold", "Select Classification Threshold",
                               min = 0,
                               max = 1,
                               value = 0.50)
          )
        )
      ),
      shiny::mainPanel(
        shiny::tabsetPanel(
          shiny::tabPanel(
            title = shiny::tagList(shiny::icon("info-circle"), "Introduction"),
            shiny::fluidRow(
              shiny::column(
                12,
                htmltools::div(
                  style = "text-align: center;",
                  shiny::img(src = "www/TTSR_logo.png", height = "200px"),
                  shiny::h1("Welcome to Titanic SurvivR!")
                ),
                shiny::uiOutput("intro")
              )
            )
          ),
          shiny::tabPanel(title = shiny::tagList(shiny::icon("magic"), "Prediction"), shiny::verbatimTextOutput("pred")),
          shiny::tabPanel(
            title = shiny::tagList(shiny::icon("chart-bar"), "Survival Patterns"),
            htmltools::div(
              class = "accordion", id = "accordionSurvival",
              create_accordion_panel(
                id = "collapseOne",
                header_text = "Survival by Feature (Not Affected by Advanced Options)",
                body_content = shiny::tagList(
                  shiny::plotOutput("survival_plot"),
                  shiny::selectInput("metric", "Choose Plot Metric:",
                    choices = c("Passenger Class" = "Pclass",
                                "Sex",
                                "Cabin Deck" = "Cabin",
                                "Port of Embarkation" = "Embarked",
                                "Age",
                                "Fare",
                                "Number of Siblings/Spouses Aboard" = "SibSp",
                                "Number of Parents/Children Aboard" = "Parch")
                  )
                ),
                show = FALSE,
                parent_id = "accordionSurvival"
              ),
              create_accordion_panel(
                id = "collapseTwo",
                header_text = "Predicted Probability Distribution For Model",
                body_content = shiny::plotOutput("probability_plot"),
                show = FALSE,
                parent_id = "accordionSurvival"
              )
            )
          ),
          shiny::tabPanel(title = shiny::tagList(shiny::icon("table"),
                                                 "Confusion Matrix"),
                          shiny::verbatimTextOutput("confus")),
          shiny::tabPanel(
            title = shiny::tagList(shiny::icon("chart-line"), "ROC-AUC"),
            shiny::plotOutput("roc_auc_graph", width = "400px", height = "400px"),
            shiny::verbatimTextOutput("roc_auc_value")
          ),
          shiny::tabPanel(
            title = shiny::tagList(shiny::icon("database"), "Data Preview"),
            shiny::verbatimTextOutput("preview_note"),
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
