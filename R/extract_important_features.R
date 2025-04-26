.feature_map <- c(
  "Pclass"     = "\nPassenger Class",
  "Sex"        = "\nSex",
  "Age"        = "\nAge",
  "SibSp"      = "\nSiblings/Spouses Aboard",
  "Parch"      = "\nParents/Children Aboard",
  "Fare"       = "\nFare Paid",
  "Embarked"   = "\nPort of Embarkation",
  "CabinDeck"  = "\nCabin Deck",
  "FamilySize" = "\nFamily Size",
  "IsAlone"    = "\nTravelling Alone",
  "HaveCabin"  = "\nKnown Cabin"
)

#' Rename Feature Based on Predefined Mapping
#'
#' Internal helper for the Titanic SurvivR Shiny app. Matches a raw feature name
#' against known patterns and returns a more readable label for display.
#'
#' @param x A string: the raw feature name output from a model.
#'
#' @keywords internal
#' @noRd
rename_important_features <- function(x) {
  matched <- names(.feature_map)[sapply(names(.feature_map), function(key) grepl(key, x))]
  if (length(matched)) .feature_map[matched[1]] else x
}

#' Extract and Rename Important Features
#'
#' Internal function for the Titanic SurvivR Shiny app. Extracts the most relevant features from
#' a fitted model and renames them using a predefined mapping for display.
#'
#' @param model_object A trained model object. Supported types are: glm, rpart, or randomForest.
#' @param model_name A string: the name of the model.
#'
#' @keywords internal
#' @noRd

extract_important_features <- function(model_object, model_name) {
  if (missing(model_object) || missing(model_name)) {
    stop("Both model_object and model_name must be provided.")
  }

  important_features <- switch(model_name,
    "Logistic Regression" = {
      coefs <- coef(model_object)
      if (is.null(coefs)) stop("Could not extract coefficients from logistic regression model.")
      names(coefs)[-1]
    },
    "Decision Tree" = {
      if (is.null(model_object$variable.importance)) stop("No variable importance found in decision tree.")
      names(model_object$variable.importance)
    },
    "Random Forest" = {
      importance <- randomForest::importance(model_object)
      if (is.null(importance)) stop("Could not extract importance from random forest.")
      rownames(importance)
    },
    stop("Unsupported model type. Use 'Logistic Regression', 'Decision Tree', or 'Random Forest'.")
  )

  renamed_features <- sapply(important_features, rename_important_features)
  paste(unique(renamed_features), collapse = ", ")
}
