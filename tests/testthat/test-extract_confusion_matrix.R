test_that("extract_confusion_matrix returns correct values for valid 2x2 matrix", {
  cm <- list(
    Model = "TestModel",
    ConfusionMatrix = matrix(c(10, 2, 3, 15), nrow = 2, byrow = TRUE)
  )

  result <- extract_confusion_matrix(cm)

  expect_s3_class(result, "data.frame")
  expect_named(result, c("Model", "True_Negative", "False_Negative", "False_Positive", "True_Positive"))
  expect_equal(result$Model, "TestModel")
  expect_equal(result$True_Negative, 10)
  expect_equal(result$False_Negative, 2)
  expect_equal(result$False_Positive, 3)
  expect_equal(result$True_Positive, 15)
})

test_that("extract_confusion_matrix returns error field for invalid confusion matrix", {
  cm_missing <- list(Model = "MissingCM")
  cm_not_matrix <- list(Model = "NotMatrix", ConfusionMatrix = data.frame(A = 1:2))
  cm_wrong_dim <- list(Model = "WrongDim", ConfusionMatrix = matrix(1:3, nrow = 3))

  expect_equal(extract_confusion_matrix(cm_missing)$Error, "Invalid confusion matrix")
  expect_equal(extract_confusion_matrix(cm_not_matrix)$Error, "Invalid confusion matrix")
  expect_equal(extract_confusion_matrix(cm_wrong_dim)$Error, "Invalid confusion matrix")
})
