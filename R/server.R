titanic_server <- function(input, output, session) {
  shiny::reactiveVal("") -> current_data

  shiny::observeEvent(input$default, {
    current_data("default")
    shiny::showModal(
      shiny::modalDialog(
        title = "Loaded Titanic Dataset",
        easyClose = TRUE,
        footer = NULL,
        size = "s",
        "The Kaggle Titanic dataset has been loaded.",
        shiny::tags$br(),
        shiny::tags$button(
          "Close",
          type = "button",
          class = "btn btn-primary",
          `data-bs-dismiss` = "modal",
          `aria-label` = "Close"
        )
      )
    )
  })

  shiny::observeEvent(input$upload, {
    current_data("upload")
  })

  reactive_titanic <- shiny::reactive({
    shiny::validate(
      shiny::need(
        current_data(),
        "Please select a dataset to use for analysis."
      )
    )

    shiny::req(current_data())

    if (current_data() == "default") {
      data("train", package = "titanicShinySurvivR", envir = environment())
      train
    } else if (current_data() == "upload") {
      shiny::req(input$upload)
      readr::read_csv(input$upload$datapath)
    } else {
      NULL
    }
  })

  shiny::observeEvent(reactive_titanic(), {
    validation_error <- titanicShinySurvivR:::validate_titanic_data(reactive_titanic())
    if (!is.null(validation_error)) {
      shiny::showNotification(validation_error, type = "error", duration = NULL)
    }
  })

  output$data_preview <- shiny::renderTable({
    utils::head(reactive_titanic(), n = 15)
  })

  output$preview_note <- shiny::renderText({
    "Note: Some names were changed in the Kaggle dataset to thank those who inspired or supported this project.
These edits do not affect prediction results."
  })

  train_test_split <- shiny::reactive({
    shiny::req(reactive_titanic())
    set.seed(input$seed)
    titanic_split <- rsample::initial_split(
      reactive_titanic(),
      prop = 0.7,
      strata = Survived
    )
    train_data <- rsample::training(titanic_split)
    test_data <- rsample::testing(titanic_split)
    list(train = train_data, test = test_data)
  })

  raw_train <- shiny::reactive({
    train_test_split()$train
  })
  raw_test <- shiny::reactive({
    train_test_split()$test
  })

  prepped_data <- shiny::reactive({
    titanicShinySurvivR:::preprocess_titanic_data(
      train_data = raw_train(),
      test_data = raw_test()
    )
  })

  prepped_train <- shiny::reactive({
    prepped_data()$train
  })
  prepped_test <- shiny::reactive({
    prepped_data()$test
  })
  prepped_recipe <- shiny::reactive({
    prepped_data()$recipe
  })

  LR <- shiny::reactive({
    shiny::req(prepped_train())
    MASS::stepAIC(
      stats::glm(Survived ~ ., data = prepped_train(), family = "binomial"),
      direction = "both",
      trace = FALSE
    )
  })

  dec_tree <- shiny::reactive({
    shiny::req(prepped_train())
    rpart::rpart(
      Survived ~ .,
      data = prepped_train(),
      method = "class",
      control = rpart::rpart.control(cp = 0.001)
    )
  })

  rand_forest <- shiny::reactive({
    shiny::req(prepped_train())
    randomForest::randomForest(
      Survived ~ .,
      data = prepped_train(),
      ntree = 600,
      mtry = sqrt(ncol(prepped_train())) + 2,
      na.action = stats::na.omit
    )
  })

  model_list <- shiny::reactive({
    shiny::req(LR(), dec_tree(), rand_forest())
    list(
      `Logistic Regression` = LR(),
      `Decision Tree` = dec_tree(),
      `Random Forest` = rand_forest()
    )
  })

  conf_mx <- shiny::reactive({
    shiny::req(model_list())
    titanicShinySurvivR:::create_confusion_matrix(
      model_list = model_list(),
      testing_data = prepped_test(),
      class_threshold = input$threshold
    )
  })

  output$confus <- shiny::renderText({
    paste(
      "NOTE:\n",
      "In this tab, the survival outcome is coded as:\n",
      "  1 = SURVIVED\n",
      "  0 = DID NOT SURVIVE\n\n",
      titanicShinySurvivR:::generate_confusion_matrix_summary(conf_mx()),
      collapse = ""
    )
  })

  user_data <- shiny::reactive({
    shiny::req(
      input$pclass,
      input$sex,
      input$age,
      input$sibsp,
      input$parch,
      input$fare
    )

    data.frame(
      Pclass = as.numeric(input$pclass),
      Sex = input$sex,
      Age = input$age,
      SibSp = input$sibsp,
      Parch = input$parch,
      Fare = input$fare,
      Embarked = input$embark,
      Cabin = input$cabin_deck
    )
  })

  prepped_user_data <- shiny::reactive({
    shiny::req(user_data(), prepped_recipe())
    recipes::bake(prepped_recipe(), new_data = user_data())
  })

  output$pred <- shiny::renderText({
    model_obj <- switch(
      input$model,
      "Logistic Regression" = LR(),
      "Decision Tree" = dec_tree(),
      "Random Forest" = rand_forest()
    )
    paste(
      titanicShinySurvivR:::predict_user_outcome(
        model_list = model_list(),
        selected_model = input$model,
        user_data = prepped_user_data(),
        threshold = input$threshold
      ),
      "\n\nThe most important features for the",
      input$model,
      "model are:",
      titanicShinySurvivR:::extract_important_features(model_obj, input$model),
      "\n"
    )
  })

  output$survival_plot <- shiny::renderPlot({
    titanicShinySurvivR:::plot_survival_metric(reactive_titanic(), input$metric)
  })

  output$probability_plot <- shiny::renderPlot({
    titanicShinySurvivR:::plot_predicted_probabilites(
      prepped_test_data = prepped_test(),
      model_list = model_list(),
      chosen_model = input$model,
      class_threshold = input$threshold
    )
  })

  roc_auc_output <- shiny::reactive({
    titanicShinySurvivR:::plot_roc_auc(
      prepped_test(),
      model_list(),
      input$model
    )
  })

  output$roc_auc_graph <- shiny::renderPlot({
    roc_auc_output()$graph
  })

  output$roc_auc_value <- shiny::renderText({
    paste0(
      "AUC: ",
      roc_auc_output()$value,
      "\n\n",
      input$model,
      " ranks positives above negatives ",
      round(roc_auc_output()$value * 100, 2),
      "% of the time."
    )
  })

  output$intro <- renderUI({
    HTML(
      "
<h2>Welcome to Titanic SurvivR!</h2>
<p>Thank you for taking the time to check out my first ever project, <strong>Titanic SurvivR</strong>! This Shiny app is based on the classic Kaggle Titanic competition—with a twist: you get to find out whether <em>you</em> would have survived the sinking.</p>

<h3>🚀 How to Use Titanic SurvivR</h3>
<ol>
  <li>Click the <code>Use Kaggle Data</code> button on the left to load the dataset and train the models.</li>
  <li>Enter your passenger details in the sidebar.</li>
  <li>Select a prediction model.</li>
  <li>Click on the <strong>Prediction</strong> tab to see your results.</li>
</ol>

<p>You can also upload your own dataset if you'd like to experiment.</p>

<h3>📂 What the Tabs Do</h3>
<ul>
  <li><strong>Introduction:</strong> Overview of the app's purpose and how to use it.</li>
  <li><strong>Prediction:</strong> View your survival outcome based on selected input features and see which features matter the most.</li>
  <li><strong>Survival Patterns:</strong> Visualise how specific features relate to survival rates, and view the predicted probability distribution for each model.</li>
  <li><strong>Confusion Matrix:</strong> See how well each model classifies survival outcomes on test data.</li>
  <li><strong>ROC-AUC:</strong> Evaluate model discrimination using ROC curves and AUC values.</li>
  <li><strong>Data Preview:</strong> Examine the raw dataset used for model training and testing.</li>
  <li><strong>Titanic Deck Layout:</strong> Visual reference of the ship’s deck plan used in feature engineering.</li>
</ul>

<h3>💡 Why I Built This</h3>
<p>The goal of this project was to explore the <strong>Shiny framework</strong> and get hands-on with applied <strong>machine learning and statistics</strong> in R. It really has helped me learn a lot in both fields. Looking back to when I first started, if you had told me ROC-AUC was a Star Wars character, I would have believed you.</p>

<p>Thanks again for checking this out!</p>
"
    )
  })
}
