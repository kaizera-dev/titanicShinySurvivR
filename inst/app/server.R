server <- function(input, output, session) {

  current_data <- reactiveVal("")

  observeEvent(input$default, {
    current_data("default")
  })

  observeEvent(input$upload, {
    current_data("upload")
  })

  reactive_titanic <- reactive({
    req(current_data())

    if (current_data() == "default") {
      # Check if 'train' is available in the package's data
      available_data <- data(package = "titanicShinySurvivR")$results[, "Item"]
      validate(need("train" %in% available_data, "Example dataset 'train' is not available."))

      # Load it safely into this reactive environment
      data("train", package = "titanicShinySurvivR", envir = environment())
      train

    } else if (current_data() == "upload") {
      req(input$upload)
      readr::read_csv(input$upload$datapath)

    } else {
      NULL
    }
  })




  observeEvent(reactive_titanic(), {

    validation_error <- titanicShinySurvivR::validate_titanic_data(reactive_titanic())

    if (!is.null(validation_error)) {
      showNotification(validation_error, type = "error", duration = NULL)
    }
  })

  output$data_preview <- renderTable({
    head(reactive_titanic(), n = 15)
  })

 # TODO: WRAP UPs
# intructions tab
 # README

  train_test_split <- reactive({

    req(reactive_titanic())

      set.seed(input$seed)
      titanic_split <- rsample::initial_split(reactive_titanic(), prop = 0.7, strata = Survived)
      train_data <- rsample::training(titanic_split)
      test_data <- rsample::testing(titanic_split)

      list(train = train_data, test = test_data)

  })

  raw_train <- reactive({ train_test_split()$train })
  raw_test <- reactive({ train_test_split()$test })

  prepped_data <- reactive({

    preprocess_titanic_data(train_data = raw_train(),
                            test_data = raw_test())

  })

  prepped_train <- reactive({prepped_data()$train})
  prepped_test <- reactive({prepped_data()$test})
  prepped_recipe <- reactive({prepped_data()$recipe})

# Models ----

  LR <- reactive({
    req(prepped_train())

    MASS::stepAIC(glm(Survived ~ .,
                      data = prepped_train(),
                      family = "binomial",
                      na.action = na.exclude),
                  direction = "both",
                  trace = FALSE)
  })

  dec_tree <- reactive({
    req(prepped_train())

    rpart::rpart(Survived ~ .,
                 data = prepped_train(),
                 method = "class",
                 control = rpart::rpart.control(cp = 0))
  })

  rand_Forest <- reactive({
    req(prepped_train())

    randomForest::randomForest(
      Survived ~ .,
      data = prepped_train(),
      ntree = 500,
      mtry = sqrt(ncol(prepped_train()))
    )
  })

  model_list <- reactive({
    req(LR(), dec_tree())
    list(
      `Logistic Regression` = LR(),
      `Decision Tree` = dec_tree(),
      `Random Forest` = rand_Forest()
    )
  })
  # ----

  conf_mx <- reactive({
    req(model_list())

    titanicShinySurvivR::create_confusion_matrix(model_list = model_list(),
                            testing_data = prepped_test(),
                            class_threshold = input$threshold)

  })

  output$confus <- renderTable({

    titanicShinySurvivR::generate_confusion_matrix_summary(conf_mx())
  })

  user_data <- reactive({
    req(input$pclass, input$sex, input$age, input$sibsp, input$parch, input$fare)

    df <- data.frame(
      Pclass = as.numeric(input$pclass),
      Sex    = input$sex,
      Age    = input$age,
      SibSp  = input$sibsp,
      Parch  = input$parch,
      Fare   = input$fare,
      Embarked = input$embark,
      Cabin = input$cabin_deck
    )

    df
  })

  prepped_user_data <- reactive({
    req(user_data(), prepped_recipe())

    recipes::bake(prepped_recipe(), new_data = user_data())
  })

  output$pred <- renderText({

    titanicShinySurvivR::predict_user_outcome(model_list = model_list(),
                         selected_model = input$model,
                         user_data = prepped_user_data(),
                         threshold = input$threshold)
  })

  output$insights <- renderText({

    titanicShinySurvivR::format_model_insights(conf_mx())
  })

  output$survival_plot <- renderPlot({
    titanicShinySurvivR::plot_survival_metric(reactive_titanic(), input$metric)
  })

  output$auc_roc <- renderPlot({
    titanicShinySurvivR::plot_roc_auc(prepped_test(),
                                      model_list(),
                                      input$model)
  })

  output$intro <- renderUI({
    HTML("
    <h2>To The Testers...</h2>
    <p>Thank you for taking the time to test my app. There is no need to spend all day looking for bugs, I do appreciate you all have lives outside the scope of my hoop dreams.</p>
    <p> I should have sent you all a list of 5 questions to answer when testing this app, plus a question about how you would like to be referred to in the thank you note I will leave in the intro tab of this app (the tab you are on currently).</p>
    <h3>Welcome to Titanic SurvivR!</h3>
    <p>Thank you for taking the time to check out my first-ever project, <strong>Titanic SurvivR</strong>! This Shiny app is based on the classic Kaggle Titanic competition—with a twist: you get to find out whether <em>you</em> would have survived the sinking.</p>

    <h4>🚀 How to Use Titanic SurvivR</h4>
    <ol>
      <li>Click the <code>Use Example Data</code> button on the left to load the dataset and train the models.</li>
      <li>Enter your passenger details in the sidebar.</li>
      <li>Select a prediction model.</li>
      <li>Click on the <strong>Prediction</strong> tab to see your results.</li>
    </ol>

    <p>You can also upload your own dataset if you'd like to experiment.</p>

    <h4>📂 What the Tabs Do</h4>
<ul>
  <li><strong>Data Preview:</strong> See the raw dataset used to train and test the model.</li>
  <li><strong>Prediction:</strong> View your survival outcome based on the inputs you selected.</li>
  <li><strong>Data Visualisation:</strong> Explore how different features relate to survival.</li>
  <li><strong>Confusion Matrix:</strong> Check how well each model performs on test data.</li>
  <li><strong>Model Insights:</strong> Visual tools like ROC-AUC to better understand model behavior.</li>
</ul>
    <h4>💡 Why I Built This</h4>
    <p>The goal of this project was to explore the <strong>Shiny framework</strong> and get hands-on with applied <strong>machine learning and statistics</strong> in R. It really has helped me learn a lot in both fields. Looking back to when I first started, if you had told me ROC-AUC was a Star Wars character, I would have believed you.</p>

    <p>Thanks again for checking this out!</p>
  ")
  })


}
