test_that("format_model_insights returns a formatted character string for valid input", {
  cm_list <- list(
    glm = list(
      Model = "Logistic Regression",
      Accuracy = 90,
      Precision = 87,
      Recall = 85
    ),
    rf = list(
      Model = "Random Forest",
      Accuracy = 92.5,
      Precision = 89,
      Recall = 91
    )
  )

  output <- format_model_insights(cm_list)
  expect_type(output, "character")
  expect_match(output, "Model: Logistic Regression")
  expect_match(output, "Model: Random Forest")
})

test_that("format_model_insights throws error when input is not a list", {
  not_a_list <- data.frame(
    Model = "Something",
    Accuracy = 95,
    Precision = 93,
    Recall = 90
  )

  expect_error(format_model_insights(not_a_list), "`conf_mx_list` must be a plain list")
})

test_that("format_model_insights throws error when a required field is missing", {
  cm_list <- list(
    broken_model = list(
      Model = "Oops",
      Accuracy = 90,
      Precision = 85
    )
  )

  expect_error(format_model_insights(cm_list), "missing required fields: Recall")
})

test_that("format_model_insights throws error when Model is not a character", {
  cm_list <- list(
    bad_model = list(
      Model = 123,
      Accuracy = 90,
      Precision = 85,
      Recall = 82
    )
  )

  expect_error(format_model_insights(cm_list), "`Model` must be a character string")
})
