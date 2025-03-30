#' Generate Confusion Matrix Summary
#'
#' Internal function for the Titanic SurvivR Shiny app. Summarises a list of confusion matrices into a data frame
#' with accuracy, precision, recall, and other classification metrics.
#'
#' @param conf_mx_list A named list containing confusion matrices and model names.
#'
#' @keywords internal
#' @noRd
generate_confusion_matrix_summary <- function(conf_mx_list) {
  if (!is.list(conf_mx_list) || length(conf_mx_list) == 0) {
    stop("Error: Confusion matrix list is empty or not in the correct format.")
  }

  do.call(rbind, lapply(conf_mx_list, extract_confusion_matrix))
}

#' Extract Confusion Matrix Values
#'
#' Internal helper for the Titanic Shiny app. Extracts TP, TN, FP, and FN values
#' from a 2x2 confusion matrix.
#'
#' @param cm A list with elements `Model` and `ConfusionMatrix` (a 2x2 matrix).
#'
#' @keywords internal
#' @noRd
extract_confusion_matrix <- function(cm) {
  if (!"ConfusionMatrix" %in% names(cm) || !is.matrix(cm$ConfusionMatrix) || dim(cm$ConfusionMatrix)[1] != 2) {
    return(data.frame(Model = cm$Model, Error = "Invalid confusion matrix"))
  }

  data.frame(
    Model = cm$Model,
    True_Negative = cm$ConfusionMatrix[1, 1],
    False_Negative = cm$ConfusionMatrix[1, 2],
    False_Positive = cm$ConfusionMatrix[2, 1],
    True_Positive = cm$ConfusionMatrix[2, 2]
  )
}
