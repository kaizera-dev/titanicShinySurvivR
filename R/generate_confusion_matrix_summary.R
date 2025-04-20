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

  paste(lapply(conf_mx_list, extract_confusion_matrix),
        collapse = "\n\n")
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
    return(paste("Model:", cm$Model, "- Invalid confusion matrix"))
  }

  mat <- cm$ConfusionMatrix
  f1 <- 2 * cm$Precision * cm$Recall / (cm$Precision + cm$Recall)

  paste0(
    "Model: ", cm$Model, "\n",
    "Confusion Matrix:\n",
    "            Predicted 0   Predicted 1\n",
    sprintf("Actual 0:      %3d          %3d\n", mat[1,1], mat[1,2]),
    sprintf("Actual 1:      %3d          %3d\n", mat[2,1], mat[2,2]),
    sprintf("Accuracy: %.3f%%\n", cm$Accuracy),
    sprintf("Precision: %.3f%%\n", cm$Precision),
    sprintf("Recall: %.3f%%\n", cm$Recall),
    sprintf("F1 Score: %.3f%%\n", f1)
  )

}
