library(ggplot2)
library(dplyr)
library(ggmap)

##select UFO reports happened inside NA
df <- read.csv("data/UFOCoords.csv")

plot_1 <- function(dataUFO) {
  coordMap <- dataUFO %>% 
            subset(select = c("lat","lng")) %>% 
            filter(lat > 20 & lat <60 & lng > -135 & lng < -60)

  ##get the google map of selected region
  mapgilbert <- get_map(location = c(lng = mean(coordMap$lng), 
               lat = mean(coordMap$lat)), zoom = 3, maptype = "satellite", scale = 2)

  plot <- ggmap(mapgilbert) + geom_point(data = coordMap, aes(x = lng, y = lat, fill = "red", 
                                          alpha = 0.8), size = 1.4, shape = 21) + guides(fill=FALSE, alpha=FALSE, size=FALSE) + 
                                          labs(x = "Longitude", y = "Latitude") + ggtitle("UFO appearances in NA")
  return(plot)
}

# part of the code is from "https://stackoverflow.com/questions/23130604/plot-coordinates-on-map"
