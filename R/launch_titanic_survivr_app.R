#' Launch Titanic SurvivR Shiny App
#'
#' Runs Titanic SurvivR.
#' @export
launch_titanic_survivr_app <- function() {
  shiny::shinyApp(
    ui = titanicShinySurvivR:::titanic_ui(),
    server = titanicShinySurvivR:::titanic_server
  )
}
