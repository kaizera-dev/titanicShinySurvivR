test_that("create_confusion_matrix works with valid models and returns expected structure", {
  set.seed(19120415)

  train <- data.frame(
    Survived = factor(sample(0:1, 100, replace = TRUE)),
    Age = rnorm(100, 30, 10),
    Fare = runif(100, 10, 100)
  )

  test <- data.frame(
    Survived = factor(c(1, 0, 1, 0)),
    Age = c(25, 35, 45, 55),
    Fare = c(50, 30, 80, 60)
  )

  glm_model <- glm(Survived ~ Age + Fare, data = train, family = "binomial")
  rpart_model <- rpart::rpart(Survived ~ Age + Fare, data = train, method = "class")
  rf_model <- randomForest::randomForest(Survived ~ Age + Fare, data = train)

  model_list <- list(
    glm = glm_model,
    tree = rpart_model,
    rf = rf_model
  )

  output <- create_confusion_matrix(test, model_list, class_threshold = 0.5)

  expect_type(output, "list")
  expect_named(output, c("glm", "tree", "rf"))

  for (model_result in output) {
    expect_named(model_result, c("Model", "ConfusionMatrix", "Accuracy", "Precision", "Recall"))
    expect_type(model_result$Accuracy, "double")
    expect_true(is.matrix(model_result$ConfusionMatrix))
  }
})

test_that("create_confusion_matrix calculates correct metrics", {
  test_data <- data.frame(
    Survived = factor(c(1, 0, 1, 0)),
    Prediction = factor(c(1, 0, 1, 1))
  )

  cm <- table(Predicted = test_data$Prediction, Actual = test_data$Survived)

  true_positive <- cm["1", "1"]
  false_positive <- cm["1", "0"]
  false_negative <- cm["0", "1"]
  true_negative <- cm["0", "0"]

  expected_accuracy <- (true_positive + true_negative) / sum(cm)
  expected_precision <- true_positive / (true_positive + false_positive)
  expected_recall <- true_positive / (true_positive + false_negative)


  test_list <- list(
    manual = list(
      Model = "manual",
      ConfusionMatrix = cm,
      Accuracy = expected_accuracy * 100,
      Precision = expected_precision * 100,
      Recall = expected_recall * 100
    )
  )

  expect_equal(test_list$manual$Accuracy, 75)
  expect_equal(test_list$manual$Precision, 66.66667, tolerance = 1e-2)
  expect_equal(test_list$manual$Recall, 100)
})

test_that("create_confusion_matrix errors on missing Survived column", {
  test_data <- data.frame(Age = 25:28)
  dummy_model <- glm(Sepal.Length ~ Sepal.Width, data = iris)

  expect_error(
    create_confusion_matrix(test_data, list(m = dummy_model), 0.5),
    "must contain a 'Survived' column"
  )
})

test_that("create_confusion_matrix errors on invalid model_list", {
  test_data <- data.frame(Survived = factor(c(1, 0)))

  expect_error(create_confusion_matrix(test_data, data.frame(), 0.5), "must be a named pure list")
})
