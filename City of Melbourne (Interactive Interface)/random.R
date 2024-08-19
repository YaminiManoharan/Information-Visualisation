##########################
###### Assignment 3 ######
######## Group 84 ########
##########################

##########################
######## LIBRARIES #######
##########################
library(shiny)
library(bslib)
library(bsicons)

## This is where you could set you working directory
setwd("C:\\Users\\yamin\\Desktop\\IV")
##

####################
######## UI ######## 
####################

## The page contains only html 
ui = page_fluid(
  includeHTML("./randomEvent.html")
)

########################
######## Server ######## 
########################

server = function(input, output, session) {
  output$randomEvent <- renderUI({
    includeHTML("randomEvent.html")
  })
}

######## Run App ######## 
shinyApp(ui, server, options=list(port=6248))

