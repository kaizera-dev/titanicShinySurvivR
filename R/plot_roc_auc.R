#' Plot ROC Curve and AUC
#'
#' Internal function for the Titanic Shiny app. Generates an ROC curve and computes AUC
#' for a selected model using test data.
#'
#' @param testing_data A data frame with actual outcomes and predictors.
#' @param model_list A named list of trained classification models.
#' @param selected_model A string: the name of the model to evaluate.
#'
#' @keywords internal
#' @noRd
plot_roc_auc <- function(testing_data,
                         model_list,
                         selected_model) {
  actual <- testing_data$Survived

  model <- model_list[[selected_model]]

  predicted_prob <- if (inherits(model, "glm")) {
    predicted_prob <- predict(model, newdata = testing_data, type = "response")
  } else if (inherits(model, "rpart")) {
    predicted_prob <- predict(model, newdata = testing_data, type = "prob")[, "1"]
  } else if (inherits(model, "randomForest")) {
    predicted_prob <- predict(model, newdata = testing_data, type = "prob")[, "1"]
  } else {
    stop("Unsupported model type. Expected 'glm', 'rpart', or 'randomForest'.")
  }

  roc_obj <- pROC::roc(actual, predicted_prob)

  plot(roc_obj,
       main = paste0("ROC-AUC for the ", selected_model, " model"))
}
