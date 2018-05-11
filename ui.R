library(shiny)
library(shinydashboard)
library(ggplot2)
library(tidyverse)
library(plotly)
library(shinythemes)
library(ggmap)


dashboardPage(skin = "yellow",
              
    dashboardHeader(title = "Otter Rose"),
    
    #---Naming the tabs
    dashboardSidebar(width="200px",
                     sidebarMenu(
                       menuItem("Introduction", tabName = "intro", icon = icon("th")),
                       menuItem("Total Honey Production", tabName = "number1", icon = icon("th")),
                       menuItem("Graph 2", tabName = "number2", icon = icon("th")),
                       menuItem("Graph 3", tabName = "number3", icon = icon("th")),
                       menuItem("Graph 4", tabName = "number4", icon = icon("th")),
                       menuItem("Graph 5", tabName = "number5", icon = icon("th")),
                       menuItem("Graph 6", tabName = "number6", icon = icon("th"))
                       )
                     ),
    
    #---UI Content of tabs
    dashboardBody(
      tabItems(
        
        tabItem(tabName = "intro",
                fluidRow(
                  box(
                    background = "purple"
                    )
                  )
                ),
        
        #---UI Content of Graph 1
        tabItem(tabName = "number1",
                fluidRow(
                  box(
                    background = "purple",
                    plotlyOutput("plotly1"), width = 12,
                    selectInput(inputId = "state", label = "Click & Choose States to Compare...",
                                choices = c("AL", "AZ", "AR", "CA", "CO", "FL", "GA", "HI", "ID", "IL",
                                           "IN", "IA", "KS", "KY", "LA", "ME", "MD", "MI", "MN", "MS",
                                           "MO", "MT", "NE", "NV", "NJ", "NM", "NY", "NC", "ND", "OH",
                                           "OK", "OR", "PA", "SD", "TN", "TX", "UT", "VT", "VA", "WA",
                                           "WV", "WI", "WY", "SC"),
                                multiple = T, selected = c("AL","AZ"))
                    )
                  )
                ),
        
        #---UI Content of Graph 2
        tabItem(tabName = "number2",
                fluidRow(
                  box(
                    background = "purple",
                    plotlyOutput("plotly2"), width = 12,
                    selectInput(inputId = "state2", label = "Click & Choose States to Compare...",
                                choices = c("AL", "AZ", "AR", "CA", "CO", "FL", "GA", "HI", "ID", "IL",
                                            "IN", "IA", "KS", "KY", "LA", "ME", "MD", "MI", "MN", "MS",
                                            "MO", "MT", "NE", "NV", "NJ", "NM", "NY", "NC", "ND", "OH",
                                            "OK", "OR", "PA", "SD", "TN", "TX", "UT", "VT", "VA", "WA",
                                            "WV", "WI", "WY", "SC"),
                                multiple = T, selected = c("AL","AZ")),
                    selectInput(inputId = "year2", label = "Choose a Year...",
                                choices = c("1998", "1999", "2000", "2001", "2002", "2003", "2004",
                                            "2005", "2006", "2007", "2008", "2009", "2010", "2011", "2012"),
                                selected = "2008")
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
                    plotOutput("plotD", height = 800),
                    width = 12
                    
                    )
                  )
                ),
        
        #---UI Content of Graph 5
        tabItem(tabName = "number5",
                fluidRow(
                  box(
                    #---STUFF GOES HERE---
                    plotOutput("plotE", height = 800),
                    width = 12
                    )
                  )
                ),
        
        #---UI Content of Graph 6
        tabItem(tabName = "number6",
                fluidRow(
                  box(
                    #---STUFF GOES HERE---
                    )
                  )
                )
        )
      )
)

