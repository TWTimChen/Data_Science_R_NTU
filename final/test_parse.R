library(tidyverse)
library(magrittr)

data <- readLines("download/A_lvr_land_A.csv", encoding="big5") %>% 
  iconv("big5", "utf8") %>% map(function(i) {strsplit(i,",")})
data %<>% do.call(rbind,.) %>% do.call(rbind,.) %>% data.frame(stringsAsFactors=FALSE)
colnames(data) <- data[1,]   
data = data[-c(1:2),]
data %>% View



