#' Validate Titanic Data
#'
#' Internal function for the Titanic SurvivR Shiny app. Checks Titanic dataset
#' for required structure and valid values.
#'
#' @param df Titanic dataset to validate.
#'
#' @keywords internal
#' @noRd
validate_titanic_data <- function(df) {
  if (nrow(df) == 0) {
    return("Please use a dataset that is not empty.")
  }

  if (!is.data.frame(df)) {
    return("Dataset must be a data.frame.")
  }

  required_cols <- c("Survived", "Pclass", "Sex", "Age", "SibSp", "Parch", "Fare", "Embarked", "Cabin")

  missing_cols <- setdiff(required_cols, names(df))
  if (length(missing_cols) > 0) {
    return(paste(
      "Error: The dataset is missing the following required columns:",
      paste(missing_cols, collapse = ", ")
    ))
  }

  all_na_cols <- sapply(df[required_cols], function(x) all(is.na(x)))
  if (any(all_na_cols)) {
    return(
      paste(
        "The following required columns contain only NA values in `df`:",
        paste(names(all_na_cols[all_na_cols]), collapse = ", ")
      )
    )
  }

  if (!all(df$Survived %in% c(0, 1))) {
    return("Error: `Survived` must contain only 0 or 1.")
  }
  if (!all(df$Pclass %in% c(1, 2, 3))) {
    return("Error: `Pclass` must only contain values of 1, 2, or 3.")
  }
  if (!all(df$Sex %in% c("male", "female"))) {
    return("Error: `Sex` must contain only 'male' or 'female'.")
  }
  if (any(df$Age < 0, na.rm = TRUE)) {
    return("Error: `Age` must be non-negative.")
  }
  if (!all(df$Embarked %in% c("C", "Q", "S", NA))) {
    return("Error: `Embarked` must be one of 'C', 'Q', 'S', or missing.")
  }
  if (any(df$Fare < 0, na.rm = TRUE)) {
    return("Error: `Fare` must be non-negative.")
  }

  NULL
}
