data("train", package = "titanicShinySurvivR")

test_that("plot_predicted_probabilites throws errors on invalid inputs", {
  dummy_model <- glm(Survived ~ ., data = train[1:100, ], family = "binomial")
  dummy_list <- list("Logistic Regression" = dummy_model)

  expect_error(
    plot_predicted_probabilites(train, list(), "Logistic Regression", 0.5),
    "Logistic Regression not found"
  )

  expect_error(
    plot_predicted_probabilites(train, dummy_list, "MissingModel", 0.5),
    "MissingModel not found"
  )
})

test_that("plot_predicted_probabilites works for logistic regression", {
  data <- train[1:100, ]
  data <- data[complete.cases(data$Age), ]
  model <- glm(Survived ~ Age + Sex, data = data, family = "binomial")
  model_list <- list("Logistic Regression" = model)

  expect_s3_class(
    plot_predicted_probabilites(data, model_list, "Logistic Regression", 0.5),
    "ggplot"
  )
})
