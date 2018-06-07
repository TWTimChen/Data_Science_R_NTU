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


ui <- fluidPage(
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

real.estate.data <- read.csv("real_estate_ready.CSV")
mrt.data <- read.table("final_dataset/MRT_station_data.csv")
bus.station.data <- read.table("final_dataset/bus_station_data.csv")
park.data <- read.table("final_dataset/park.final.csv")
store.data <- read.table("final_dataset/store_all.csv")

map <- leaflet() %>%
  addProviderTiles(providers$Stamen.TonerLite,
                   options = providerTileOptions(noWrap = TRUE)) %>% 
  addMarkers(lat = mrt.data$lat, lng = mrt.data$lng, popup = mrt.data$station_name)


server <- function(input, output, session) {
  
  # Return the requested dataset ----
  # By declaring datasetInput as a reactive expression we ensure
  # that:
  #
  # 1. It is only called when the inputs it depends on changes
  # 2. The computation and result are shared by all the callers,
  #    i.e. it only executes a single time
  #convenient.store <- read.csv("")
  
  # Whenever a field is filled, aggregate all form data
  fromData <- reactive({
    data <- sapply(fields, function(x) input[[x]])
    data
  })
  
  # When the Submit button is clicked, save the form data
  observeEvent(input$submit, {
    saveData(fromData())
  })
  
  # show the previous response
  output$responses <- DT::renderDataTable({
    input$submit
    loadData()
  })

  #output$select.region_output <- renderPrint({a()})
  
  #b <- input$select.usage 
  #c <- input$radio.land
  #d <- input$radio.building
  #e <- input$radio.car.park
  #f <- input$select.function
  #g <- input$slide.age
  #h <- input$slide.area.size
  #i <- input$slide.low.price
  #j <- input$slide.high.price
  #k <- input$checkGroup.facility
  #l<- input$checkGroup.facility
  
#  filteredData <- reactive({
#    real.estate.data
    
#    real.estate.data$is.land == input$land
#    real.estate.data$is.building = real.estate.data$n_build > 0
#    real.estate.data$is.park = real.estate.data$n_park > 0
#  })
  
  select.data <- eventReactive(input$submit,
                               {real.estate.data %>% filter(district_id == input$region,
                                                            use == input$usage,
                                                            is.land == input$land,
                                                            is.building == input$building,
                                                            is.park == input$car_park,
                                                            build_state == input$select.function,
                                                            house_age %in% input$low_age:input$high_age,
                                                            total_size >= input$low_area & total_size <= input$high_area,
                                                            PRICE >= input$low_price & PRICE <= input$high_price) %>% 
                                   select(lat,lng)
                               })
  
  
  output$mymap <- renderLeaflet({
    leaflet() %>%
      addProviderTiles(providers$Stamen.TonerLite,
                       options = providerTileOptions(noWrap = TRUE)) %>%
      addMarkers(data = select.data())
    }
  )
  
  observeEvent(input$mrt, {
    proxy <- leafletProxy("mymap", session)
    #proxy %>% addMarkers(lat = mrt.data$lat, lng = mrt.data$lng, popup = mrt.data$station_name)
    if (!isTRUE(input$mrt)){
    # proxy %>% addMarkers(lat = mrt.data$lat, lng = mrt.data$lng, popup = mrt.data$station_name)
      #proxy %>% removeMarker()
    } else {
      proxy %>% addMarkers(data = cbind(mrt.data$lat, lng = mrt.data$lng), popup = mrt.data$station_name)
      #proxy %>% removeMarker()
    #  #mrt.points <- cbind(mrt.data$lat, mrt.data$lng)
    #  proxy %>% addMarkers(lat = mrt.data$lat, lng = mrt.data$lng, popup = mrt.data$station_name)
    }
  }, ignoreNULL = FALSE)
}


outputDir <- "responses"
saveData <- function(data) {
  data <- as.data.frame(t(data))
  if (exists("responses")) {
    responses <<- rbind(responses, data)
    # Create a unique file name
    fileName <- "user_inputs.csv"
    write.csv(
      x = responses,
      file = file.path(outputDir, fileName), 
      row.names = FALSE, quote = TRUE
    )
  } else {
    responses <<- data
    fileName <- "user_inputs.csv"
    write.csv(
      x = responses,
      file = file.path(outputDir, fileName), 
      row.names = FALSE, quote = TRUE
    )
  }
}

loadData <- function() {
  if (exists("responses")) {
    responses
  }
}

shinyApp(ui, server)