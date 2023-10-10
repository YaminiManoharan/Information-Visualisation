# Load necessary libraries
library(shiny)#Core library for building Shiny apps
library(shinydashboard)#Provides functions to build dashboards in Shiny
library(plotly)#Used for creating interactive plots
library(ggplot2)#A data visualization package
library(DT)#Enables rendering of data tables

# Load dataset
data <- read.csv("Cancer Deaths by Country and Type Dataset.csv")

# Define UI for the dashboard
#Initialize the dashboard
ui <- dashboardPage(
  skin = "blue",
  dashboardHeader(title = "Cancer Deaths by Country and type of cancer between year 1990-2016 Dashboard", titleWidth = 800),
  #Initialize dashboard sidebar
  dashboardSidebar(width = 300,
                   selectInput("country", "Select Country:", unique(data$Country)),
                   selectInput("cancerType", "Select Cancer Type:", gsub("\\.", " ", colnames(data)[4:30])),
                   sliderInput("yearRange", "Select Year Range:",
                               min = round(min(data$Year)), # Rounded to integer
                               max = round(max(data$Year)), # Rounded to integer
                               value = c(round(min(data$Year)), round(max(data$Year))),
                               sep = "")
  ),
  #Initialize body of the dashboard
  dashboardBody(
    tags$head(tags$style(HTML("
            .skin-blue .main-header .navbar .nav>li>a, .skin-blue .main-header .navbar .nav>li>a:hover {
                color: #FF4500; /* This will change the title color to OrangeRed */
            }
        "))),
    fluidRow(
      box(title = "Cancer Deaths by Year", status = "primary", solidHeader = TRUE, width = 6,
          plotlyOutput("linePlot", height = 400)#Render line plot
      ),
      box(title = "Cancer Deaths Bar Graph", status = "primary", solidHeader = TRUE, width = 6,
          plotlyOutput("barPlot", height = 400)#Render bar plot
      ),
      box(title = "Cancer death data table", status = "primary", solidHeader = TRUE, width = 12,
          DTOutput("dataTable")#Render data table
      ),
      box(title = "Total number of deaths", status = "primary", solidHeader = TRUE, width = 12,
          valueBoxOutput("scoreCard")#create score card
      )
    )
  )
)

# Define server logic
server <- function(input, output) {
  output$linePlot <- renderPlotly({
    #The data for each output (plot or table) is first filtered depending on the user's inputs (country, cancer type, and year range).
    filteredData <- data[data$Country == input$country &
                           data$Year >= input$yearRange[1] &
                           data$Year <= input$yearRange[2], ]
    #The input$ refers to the settings that the user has chosen from the UI, allowing the dashboard to be dynamic and responsive to user inputs.
    p <- ggplot(filteredData, aes(x = Year, y = filteredData[[gsub(" ", "\\.", input$cancerType)]])) +
      geom_point(aes(text = paste("Year:", Year, "<br>Deaths:", filteredData[[gsub(" ", "\\.", input$cancerType)]]))) +
      geom_line(color = "blue") +
      labs(title = paste("Deaths due to", input$cancerType, "in", input$country),
           y = "Number of Deaths", x = "Year") +
      theme_minimal()
    ggplotly(p, tooltip = "text")
  })
  #outputs that are displayed in the dashboard
  output$barPlot <- renderPlotly({
    filteredData <- data[data$Country == input$country &
                           data$Year >= input$yearRange[1] &
                           data$Year <= input$yearRange[2], ]
    p <- ggplot(filteredData, aes(x = Year, y = filteredData[[gsub(" ", "\\.", input$cancerType)]], text = filteredData[[gsub(" ", "\\.", input$cancerType)]])) +
      geom_bar(stat = "identity", fill = "blue", aes(text = paste("Year:", Year, "<br>Deaths:", filteredData[[gsub(" ", "\\.", input$cancerType)]]))) +
      labs(title = paste("Deaths due to", input$cancerType, "in", input$country),
           y = "Number of Deaths", x = "Year") +
      theme_minimal() +
      coord_flip()
    ggplotly(p, tooltip = "text")
  })
  
  output$dataTable <- renderDT({
    filteredData <- data[data$Country == input$country &
                           data$Year >= input$yearRange[1] &
                           data$Year <= input$yearRange[2], ]
    datatable(filteredData, options = list(scrollX = TRUE, autoWidth = TRUE))
  })
  
  output$scoreCard <- renderValueBox({
    filteredData <- data[data$Country == input$country &
                           data$Year >= input$yearRange[1] &
                           data$Year <= input$yearRange[2], ]
    totalDeaths <- sum(filteredData[[gsub(" ", "\\.", input$cancerType)]], na.rm = TRUE)
    valueBox(
      format(totalDeaths, big.mark = ','),
      subtitle = paste("Total Deaths due to", input$cancerType, "in", input$country),
      icon = icon("heart"),
      color = "blue"
    )
  })
}

# Run Shiny app
shinyApp(ui, server)
