real.estate.data <- read.csv("../real_estate_ready.CSV")
mrt.data <- read.table("../final_dataset/MRT_station_data.csv")
bus.station.data <- read.table("../final_dataset/bus_station_data.csv")
park.data <- read.table("../final_dataset/park.final.csv")
store.data <- read.table("../final_dataset/store_all.csv")
fields <- c("region", "usage", "land", "building", "car_park", "select.function", "low_age", "high_age", "low_area", "high_area", "low_price", "high_price")


outputDir <- "../responses"
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


function(input, output, session) {
  
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
    if (!isTRUE(input$mrt)){
      proxy %>% removeMarker(mrt.data$station_name)
    } else {
      proxy %>% addMarkers(data = cbind(mrt.data$lat, lng = mrt.data$lng), layerId = mrt.data$station_name, popup = mrt.data$station_name)
    }
  }, ignoreNULL = FALSE)
  
  observeEvent(input$park, {
    proxy <- leafletProxy("mymap", session)
    if (!isTRUE(input$park)){
      proxy %>% removeMarker(park.data$Name)
    } else {
      proxy %>% addMarkers(data = cbind(park.data$Longitude, lng = park.data$Latitude), layerId = park.data$Name, popup = park.data$Name)
    }
  }, ignoreNULL = FALSE)
  
  
  observeEvent(input$bus, {
    proxy <- leafletProxy("mymap", session)
    if (!isTRUE(input$bus)){
      proxy %>% removeMarker(bus.station.data$nameZh)
    } else {
      proxy %>% addMarkers(data = cbind(bus.station.data$longitude, lng = bus.station.data$latitude), layerId = bus.station.data$nameZh, popup = bus.station.data$nameZh)
    }
  }, ignoreNULL = FALSE)

  observeEvent(input$store, {
    proxy <- leafletProxy("mymap", session)
    if (!isTRUE(input$store)){
      proxy %>% removeMarker(as.character(store.data$lng))
    } else {
      proxy %>% addMarkers(data = cbind(store.data$lng, lng = store.data$lat), layerId = as.character(store.data$lng))
    }
  }, ignoreNULL = FALSE)
  
}
