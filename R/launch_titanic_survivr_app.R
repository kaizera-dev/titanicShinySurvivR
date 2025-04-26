#' Launch Titanic SurvivR Shiny App
#'
#' Runs Titanic SurvivR.
#' @export
launch_titanic_survivr_app <- function() {
  shiny::shinyApp(
    ui = titanic_ui(),
    server = titanic_server
  )
}
