library(shiny)
library(dplyr)
library(ggplot2)

cereal <- read.table(file = 'data/cereal.tsv', header = TRUE)

server <- function(input, output) {
  output$graph <- renderPlot({
    filtered <- cereal %>% filter(rating >= input$rating[1],
                                  rating <= input$rating[2],
                                  mfr == input$var,
                                  type == input$type)
    
    ggplot(filtered, aes(x=name, y=rating, fill=name)) +
      geom_bar(stat = "identity") + 
      guides(fill=FALSE) + 
      ggtitle("Ratings of Cereals") +
      theme(axis.text.x = element_text(angle = 90, hjust = 1)) 
    # Code from https://stackoverflow.com/questions/1330989/rotating-and-spacing-axis-labels-in-ggplot2
  })
}

shinyServer(server)

