set.seed(42)
df <- data.frame(
  Survived = sample(0:1, 100, replace = TRUE),
  Pclass = sample(1:3, 100, replace = TRUE),
  Sex = sample(c("male", "female"), 100, replace = TRUE),
  Age = rnorm(100, 30, 10),
  SibSp = sample(0:3, 100, replace = TRUE),
  Parch = sample(0:2, 100, replace = TRUE),
  Fare = runif(100, 0, 100),
  Embarked = sample(c("S", "C", "Q"), 100, replace = TRUE)
)

df$Sex <- as.factor(df$Sex)
df$Embarked <- as.factor(df$Embarked)
df$Pclass <- as.factor(df$Pclass)

log_model <- glm(Survived ~ ., data = df, family = binomial)
tree_model <- rpart::rpart(Survived ~ ., data = df, method = "class")
forest_model <- randomForest::randomForest(Survived ~ ., data = df, ntree = 10)

# ---- Tests for rename_important_features ----

test_that("rename_important_features maps known keys correctly", {
  expect_equal(unname(rename_important_features("Pclass2")), "\nPassenger Class")
  expect_equal(unname(rename_important_features("Sexmale")), "\nSex")
  expect_equal(unname(rename_important_features("IsAlone")), "\nTravelling Alone")
})

test_that("rename_important_features returns original if unmatched", {
  expect_equal(rename_important_features("UnknownFeature"), "UnknownFeature")
})

# ---- Tests for extract_important_features ----

test_that("extract_important_features works for logistic regression", {
  output <- capture.output(extract_important_features(log_model, "Logistic Regression"))
  expect_true(any(grepl("Passenger Class", output)))
})

test_that("extract_important_features works for decision tree", {
  output <- capture.output(extract_important_features(tree_model, "Decision Tree"))
  expect_type(output, "character")
})

test_that("extract_important_features works for random forest", {
  output <- capture.output(extract_important_features(forest_model, "Random Forest"))
  expect_true(any(grepl("Fare Paid|Sex|Age", output)))
})

test_that("extract_important_features errors with unknown model", {
  dummy_model <- lm(Survived ~ Age, data = df)
  expect_error(extract_important_features(dummy_model, "Unsupported Model"))
})

test_that("error for unsupported model", {
  dummy_model <- lm(mpg ~ wt, data = mtcars)
  expect_error(
    extract_important_features(dummy_model, "Neural Net"),
    "Unsupported model type. Use 'Logistic Regression', 'Decision Tree', or 'Random Forest'."
  )
})
