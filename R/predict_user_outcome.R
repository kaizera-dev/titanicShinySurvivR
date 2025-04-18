#' Predict User Survival Outcome
#'
#' Internal function for the Titanic Shiny app. Predicts survival outcome
#' for a user using the selected classification model.
#'
#' @param model_list Named list of trained models.
#' @param selected_model String name of the model to use.
#' @param user_data A data frame with input features.
#' @param threshold Probability threshold for classification.
#'
#' @keywords internal
#' @noRd
predict_user_outcome <- function(model_list,
                                 selected_model,
                                 user_data,
                                 threshold) {

  if (!is.list(model_list) || is.null(names(model_list))) {
    stop("`model_list` must be a named list of models.")
  }

  if (!selected_model %in% names(model_list)) {
    stop("`selected_model` must be one of the names in `model_List`.")
  }

  if (!is.data.frame(user_data)) {
    stop("`user_data` must be a data frame.")
  }

  if (!is.numeric(threshold) || length(threshold) != 1 || is.na(threshold) || threshold < 0 || threshold > 1) {
    stop("`threshold` must be a numeric value between 0 and 1.")
  }

  chosen_model_obj <- model_list[[selected_model]]

  prob <- if (inherits(chosen_model_obj, "glm")) {
    as.numeric(predict(chosen_model_obj, newdata = user_data, type = "response"))
  } else if (inherits(chosen_model_obj, "rpart") || inherits(chosen_model_obj, "randomForest")) {
    as.numeric(predict(chosen_model_obj, newdata = user_data, type = "prob")[ ,"1"])
  } else {
    stop("Unsupported model type. Supported types: glm, rpart, randomForest.")
  }

  predicted_class <- ifelse(prob > threshold, "You survived!", "You did not make it.")

  paste("Selected Model:", selected_model,
        "\nOutcome:", predicted_class,
        "\nSurvival Probability:", round(prob, 3))

}


