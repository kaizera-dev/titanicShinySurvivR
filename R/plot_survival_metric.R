#' Plot Survival Metric
#'
#' Internal function for the Titanic SurvivR Shiny app. Generates a ggplot object
#' showing how a given feature relates to survival.
#'
#' @param df A data frame of Titanic passenger data.
#' @param metric A string: the name of the column to visualise.
#'
#' @keywords internal
#' @noRd
plot_survival_metric <- function(df, metric) {

  if (!"Survived" %in% names(df)) {
    stop("The input data frame must include a 'Survived' column.")
  }

  if (!(metric %in% colnames(df))) {
    stop(paste0("Metric '", metric, "' not found in the dataset."))
  }

  df <- na.omit(df[c(metric, "Survived")])
  if (metric == "Cabin") {
    df <- df %>%
      dplyr::mutate(Cabin = substr(Cabin, 1, 1))
  }

  df$Survived <- ifelse(df$Survived == 1, "Yes", "No")

  density_plot_metrics <- c("Age", "Fare", "SibSp", "Parch")

  if (metric %in% density_plot_metrics) {

  ggplot2::ggplot(df, ggplot2::aes(x = .data[[metric]], fill = factor(Survived))) +
      ggplot2::geom_density(alpha = 0.7) +
      ggplot2::scale_color_manual(values = c("red", "cyan")) +
      ggplot2::theme_minimal()

  } else {

    ggplot2::ggplot(df, ggplot2::aes(x = factor(.data[[metric]]), fill = Survived)) +
      ggplot2::geom_bar(position = "dodge") +
      ggplot2::labs(x = "Metric", y = "Count", fill = "Survived?") +
      ggplot2::theme_minimal()

  }

}
