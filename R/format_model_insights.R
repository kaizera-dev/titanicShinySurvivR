#' Format Model Insights
#'
#' Internal function for the Titanic SurvivR Shiny app. Extracts and formats accuracy, precision,
#' and recall metrics from a list of confusion matrix results into a readable summary.
#'
#' @param conf_mx_list A named list of model performance metrics.
#'
#' @keywords internal
#' @noRd
format_model_insights <- function(conf_mx_list) {

  if (!is.list(conf_mx_list) || inherits(conf_mx_list, "data.frame")) {
    stop("`conf_mx_list` must be a plain list, not a data frame. Got: ", class(conf_mx_list)[1])
  }

  required_fields <- c("Model", "Accuracy", "Precision", "Recall")

  for (cm in conf_mx_list) {
    missing_fields <- setdiff(required_fields, names(cm))
    if (length(missing_fields) > 0) {
      stop("One or more confusion matrix entries are missing required fields: ",
           paste(missing_fields, collapse = ", "))
    }

    if (!is.character(cm$Model)) {
      stop("`Model` must be a character string.")
    }
  }

  sapply(conf_mx_list, extract_model_insights) %>%
    paste(collapse = "\n\n")
}

#' Extract Model Insights
#'
#' Internal function for the Titanic SurvivR Shiny app. Formats a single model's performance metrics
#' into a structured string.
#'
#' @param cm A list containing a model's confusion matrix metrics.
#'
#' @keywords internal
#' @noRd
extract_model_insights <- function(cm) {

  if (!is.numeric(cm$Accuracy) || !is.numeric(cm$Precision) || !is.numeric(cm$Recall)) {
    stop("Accuracy, Precision, and Recall must all be numeric.")
  }

  if (cm$Precision + cm$Recall == 0) {
    stop("Precision + Recall is zero, F1 score cannot be computed.")
  }

  f1_score <- 2 * (cm$Precision * cm$Recall) / (cm$Precision + cm$Recall)

  paste0(
    "Model: ", cm$Model,
    "\nAccuracy: ", round(cm$Accuracy, 3), "%",
    "\nPrecision: ", round(cm$Precision, 3), "%",
    "\nRecall: ", round(cm$Recall, 3), "%",
    "\nF1 Score: ", round(f1_score, 3), "%\n"
  )
}

