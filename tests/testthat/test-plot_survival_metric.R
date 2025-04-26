df <- data.frame(
  Survived = sample(0:1, 100, replace = TRUE),
  Age = rnorm(100, 30, 10),
  Fare = runif(100, 5, 100),
  SibSp = sample(0:3, 100, replace = TRUE),
  Parch = sample(0:2, 100, replace = TRUE),
  Cabin = sample(c(NA, "C123", "B45", "E23"), 100, replace = TRUE)
)

test_that("plot_survival_metric returns correct class obj", {
  expect_s3_class(
    plot_survival_metric(df, "Age"),
    "gg"
  )
  expect_s3_class(
    plot_survival_metric(df, "Cabin"),
    "gg"
  )
})

test_that("plot_survival_metric defensive checks", {
  expect_error(
    plot_survival_metric(data.frame(Age = 20:25), "Age"),
    "must include a 'Survived'"
  )
  expect_error(plot_survival_metric(df, "Banana"), "Metric 'Banana' not found in the dataset.")
})

test_that("cabin letters are correctly extracted", {
  plot_obj <- plot_survival_metric(df, "Cabin")
  cabin_letters <- ggplot2::ggplot_build(plot_obj)$layout$panel_params[[1]]$x$get_labels()

  expect_setequal(cabin_letters, c("B", "C", "E"))
})
