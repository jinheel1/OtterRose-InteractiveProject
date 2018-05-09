library(shiny)
library(shinydashboard)
library(ggplot2)
library(tidyverse)
library(plotly)

dashboardPage(skin = "black",
              
    dashboardHeader(title="BLAH"),
    
    dashboardSidebar(width="200px",
                     sidebarMenu(
                       menuItem("BLAH", tabName = "number1", icon = icon("th")),
                       menuItem("BLAH2", tabName = "number2", icon = icon("th"))
                       )
                     ),
    
    dashboardBody(
      tabItems(
        tabItem(tabName = "number1",
                fluidRow(
                  box(
                    plotlyOutput("plotlyA1"), width = 12,
                    selectInput(inputId = "state", label = "State",
                               choices = c("AL", "AZ", "AR", "CA", "CO", "FL", "GA", "HI", "ID", "IL",
                                           "IN", "IA", "KS", "KY", "LA", "ME", "MD", "MI", "MN", "MS",
                                           "MO", "MT", "NE", "NV", "NJ", "NM", "NY", "NC", "ND", "OH",
                                           "OK", "OR", "PA", "SD", "TN", "TX", "UT", "VT", "VA", "WA",
                                           "WV", "WI", "WY", "SC"),
                               multiple = T, selected = "AL")
                 )
               )
            ),
        
        tabItem(tabName = "number2",
                fluidRow(
                  box(
                    plotOutput("plotB")
                  )
                )
              )
      ))
)

