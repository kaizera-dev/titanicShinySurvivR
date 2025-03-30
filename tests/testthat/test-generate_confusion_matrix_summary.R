test_that("generate_confusion_matrix_summary aggregates multiple valid results", {
  input <- list(
    m1 = list(Model = "M1", ConfusionMatrix = matrix(c(5, 1, 2, 12), nrow = 2, byrow = TRUE)),
    m2 = list(Model = "M2", ConfusionMatrix = matrix(c(6, 2, 3, 14), nrow = 2, byrow = TRUE))
  )

  result <- generate_confusion_matrix_summary(input)

  expect_s3_class(result, "data.frame")
  expect_equal(nrow(result), 2)
  expect_equal(result$Model, c("M1", "M2"))
})

test_that("generate_confusion_matrix_summary handles invalid inputs", {
  expect_error(generate_confusion_matrix_summary(NULL), "empty or not in the correct format")
  expect_error(generate_confusion_matrix_summary(data.frame()), "empty or not in the correct format")
  expect_error(generate_confusion_matrix_summary(list()), "empty or not in the correct format")
})
