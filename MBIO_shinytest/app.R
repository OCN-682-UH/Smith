


library(shiny)
library(tidyverse)
library(rsconnect)

ui<-fluidPage(
  sliderInput(inputId = "num", # ID name for the input
              label = "Choose a number", # Label above the input
              value = 25, min = 1, max = 100 # values for the slider
  ),
  textInput(inputId = "title", # ID name for the input
            label= "Write a title",
            value= "Histogram of Random Normal Values"),# starting title
  plotOutput("hist"), # creates space for a plot called hits
  verbatimTextOutput("stats") # create a space for stats
)
server<-function(input,output){
  data<-reactive ({
    tibble(x = rnorm(input$num))
    })# 100 random normal points
  
  output$hist <- renderPlot({
      ggplot(data(), aes(x = x))+ # make a histogram
      geom_histogram()+
      labs(title = input$title) # Add a new title
  })
  output$stats<- renderPrint({ # create whole new function for the stats part
    summary(data()) #calculate summary stats based on numbers
  })
}
shinyApp(ui = ui, server = server) # run this frequently to check that it is working 


