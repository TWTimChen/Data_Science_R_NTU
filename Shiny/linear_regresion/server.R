library(shiny)
library(magrittr)
library(tidyverse)

shinyServer(function(input, output){
  
  ######################################
  ############# Overview ###############
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
  
  ######################################
  ########## Linear Regresion ##########
  
  output$X <- renderUI(selectInput(
    "features","Choose your X",colnames(data())
  ))
  
  output$Y <- renderUI(selectInput(
    "train","Choose your Y",colnames(data())
  ))

  
  model <- eventReactive(input$submit,{
    X <<- dataset[[input$features]]
    Y <<- dataset[[input$train]]
    
    lm(X ~ Y)
  })
  
  output$model <- renderPrint(summary(model()))
  
  plot <- eventReactive(input$submit,{
    ggplot(mapping = aes(X, Y)) +
      geom_point(alpha = .5) + geom_smooth(method = lm, se = F, color = "#777777")
  })
  
  output$plot <- renderPlot(plot())
  
  ######################################
  ############## t-test ################
  output$X.t <- renderUI(selectInput(
    "A","X",colnames(data())
  ))
  
  output$Y.t <- renderUI(selectInput(
    "B","Y",colnames(data())
  ))
    
  t_out <- eventReactive(input$submit.t,{
    X <<- dataset[[input$A]]
    Y <<- dataset[[input$B]]
    X.t <<- cbind(data = X, treatmeant = "X")
    Y.t <<- cbind(data = Y, treatmeant = "Y")
    var.equal <- var.test(X, Y)$p.value > 0.05
    
    t.test(X, Y, 
           alternative = input$alternative,
           var.equal = var.equal,
           conf.level = input$conf.level)
  })
  
  output$model.t <- renderPrint(t_out())
  
  plot.t <- eventReactive(input$submit.t,{
    rbind.data.frame(X.t, Y.t, stringsAsFactors = F) %>% 
      ggplot(mapping = aes(as.numeric(data), fill = treatmeant)) +
      geom_density(alpha=.4,color = "#777777") + xlab("data")
  })

  output$plot.t <- renderPlot(plot.t())
})




