library(ggplot2)
library(dplyr)

df <- read.csv("data/UFOCoords.csv") 

plot_2 <- function(dataUFO) {
  # Filter out United States from data
  dataUSA <- df %>% filter(Country=="USA")
  
  #Plot bar graph
  plot <- ggplot(data = dataUSA) +
    geom_bar(mapping = aes(x=Shape)) + coord_flip() +
    ggtitle("UFO Shapes Spotted in the US")
  return(plot)
}