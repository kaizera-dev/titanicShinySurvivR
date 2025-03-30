test_that("predict_user_outcome works for supported model types", {
  set.seed(42)

  train_data <- data.frame(
    Survived = factor(sample(0:1, 50, replace = TRUE)),
    Age = rnorm(50, 30, 10),
    Fare = runif(50, 20, 80)
  )

  user_input <- data.frame(Age = 28, Fare = 50)

  glm_model <- glm(Survived ~ Age + Fare, data = train_data, family = binomial)
  tree_model <- rpart::rpart(Survived ~ Age + Fare, data = train_data, method = "class")
  rf_model <- randomForest::randomForest(Survived ~ Age + Fare, data = train_data)

  model_list <- list(glm = glm_model, tree = tree_model, rf = rf_model)

  expect_type(predict_user_outcome(model_list, "glm", user_input, 0.5), "character")
  expect_type(predict_user_outcome(model_list, "tree", user_input, 0.5), "character")
  expect_type(predict_user_outcome(model_list, "rf", user_input, 0.5), "character")
})

test_that("predict_user_outcome errors when selected_model is not in model_list", {
  dummy_model <- glm(Sepal.Length ~ Sepal.Width, data = iris)
  expect_error(
    predict_user_outcome(list(valid = dummy_model), "invalid", iris[1, , drop = FALSE], 0.5),
    "must be one of the names in"
  )
})

test_that("predict_user_outcome errors when user_data is not a data frame", {
  dummy_model <- glm(Sepal.Length ~ Sepal.Width, data = iris)
  expect_error(
    predict_user_outcome(list(model = dummy_model), "model", "not_a_df", 0.5),
    "must be a data frame"
  )
})

test_that("predict_user_outcome errors when threshold is invalid", {
  dummy_model <- glm(Sepal.Length ~ Sepal.Width, data = iris)
  valid_input <- iris[1, , drop = FALSE]

  expect_error(predict_user_outcome(list(m = dummy_model), "m", valid_input, -0.1))
  expect_error(predict_user_outcome(list(m = dummy_model), "m", valid_input, 1.1))
  expect_error(predict_user_outcome(list(m = dummy_model), "m", valid_input, "hi"))
  expect_error(predict_user_outcome(list(m = dummy_model), "m", valid_input, c(0.5, 0.6)))
})
