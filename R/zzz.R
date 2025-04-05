#' @importFrom stats predict na.omit
#' @importFrom magrittr %>%
#' @importFrom rlang .data
#' @importFrom ggplot2 ggplot aes geom_bar geom_density labs theme_minimal geom_line
#' @importFrom dplyr mutate filter group_by summarise
#' @importFrom shiny fluidPage titlePanel sidebarLayout sidebarPanel mainPanel
#' @importFrom shiny fileInput actionButton selectInput sliderInput numericInput
#' @importFrom shiny checkboxInput conditionalPanel tabsetPanel tabPanel uiOutput
#' @importFrom shiny tableOutput verbatimTextOutput plotOutput renderTable
#' @importFrom shiny renderText renderPlot renderUI reactiveVal reactive observeEvent
#' @importFrom shiny showNotification validate need req
#' @noRd
NULL

utils::globalVariables(c(
  "Age", "Fare", "Survived", "Embarked", "Cabin", "SibSp",
  "Parch", "FamilySize", "CabinDeck", ".data"
))
