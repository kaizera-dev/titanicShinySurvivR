#' Launch Titanic SurvivR Shiny App
#'
#' Runs Titanic SurvivR.
#' @export
launch_titanic_survivr_app <- function() {
  shiny::runApp(system.file("app", package = "titanicShinySurvivR"))
}
