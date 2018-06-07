library(magrittr)
library(tidyverse)

real.estate.data = read_csv("real_estate_ready.CSV")
real.estate.data$is.land = real.estate.data$n_land > 0
real.estate.data$is.building = real.estate.data$n_build > 0
real.estate.data$is.park = real.estate.data$n_park > 0

write_csv(real.estate.data,"../real_estate_ready.CSV")
real.estate.data %>% View
