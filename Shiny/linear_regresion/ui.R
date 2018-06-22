library(shiny)

shinyUI(fluidPage(
  tabsetPanel(
    tabPanel(
      "Overview",
      fluidRow(
        column(
          h3("Dataset"),
          fileInput("dataset","Choose your data!"), 
          numericInput(inputId = "obs",
                       label = "Number of observations to view:",
                       value = 5),
          width = 4
        ),
        column(
          h3("Table"),
          tableOutput("view"), 
          width = 8
        )
      ),
      fluidRow(
        column(
          h3("Summary"),
          verbatimTextOutput("summary"),
          width = 12
        )
      )
    ),
    tabPanel(
      "Linear Regression",
      # wellPanel(fluidRow(column(5, uiOutput("X")),
      #          column(5, uiOutput("Y")),
      #          column(2, actionButton("submit","Fit")))),
      # splitLayout(verbatimTextOutput("model"),
      #             wellPanel(plotOutput("plot")))
      sidebarLayout(
        sidebarPanel(
          uiOutput("X"),
          uiOutput("Y"),
          actionButton("submit","Fit")
        ),
        mainPanel(
          h3("Plot"),
          wellPanel(plotOutput("plot")),
          h3("Summary"),
          verbatimTextOutput("model")
        )
      )
    )
  )
))
