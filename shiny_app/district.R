# example points
pointDF <- read.table(textConnection("
pointNum Lat Long
                                      1        25.03 121.53    
                                      2        25.017656 121.536522
                                      3       -90 100"), header = TRUE)

# Taipei geojson
taipei = rgdal::readOGR("taipei.json", encoding = 'utf8')

# config the points for searching
sp::coordinates(pointDF) <- ~Long+Lat
sp::proj4string(pointDF) <- sp::proj4string(taipei)

# find the district over the points
ret = sp::over(pointDF, taipei)
