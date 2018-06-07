library(shiny)
library(leaflet)
r_colors <- rgb(t(col2rgb(colors()) / 255))
names(r_colors) <- colors()

# variable
taipei.region <- list("中正區" = 12, "大同區" = 3, "中山區" = 11, "松山區" = 7, "大安區" = 2, "萬華區" = 8,
                      "信義區" = 10, "士林區" = 6, "北投區" = 1, "內湖區" = 5, "南港區" = 4, "文山區" = 9)
taipei.house.feature <- list("辦公商業大樓" = 1,"廠辦" = 2,"店面(店鋪)" = 3,"工廠" = 4,"公寓(5樓含以下無電梯)" = 5,
                             "華廈(10層含以下有電梯)" = 6,"其他" = 7,"套房(1房1廳1衛)" = 7,"透天厝" = 9,"住宅大樓(11層含以上有電梯)" = 10) 
taipei.house.usage <- list("住" = 1,"商" = 2,"工" = 3,"住商" = 4,"住工" = 5)

fields <- c("region", "usage", "land", "building", "car_park", "select.function", "low_age", "high_age", "low_area", "high_area", "low_price", "high_price")


fluidPage(
  # start UI
  titlePanel("房價查詢、預估平台"),
  navbarPage("功能",
             tabPanel("歷史租屋價查詢",
                      sidebarLayout(
                        # Sidebar panel for inputs ----
                        sidebarPanel(
                          selectInput("region",
                                      h3("選擇地區:"),
                                      choices = taipei.region),
                          selectInput("usage",
                                      h3("租屋用途:"),
                                      choices = taipei.house.usage),
                          h3("房子特徵:"),
                          fluidRow(
                            column(6, align="center", radioButtons("land", h4("土地"),
                                                                   choices = list("是" = T, "否" = F),
                                                                   selected = F)),
                            column(6, align="center",  radioButtons("building", h4("建物"),
                                                                    choices = list("是" = T, "否" = F),
                                                                    selected = T)),
                            column(6, align="center",radioButtons("car_park", h4("車位"),
                                                                  choices = list("是" = T, "否" = F),
                                                                  selected = F)),
                            column(6, align="center", selectInput("select.function", h4("型態"),
                                                                  choices = taipei.house.feature))
                          ),
                          
                          h3("屋齡:"),
                          fluidRow(
                            column(6, numericInput("low_age", h4("最低:"), value = 0)),
                            column(6, numericInput("high_age", h4("最高:"), value = 100))
                          ),
                          
                          h3("面積(平方公尺):"),
                          fluidRow(
                            column(6, numericInput("low_area", h4("最低:"), value = 1)),
                            column(6, numericInput("high_area", h4("最高:"), value = 100))
                          ),
                          
                          h3("租金範圍(萬):"),
                          fluidRow(
                            column(6, numericInput("low_price", h4("最低:"), value = 1)),
                            column(6, numericInput("high_price", h4("最高:"), value = 100000))
                          ),
                          
                          fluidRow(
                            column(11, align="center", actionButton("submit", "確認"))
                          )
                          #selectInput("select.age",
                          #            h3("屋齡:"),
                          #            choices = taipei.house.age),
                          # Input: Numeric entry for number of obs to view ----
                        ),
                        
                        # Main panel for displaying outputs ----
                        mainPanel(
                          
                          # Output: Verbatim text for data summary ----
                          
                          #verbatimTextOutput("summary"),
                          
                          # Output: HTML table with requested number of observations ----
                          #tableOutput("view"),
                          column(3, 
                                 checkboxInput("mrt", "捷運站", value = FALSE)
                          ),
                          column(3, 
                                 checkboxInput("bus", "公車站", value = FALSE)
                          ),
                          column(3, 
                                 checkboxInput("store", "便利商店", value = FALSE)
                          ),
                          column(3, 
                                 checkboxInput("park", "公園", value = FALSE)
                          ),
                          #textOutput("select.region_output"),
                          #verbatimTextOutput("summary"),
                          leafletOutput("mymap", width = "100%", height = 450),
                          p(),
                          
                          DT::dataTableOutput("responses", width = 300), tags$hr()
                        )
                      )
             ),
             tabPanel("預測租屋價查詢",
                      verbatimTextOutput("summary")
             ),
             navbarMenu("More",
                        tabPanel("Table",
                                 DT::dataTableOutput("table")
                        )
             )
  )
)