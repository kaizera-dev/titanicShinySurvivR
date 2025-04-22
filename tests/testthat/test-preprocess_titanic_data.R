test_that("preprocess_titanic_data returns correct structure", {
  df <- data.frame(
    Survived = sample(0:1, 5, replace = TRUE),
    Pclass = sample(1:3, 5, replace = TRUE),
    Sex = sample(c("male", "female"), 5, replace = TRUE),
    Age = sample(20:50, 5, replace = TRUE),
    SibSp = sample(0:2, 5, replace = TRUE),
    Parch = sample(0:2, 5, replace = TRUE),
    Fare = runif(5, 10, 100),
    Embarked = sample(c("S", "C", "Q"), 5, replace = TRUE),
    Cabin = sample(c("C123", NA, "E44"), 5, replace = TRUE)
  )

  result <- preprocess_titanic_data(df, df)

  expect_type(result, "list")
  expect_named(result, c("train", "test", "recipe"))
  expect_s3_class(result$train, "data.frame")
  expect_s3_class(result$test, "data.frame")
})

test_that("preprocessed data contains engineered features and drops Cabin", {
  df <- data.frame(
    Survived = c(1, 0, 1, 0, 1),
    Pclass = c(1, 2, 3, 1, 2),
    Sex = c("male", "female", "male", "female", "male"),
    Age = c(22, 30, 25, 35, 40),
    SibSp = c(0, 1, 1, 0, 0),
    Parch = c(0, 0, 2, 1, 0),
    Fare = c(30, 45, 50, 60, 70),
    Embarked = c("S", "C", "Q", "S", "C"),
    Cabin = c("B22", NA, "C85", "E23", NA)
  )

  processed <- preprocess_titanic_data(df, df)
  train_df <- processed$train

  expect_true(all(c("HaveCabin", "CabinDeck", "FamilySize", "IsAlone") %in% colnames(train_df)))
  expect_false("Cabin" %in% colnames(train_df))
})

test_that("Pclass, Sex, Embarked, and CabinDeck are factors", {
  df <- data.frame(
    Survived = c(1, 0, 1, 0),
    Pclass = c(1, 2, 3, 1),
    Sex = c("male", "female", "male", "female"),
    Age = c(22, 30, 25, 35),
    SibSp = c(0, 1, 1, 0),
    Parch = c(0, 0, 2, 1),
    Fare = c(30, 45, 50, 60),
    Embarked = c("S", "C", "Q", "S"),
    Cabin = c("B22", "C85", NA, "E23")
  )

  result <- preprocess_titanic_data(df, df)$train

  expect_s3_class(result$Pclass, "factor")
  expect_s3_class(result$Sex, "factor")
  expect_s3_class(result$Embarked, "factor")
  expect_s3_class(result$CabinDeck, "factor")
})

