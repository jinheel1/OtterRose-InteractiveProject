library(shiny)
library(shinydashboard)
library(ggplot2)
library(tidyverse)
library(plotly)
library(ggmap)

dashboardPage(skin = "yellow",
              
    dashboardHeader(title = "Otter Rose"),
    
    #---Naming the tabs
    dashboardSidebar(width="200px",
                     sidebarMenu(
                       menuItem("Introduction", tabName = "intro", icon = icon("th")),
                       menuItem("Total Honey Production", tabName = "number1", icon = icon("th")),
                       menuItem("Total Honey Sold", tabName = "number2", icon = icon("th")),
                       menuItem("Graph 3", tabName = "number4", icon = icon("th")),
                       menuItem("Graph 4", tabName = "number5", icon = icon("th")),
                       menuItem("Graph 5", tabName = "number6", icon = icon("th")),
                       menuItem("Graph 6", tabName = "number7", icon = icon("th"))
                       )
                     ),
    
    #---UI Content of tabs
    dashboardBody(
      tabItems(
        
        tabItem(tabName = "intro",
                fluidRow(
                  box(
                    width = 12,
                    h1("Introduction"),
                    p("The dataset can be found in this link from Kaggle: https://www.kaggle.com/jessicali9530/honey-production. 
                      This dataset examines honey production in the USA from 1998-2012 and was collected by the National Agricultural Statistics Service (NASS), in response to global concern over the rapid decline in the honeybee population. 
                      It features 8 variables with 626 observations. Each case examines statistics like total production of honey (in lbs), price per pound, and arithmetic combinations of its variables for 1 of 43 states in a single year."),
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
                    selectInput(inputId = "state", label = "Click & Choose States to Compare. Delete to Erase Lines.",
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
                    selectInput(inputId = "state2", label = "Click & Choose States to Compare. Delete to Erase Bars.",
                                choices = c("AL", "AZ", "AR", "CA", "CO", "FL", "GA", "HI", "ID", "IL",
                                            "IN", "IA", "KS", "KY", "LA", "ME", "MD", "MI", "MN", "MS",
                                            "MO", "MT", "NE", "NV", "NJ", "NM", "NY", "NC", "ND", "OH",
                                            "OK", "OR", "PA", "SD", "TN", "TX", "UT", "VT", "VA", "WA",
                                            "WV", "WI", "WY", "SC"),
                                multiple = T, selected = c("AL","AZ")),
                    selectInput(inputId = "year2", label = "Choose a Year.",
                                choices = c(1998, 1999, 2000, 2001, 2002, 2003, 2004,
                                            2005, 2006, 2007, 2008, 2009, 2010, 2011, 2012),
                                selected = 2008)
                    )
                  )
                ),
        
        
        #---UI Content of Graph 3
        tabItem(tabName = "number4",
                fluidRow(
                  box(

                    #---STUFF GOES HERE---
                    background = "purple",
                    plotlyOutput("plotlyD", height = 800),
                    radioButtons(inputId = "variable", label = "Choose a variable to view.", 
                                 choices = c("Total Production of Honey (lbs)" = "totalprod", 
                                            "Average Price per Pound ($/lb)"  = "priceperlb",
                                            "Number of Honey-Producing Colonies" = "numcol",
                                            "Yield per Colony (lbs)" = "yieldpercol",
                                            "Honey Held by Producers by Dec. 15th (lbs)" = "stocks",
                                            "Value of Production ($)" = "prodvalue")),
                    width = 12
                    
                    )
                  )
                ),
        
        #---UI Content of Graph 4
        tabItem(tabName = "number5",
                fluidRow(
                  box(
                    #---STUFF GOES HERE---
                    plotOutput("plotE"),
                    radioButtons(inputId = "mean_var", label = "choose mean_var", 
                                 choices = c("mean_totalprod.x",
                                             "mean_priceperlb.x",
                                             "mean_numcol.x",
                                             "mean_yieldpercol.x",
                                             "mean_stocks.x",
                                             "mean_priceperlb.x",
                                             "mean_prodvalue.x")),
                    width = 12
                  )
                )
        ),
        
        #---UI Content of Graph 5
        tabItem(tabName = "number6",
                fluidRow(
                  box(
                    background = "purple",
                    plotlyOutput("plotly6"), width = 12,
                    selectInput(inputId = "state6", label = "Click & Choose States to Compare. Delete to Erase Lines.",
                                choices = c("AL", "AZ", "AR", "CA", "CO", "FL", "GA", "HI", "ID", "IL",
                                            "IN", "IA", "KS", "KY", "LA", "ME", "MD", "MI", "MN", "MS",
                                            "MO", "MT", "NE", "NV", "NJ", "NM", "NY", "NC", "ND", "OH",
                                            "OK", "OR", "PA", "SD", "TN", "TX", "UT", "VT", "VA", "WA",
                                            "WV", "WI", "WY", "SC"),
                                multiple = T, selected = c("AL", "AZ"))
                  )
                  )
                ),
        #---UI Content of Graph 6
        tabItem(tabName = "number7",
                fluidRow(
                  box(
                    background = "purple",
                    plotlyOutput("plotly7"), width = 12,
                    selectInput(inputId = "state7", label = "Click & Choose States to Compare. Delete to Erase Steam.",
                                choices = c("AL", "AZ", "AR", "CA", "CO", "FL", "GA", "HI", "ID", "IL",
                                            "IN", "IA", "KS", "KY", "LA", "ME", "MD", "MI", "MN", "MS",
                                            "MO", "MT", "NE", "NV", "NJ", "NM", "NY", "NC", "ND", "OH",
                                            "OK", "OR", "PA", "SD", "TN", "TX", "UT", "VT", "VA", "WA",
                                            "WV", "WI", "WY", "SC"),
                                multiple = T, selected = c("AL", "AZ"))
                    )
                  )
                )
        )
      )
)

