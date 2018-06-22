library(shiny)
library(magrittr)
library(tidyverse)

shinyServer(function(input, output){
  
  data <- reactive({
    inFile <- input$dataset
    if (is.null(inFile))
      return(NULL)
    read_csv(inFile$datapath)
  })
  
  output$summary <- renderPrint({
    dataset <<- data()
    summary(dataset)
  })
  
  output$view <- renderTable({
    head(data(), n = input$obs)
  })
  
  output$X <- renderUI(selectInput(
    "features","Choose your X",colnames(data())
  ))
  
  output$Y <- renderUI(selectInput(
    "train","Choose your Y",colnames(data())
  ))

  
  model <- eventReactive(input$submit,{
    column_X <<- input$features
    column_Y <<- input$train
    
    lm(dataset[[column_Y]] ~ dataset[[column_X]])
  })
  
  output$model <- renderPrint(summary(model()))
  
  plot <- eventReactive(input$submit,{
    ggplot(mapping = aes(dataset[[column_X]], dataset[[column_Y]])) +
      geom_point(alpha = .5) + geom_smooth(method = lm, se = F, color = "#777777") +
      xlab(column_X) + ylab(column_Y)
  })
  
  output$plot <- renderPlot(plot())
  
})




