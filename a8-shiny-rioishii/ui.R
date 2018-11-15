library(shiny)

ui <- fluidPage(   
  titlePanel("Cereal Data"),  
  
  sidebarLayout(   
    sidebarPanel(  
      selectInput('var', label = "Select Manufacturer:", 
                   choices = list("American Home Food Products" = 'A',
                                  "General Mills" = 'G',
                                  "Kelloggs" = 'K',
                                  "Nabisco" = 'N',
                                  "Quaker Oats" = 'Q',
                                  "Ralston Purina" = 'R')),
      sliderInput("rating", "Filter Ratings:", min = 0, max = 100,
                  value = c(0, 100)),
      radioButtons('type', label = "Hot or Cold?",
                   choices = list("Cold" = "C", "Hot" = 'H'))
      
    ),
    mainPanel(     
      plotOutput('graph')
    )
  )
)

shinyUI(ui)

