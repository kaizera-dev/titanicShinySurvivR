test_that("extract_confusion_matrix returns correct values for valid 2x2 matrix", {
  cm <- list(
    Model = "TestModel",
    ConfusionMatrix = matrix(c(10, 2, 3, 15), nrow = 2, byrow = TRUE)
  )

  result <- extract_confusion_matrix(cm)

  expect_equal(class(result), "character")
  expect_match(result, "Model: TestModel")
  expect_match(result, "Actual 0")
  expect_match(result, "Actual 1")
  expect_match(result, "Predicted 0")
  expect_match(result, "Predicted 1")
})

test_that("extract_confusion_matrix returns error field for invalid confusion matrix", {
  cm_missing <- list(Model = "MissingCM")
  cm_not_matrix <- list(Model = "NotMatrix", ConfusionMatrix = data.frame(A = 1:2))
  cm_wrong_dim <- list(Model = "WrongDim", ConfusionMatrix = matrix(1:3, nrow = 3))

  expect_error(extract_confusion_matrix(cm_missing), "Invalid confusion matrix")
  expect_error(extract_confusion_matrix(cm_not_matrix), "Invalid confusion matrix")
  expect_error(extract_confusion_matrix(cm_wrong_dim), "Invalid confusion matrix")
})
