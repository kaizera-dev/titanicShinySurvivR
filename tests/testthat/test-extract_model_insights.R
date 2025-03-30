test_that("extract_model_insights returns a formatted string for valid input", {
  cm <- list(
    Model = "TestModel",
    Accuracy = 91.23,
    Precision = 85.5,
    Recall = 88.2
  )

  result <- extract_model_insights(cm)
  expect_type(result, "character")
  expect_match(result, "Model: TestModel")
  expect_match(result, "Accuracy: 91.23%")
  expect_match(result, "F1 Score")
})

test_that("extract_model_insights throws error if Accuracy, Precision, or Recall are not numeric", {
  cm1 <- list(
    Model = "BadAccuracy",
    Accuracy = "91",
    Precision = 85.5,
    Recall = 88.2
  )

  cm2 <- list(
    Model = "BadPrecision",
    Accuracy = 91,
    Precision = "bad",
    Recall = 88.2
  )

  cm3 <- list(
    Model = "BadRecall",
    Accuracy = 91,
    Precision = 85.5,
    Recall = "nope"
  )

  expect_error(extract_model_insights(cm1), "Accuracy, Precision, and Recall must all be numeric.")
  expect_error(extract_model_insights(cm2), "Accuracy, Precision, and Recall must all be numeric.")
  expect_error(extract_model_insights(cm3), "Accuracy, Precision, and Recall must all be numeric.")
})

test_that("extract_model_insights throws error when Precision + Recall is zero", {
  cm <- list(
    Model = "ZeroPR",
    Accuracy = 90,
    Precision = 0,
    Recall = 0
  )

  expect_error(extract_model_insights(cm), "F1 score cannot be computed")
})

