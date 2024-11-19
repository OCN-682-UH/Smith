library(shiny)
library(tidyverse)
library(rsconnect)
library(bslib)

# Loading dataset
Gak_all_moor <- read_csv("Gak1_data_shiny.csv")

# Making list of dates
samp_date <- range(Gak_all_moor$date)

ui <- fluidPage(
   titlePanel("GAK1 Water Temperature (°C) from 2016-2020"), # title for page
   theme = bs_theme(version = 5, bootswatch = "minty"),
  tags$p(style = "text-align: center;", # adding link to data 
         a(href = "http://research.cfos.uaf.edu/gak1/", "Click here for more information on GAK1 Mooring Data")),
  
  sidebarLayout( # selecting sidebar
    sidebarPanel(
      dateRangeInput( 
        inputId = "selected_date_range", # ID name for the input 
        label = "Select Date Range:", # label for widget
        start = min(samp_date), # this chooses the earliest start date 
        end = as.Date(min(samp_date)) + 6, # this is to show one week to display for figure
        min = min(samp_date), # the min date that can be chosen 
        max = max(samp_date), # the max date that can be chosen
        format = "yyyy-mm-dd"# the format of the date
      )
    ),
    
    mainPanel( # creating an output for average temperature 
      h3("Average Temperature"), # header of the output 
      verbatimTextOutput("average_temp"), # output to give average temp
      h3("Average Temperature of Selected Date Range "), # header for this
      plotOutput("temp_plot"), # creating the space for plot 
      
      
    )
  )
)

server <- function(input, output) {
  filtered_data <- reactive({ # my reactive object
    Gak_all_moor %>% # calling in data 
      filter(date >= input$selected_date_range[1] & date <= input$selected_date_range[2]) # how it will select the date 
  })
  
  output$average_temp <- renderText({ # calculation of average temp 
    data <- filtered_data()
    if (nrow(data) > 0) {  # making a function to alert if there is no data on that date 
      avg_temp <- mean(data$temperature_c, na.rm = TRUE) # average temp calc
      paste0("Average water temperature from ",  # what it will output 
             input$selected_date_range[1], " to ", input$selected_date_range[2], # how it brings in selected dates 
             " is ", round(avg_temp, 2), " °C") # adding rounding to average temperature 
    } else {
      "No data available for the selected date range." # what will pop up if no data is on date 
    }
  })
  
  
  output$temp_plot <- renderPlot({ # output for plot 
    data <- filtered_data() # pulls out selected dates
    if (nrow(data) > 0) { # only will show if the date selected has data 
      ggplot(data, aes(x = date_time_utc, y = temperature_c)) + # now starting to build plot 
        geom_line(color = "blue") + # color of line 
        geom_point(color = "red", size = 1) + # color of point 
        scale_x_datetime(date_labels = "%b %d", # how x-axis will show date
                         date_breaks = "1 day") +   # 1-day intervals for ticks 
        labs(title = paste("GAK1 Water Temperature from", # title of figure
                           input$selected_date_range[1], "to", input$selected_date_range[2]), # where it brings in selected dates to plot 
             x = "Date", 
             y = "Temperature (°C)") +
        theme_minimal() + # selecting theme 
        theme(text = element_text(size = 12), # changing font size 
              plot.title = element_text(hjust = 0.5, face = "bold"), # bolding title 
              axis.text.x = element_text(angle = 45, hjust = 1) # adjusting x-axis for readability 
        )
    } else { # what will plot if there is no data for the date 
      ggplot() +
        labs(title = "No data for the selected date range.") + # title 
        theme_void()
    }
  })
} 


shinyApp(ui = ui, server = server)


