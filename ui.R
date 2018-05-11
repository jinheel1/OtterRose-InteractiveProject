library(shiny)
library(shinydashboard)
library(ggplot2)
library(tidyverse)
library(plotly)
library(ggmap)

dashboardPage(skin = "black",
              
    dashboardHeader(title = "Otter Rose"),
    
    #---Naming the tabs
    dashboardSidebar(width="200px",
                     sidebarMenu(
                       menuItem("Total Honey Production", tabName = "number1", icon = icon("th")),
                       menuItem("Graph 2", tabName = "number2", icon = icon("th")),
                       menuItem("Graph 3", tabName = "number3", icon = icon("th")),
                       menuItem("Graph 4", tabName = "number4", icon = icon("th")),
                       menuItem("Graph 5", tabName = "number5", icon = icon("th")),
                       menuItem("Graph 6", tabName = "number6", icon = icon("th")),
                       menuItem("Graph 7", tabName = "number7", icon = icon("th")),
                       menuItem("Graph 8", tabName = "number8", icon = icon("th"))
                       )
                     ),
    
    #---UI Content of tabs
    dashboardBody(
      tabItems(
        
        #---UI Content of Graph 1
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
        
        #---UI Content of Graph 2
        tabItem(tabName = "number2",
                fluidRow(
                  box(
                    plotOutput("plotB")
                    )
                  )
                ),
        
        #---UI Content of Graph 3
        tabItem(tabName = "number3",
                fluidRow(
                  box(
                    #---STUFF GOES HERE---
                    plotlyOutput("plotlyC"),
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
        
        #---UI Content of Graph 4
        tabItem(tabName = "number4",
                fluidRow(
                  box(
                    
                    #---STUFF GOES HERE---
                    plotlyOutput("plotlyD", height = 800),
                    radioButtons("variable", "choose var", 
                                 choices = c("totalprod", "priceperlb","numcol","yieldpercol","stocks","priceperlb","prodvalue")),
                    width = 12
                    
                    )
                  )
                ),
        
        #---UI Content of Graph 5
        tabItem(tabName = "number5",
                fluidRow(
                  box(
                    #---STUFF GOES HERE---
                    plotOutput("plotE"),
                    width = 12
                    )
                  )
                ),
        
        #---UI Content of Graph 6
        tabItem(tabName = "number6",
                fluidRow(
                  box(
                    plotlyOutput("plotly6"), width = 12,
                    selectInput(inputId = "state2", label = "state2",
                                choices = c("AL", "AZ", "AR", "CA", "CO", "FL", "GA", "HI", "ID", "IL",
                                            "IN", "IA", "KS", "KY", "LA", "ME", "MD", "MI", "MN", "MS",
                                            "MO", "MT", "NE", "NV", "NJ", "NM", "NY", "NC", "ND", "OH",
                                            "OK", "OR", "PA", "SD", "TN", "TX", "UT", "VT", "VA", "WA",
                                            "WV", "WI", "WY", "SC"),
                                multiple = T, selected = "AL")
                  )
                  )
                ),
        #---UI Content of Graph 6
        tabItem(tabName = "number7",
                fluidRow(
                  box(
                    plotlyOutput("plotly7"), width = 12,
                    selectInput(inputId = "state3", label = "state3",
                                choices = c("AL", "AZ", "AR", "CA", "CO", "FL", "GA", "HI", "ID", "IL",
                                            "IN", "IA", "KS", "KY", "LA", "ME", "MD", "MI", "MN", "MS",
                                            "MO", "MT", "NE", "NV", "NJ", "NM", "NY", "NC", "ND", "OH",
                                            "OK", "OR", "PA", "SD", "TN", "TX", "UT", "VT", "VA", "WA",
                                            "WV", "WI", "WY", "SC"),
                                multiple = T, selected = "AL")
                  )
                )
        ),
        
        #---UI Content of Graph 8
        tabItem(tabName = "number8",
                fluidRow(
                  box(
                    #---STUFF GOES HERE---
                    plotlyOutput("plotly8")
                  )
                )
        )
        )
      )
)

