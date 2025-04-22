#' Plot Predicted Probability Distribution
#'
#' Internal function for the Titanic Shiny app. Generates a density plot of predicted probabilities
#' on the test dataset, separated by actual class labels, and overlays a vertical line representing
#' the classification threshold.
#'
#' @param prepped_test_data A preprocessed test dataset with a binary 'Survived' column.
#' @param model_list A named list of trained classification models.
#' @param chosen_model A string indicating the selected model from \code{model_list}.
#' @param class_threshold A numeric threshold (between 0 and 1) used to classify predicted probabilities.
#'
#' @return A ggplot object visualizing the probability distributions by class.
#' @keywords internal
#' @noRd
plot_predicted_probabilites <- function(prepped_test_data,
                                        model_list,
                                        chosen_model,
                                        class_threshold) {

  if (!is.list(model_list) || !chosen_model %in% names(model_list)) {
    stop(paste(chosen_model, "not found in model list."))
  }

  actual_class <- ifelse(prepped_test_data$Survived == 1, "Yes", "No" )

  model <- model_list[[chosen_model]]
  model_class <- class(model)[1]

  predictions <- if (model_class == "glm") {
    predict(model, newdata = prepped_test_data, type = "response")
  } else if (model_class %in% c("rpart", "randomForest.formula")) {
    preds <- predict(model, newdata = prepped_test_data, type = "prob")
    if (!"1" %in% colnames(preds)) stop("Prediction output must contain column '1' for probability of class 1.")
    preds[, "1"]
  } else {
    stop("Unsupported model type. Expected 'glm', 'rpart', or 'randomForest.formula'.")
  }

  predictions_df <- data.frame(
    Probabilities = predictions,
    Survived = actual_class
  )

  ggplot2::ggplot(predictions_df, ggplot2::aes(x = Probabilities, fill = factor(Survived))) +
    ggplot2::geom_density(alpha = 0.7) +
    ggplot2::geom_vline(
      ggplot2::aes(xintercept = class_threshold, color = "Threshold"),
      linetype = "dashed"
    ) +
    ggplot2::scale_color_manual(
      name = "Reference",
      values = c("Threshold" = "blue")
    ) +
    ggplot2::labs(
      x = "Predicted Probability",
      fill = "Survived?",
      title = paste0("Probability Density Plot for ", chosen_model, " Model")
    ) + ggplot2::theme_minimal()

  }
