#' Generate Confusion Matrices for Multiple Models
#'
#' Internal function for the Titanic SurvivR Shiny app. Computes confusion matrices for multiple models
#' and calculates accuracy, precision, and recall.
#'
#' @param testing_data A data frame containing the test dataset.
#' @param model_list A named list of trained models.
#' @param class_threshold A numeric threshold (0–1) for classifying probabilities.
#'
#' @keywords internal
#' @noRd
create_confusion_matrix <- function(testing_data, model_list, class_threshold) {

  if (!is.data.frame(testing_data)) {
    stop("`testing_data` must be a data frame.")
  }

  if (!"Survived" %in% names(testing_data)) {
    stop("`testing_data` must contain a 'Survived' column.")
  }

  if (!is.list(model_list) || is.null(names(model_list)) || is.data.frame(model_list)) {
    stop("`model_list` must be a named pure list of models, not a data.frame")
  }

  actual <- testing_data$Survived
  confusion_mx_list <- list()

   for (model_name in names(model_list)) {
  model <- model_list[[model_name]]

  if (inherits(model, "glm")) {
    predicted <- ifelse(
      predict(model, newdata = testing_data, type = "response") > class_threshold,
      1, 0
    )
  } else if (inherits(model, "rpart")) {
    predicted <- predict(model, newdata = testing_data, type = "class")
  } else if (inherits(model, "randomForest")) {
    predicted <- ifelse(
      predict(model, newdata = testing_data, type = "prob")[, "1"] > class_threshold,
      1, 0
    )
  } else {
    stop("Unsupported model type. Expected 'glm', 'rpart', or 'randomForest'.")
  }

  if (length(predicted) != length(actual)) {

    stop(paste0("Predicted length:", length(predicted)),
         "\n Actual length:", length(actual),
         "These must be equal.")
  }

  confusion_matrix <- as.matrix(table(
    Actual = factor(actual, levels = c(0, 1)),
    Predicted = factor(predicted, levels = c(0, 1))
  ))

  true_positive <- confusion_matrix[2, 2]
  false_positive <- confusion_matrix[2, 1]
  false_negative <- confusion_matrix[1, 2]
  true_negative <- confusion_matrix[1, 1]

  accuracy <- (true_positive + true_negative) / sum(as.matrix(confusion_matrix))
  precision <- true_positive / (true_positive + false_positive)
  recall <- true_positive / (true_positive + false_negative)

  confusion_mx_list[[model_name]] <- list(
    Model = model_name,
    ConfusionMatrix = confusion_matrix,
    Accuracy = accuracy * 100,
    Precision = precision * 100,
    Recall = recall * 100
  )
   }
  confusion_mx_list
}

