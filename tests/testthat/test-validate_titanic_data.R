
valid_df <- data.frame(
  Survived = c(1, 0),
  Pclass = c(1, 2),
  Sex = c("male", "female"),
  Age = c(22, 35),
  SibSp = c(0, 1),
  Parch = c(0, 0),
  Fare = c(30, 50),
  Embarked = c("S", "C"),
  Cabin = c("C123", "E22")
)

test_that("validate_titanic_data returns error for empty dataset", {
  df <- data.frame()
  expect_equal(validate_titanic_data(df), "Please use a dataset that is not empty.")
})

test_that("validate_titanic_data returns error if not a data frame", {
  not_df <- matrix(1:10, nrow = 2)
  expect_equal(validate_titanic_data(not_df), "Dataset must be a data.frame.")
})

test_that("validate_titanic_data returns error for missing columns", {
  df <- data.frame(Survived = c(1, 0))
  expect_match(validate_titanic_data(df), "missing the following required columns")
})

test_that("validate_titanic_data returns error if any required column is all NA", {
  df <- data.frame(
    Survived = c(1, 0),
    Pclass = c(1, 2),
    Sex = c("male", "female"),
    Age = c(22, 35),
    SibSp = c(0, 1),
    Parch = c(0, 0),
    Fare = c(30, 50),
    Embarked = c("S", "C"),
    Cabin = NA
  )
  expect_equal(validate_titanic_data(df),
               "The following required columns contain only NA values in `df`: Cabin")
})

test_that("validate_titanic_data catches invalid Survived values", {
  df <- valid_df
  df$Survived <- 3

  expect_equal(validate_titanic_data(df), "Error: `Survived` must contain only 0 or 1.")
})

test_that("validate_titanic_data catches invalid Pclass values", {
  df <- valid_df
  df$Pclass <- c(1, 4)
  expect_equal(validate_titanic_data(df), "Error: `Pclass` must only contain values of 1, 2, or 3.")
})

test_that("validate_titanic_data catches invalid Sex values", {
  df <- valid_df
  df$Sex <- c("male", "unknown")
  expect_equal(validate_titanic_data(df), "Error: `Sex` must contain only 'male' or 'female'.")
})

test_that("validate_titanic_data catches negative Age values", {
  df <- valid_df
  df$Age[1] <- -10
  expect_equal(validate_titanic_data(df), "Error: `Age` must be non-negative.")
})

test_that("validate_titanic_data catches invalid Embarked values", {
  df <- valid_df
  df$Embarked <- c("X", "Q")
  expect_equal(validate_titanic_data(df), "Error: `Embarked` must be one of 'C', 'Q', 'S', or missing.")
})

test_that("validate_titanic_data catches negative Fare values", {
  df <- valid_df
  df$Fare[1] <- -5
  expect_equal(validate_titanic_data(df), "Error: `Fare` must be non-negative.")
})

test_that("validate_titanic_data returns NULL for valid data", {
  df <- data.frame(
    Survived = c(1, 0),
    Pclass = c(1, 2),
    Sex = c("male", "female"),
    Age = c(22, 35),
    SibSp = c(0, 1),
    Parch = c(0, 0),
    Fare = c(30, 50),
    Embarked = c("S", "C"),
    Cabin = c("C123", "E22")
  )
  expect_null(validate_titanic_data(df))
})

