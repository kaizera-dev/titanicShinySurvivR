#' @importFrom stats predict na.omit
#' @importFrom magrittr %>%
#' @importFrom rlang .data
#' @importFrom ggplot2 ggplot aes geom_bar geom_density labs theme_minimal geom_line
#' @importFrom dplyr mutate filter group_by summarise
#' @noRd
NULL

utils::globalVariables(c(
  "Age", "Fare", "Survived", "Embarked", "Cabin", "SibSp",
  "Parch", "FamilySize", "CabinDeck", ".data"
))
