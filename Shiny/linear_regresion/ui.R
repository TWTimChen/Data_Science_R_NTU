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
          h2("選擇參數"),
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
    ),
    tabPanel(
      "t-test",
      sidebarLayout(
        sidebarPanel(
          h2("選擇參數"),
          uiOutput("X.t"),
          uiOutput("Y.t"),
          selectInput("alternative", "檢定方式", list("雙尾"="two.sided", "左尾"="less", "右尾"="greater")),
          # selectInput("paired", "配對樣本", list(TRUE, FALSE)),
          numericInput("mu", "μ", 0),
          numericInput("conf.level", "信賴區間", 0.95),
          actionButton("submit.t","test")
        ),
        mainPanel(
          h3("Plot"),
          wellPanel(plotOutput("plot.t")),
          h3("t-test"),
          verbatimTextOutput("model.t")
        )
      )
    )
  )
))
