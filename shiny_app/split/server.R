library(magrittr)
library(tidyverse)

function(input, output, session) {
  
  # Return the requested dataset ----
  # By declaring datasetInput as a reactive expression we ensure
  # that:
  #
  # 1. It is only called when the inputs it depends on changes
  # 2. The computation and result are shared by all the callers,
  #    i.e. it only executes a single time
  real.estate.data <- read.csv("../real_estate_ready.CSV")
  
  select.data <- eventReactive(input$recalc,
                               {real.estate.data %>% filter(district_id == input$select.region,
                                                            use == input$select.usage,
                                                            is.land == input$radio.land,
                                                            is.building == input$radio.building,
                                                            is.park == input$radio.car.park,
                                                            build_state == input$select.function,
                                                            house_age %in% input$slide.age[1]:input$slide.age[2],
                                                            total_size >= input$slide.area.size[1] & total_size <= input$slide.area.size[2],
                                                            PRICE >= input$slide.low.price & PRICE <= input$slide.high.price)
  })
  
  output$summary <- renderPrint({
    data = select.data()
    nrow(data)
  })
  
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

  

  
  points <- eventReactive(input$recalc, {
    cbind(rnorm(10) * 12 + 5, rnorm(10) * 2+ 5)
  }, ignoreNULL = FALSE)
  
  output$mymap <- renderLeaflet({
    leaflet() %>%
      addProviderTiles(providers$Stamen.TonerLite,
                       options = providerTileOptions(noWrap = TRUE)
      ) %>%
      addMarkers(data = points())
  })
  
}