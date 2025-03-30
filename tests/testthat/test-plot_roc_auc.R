set.seed(19120415)

n_train <- 100
n_test <- 50

train <- data.frame(
  Survived = sample(0:1, n_train, replace = TRUE),
  Age = runif(n_train, 18, 60),
  Fare = runif(n_train, 10, 100),
  Pclass = sample(1:3, n_train, replace = TRUE),
  Sex = sample(c("male", "female"), n_train, replace = TRUE),
  SibSp = sample(0:3, n_train, replace = TRUE),
  Embarked = sample(c("C", "Q", "S"), n_train, replace = TRUE)
)
train$Survived <- as.factor(train$Survived)

test <- data.frame(
  Survived = sample(0:1, n_test, replace = TRUE),
  Age = runif(n_test, 18, 60),
  Fare = runif(n_test, 10, 100),
  Pclass = sample(1:3, n_test, replace = TRUE),
  Sex = sample(c("male", "female"), n_test, replace = TRUE),
  SibSp = sample(0:3, n_test, replace = TRUE),
  Embarked = sample(c("C", "Q", "S"), n_test, replace = TRUE)
)
test$Survived <- as.factor(test$Survived)

test_that("plot_roc_auc handles glm, rpart, and randomForest", {

  set.seed(19120415)

  glm_model <- glm(Survived ~ ., data = train, family = "binomial")
  rpart_model <- rpart::rpart(Survived ~ ., data = train, method = "class")
  rf_model <- randomForest::randomForest(Survived ~ ., data = train)

  models <- list(glm = glm_model, rpart = rpart_model, rf = rf_model)

  expect_no_error(plot_roc_auc(test, models, "glm"))
  expect_no_error(plot_roc_auc(test, models, "rpart"))
  expect_no_error(plot_roc_auc(test, models, "rf"))
})

test_that("plot_roc_auc throws error for unsupported model", {
  fake_model <- list(class = "unsupported")
  models <- list(bad = fake_model)

  test_data <- data.frame(
    Survived = c(0, 1),
    Age = c(22, 30),
    Fare = c(50, 60)
  )

  expect_error(
    plot_roc_auc(test_data, models, "bad"),
    "Unsupported model type"
  )
})
