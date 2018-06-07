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


fluidPage(
  # start UI
  titlePanel("房價查詢、預估平台"),
  navbarPage("功能",
             tabPanel("歷史租屋價查詢",
                      sidebarLayout(
                        # Sidebar panel for inputs ----
                        sidebarPanel(
                          selectInput("select.region",
                                      h3("選擇地區:"),
                                      choices = taipei.region),
                          selectInput("select.usage",
                                      h3("租屋用途:"),
                                      choices = taipei.house.usage),
                          h3("房子特徵:"),
                          fluidRow(
                            column(6, align="center", radioButtons("radio.land", h4("土地"),
                                                                   choices = list("是" = T, "否" = F),
                                                                   selected = 1)),
                            column(6, align="center",  radioButtons("radio.building", h4("建物"),
                                                                    choices = list("是" = T, "否" = F),
                                                                    selected = 1)),
                            column(6, align="center",radioButtons("radio.car.park", h4("車位"),
                                                                  choices = list("是" = T, "否" = F),
                                                                  selected = 1)),
                            column(6, align="center", selectInput("select.function", h4("型態"),
                                                                  choices = taipei.house.feature))
                          ),
                          
                          sliderInput("slide.age", h3("屋齡:"),  
                                      min = 0, max = 120, value = c(0, 80)),
                          
                          sliderInput("slide.area.size", h3("面積(平方公尺):"),  
                                      min = 0, max = 100, value = c(0, 80)),
                          
                          h3("租金範圍:"),
                          fluidRow(
                            column(6, numericInput("slide.low.price", h4("最低:"), value = 1)),
                            column(6, numericInput("slide.high.price", h4("最高:"), value = 100000))
                          ),
                          
                          fluidRow(
                            column(11, align="center", actionButton("recalc", "確認"))
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
                          checkboxGroupInput("checkGroup.facility", h4("附近設施"),
                                             choices = list("捷運站" = 1, 
                                                            "公車站" = 2, 
                                                            "便利商店" = 3,
                                                            "公園" = 4),
                                             selected = 1,
                                             inlin = TRUE),
                          #textOutput("select.region_output"),
                          #verbatimTextOutput("summary"),
                          leafletOutput("mymap", width = "100%", height = 450),
                          p(),
                          actionButton("recalc", "New points")
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
