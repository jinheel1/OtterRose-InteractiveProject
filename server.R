library(shiny)
library(shinydashboard)
library(ggplot2)
library(tidyverse)
library(plotly)
library(forcats)

library(maps)
library(mapdata)
library(ggExtra)
library(maptools)
library(mapproj)
library(rgeos)
library(readr)
library("RColorBrewer")
library(data.table)

library(sp)
library(rgdal)
library(classInt)
library(RColorBrewer)
library(datasets)

#devtools::install_github('Ather-Energy/ggTimeSeries')
library(ggTimeSeries)

honey_data <- read_csv("honeyproduction.csv")
states.dat <- read_csv("D:/315pmd/OtterRose-InteractiveProject/states_data.csv")
states <- map_data("state")
#---DATA PARSING HAPPENS HERE IF YOU WANT IT TO AFFECT EVERY GRAPH---

#---OR YOU CAN PARSE THE DATA WHILE RENDERING THE PLOT IF YOU WANT IT TO AFFECT A SINGLE GRAPH---

function(input, output) {
  
  #---Graph 1 (Jinhee Lee)
  
  # output$plotA <- renderPlot({
  #   
  #   honey_data_state <- honey_data[which(honey_data$state == input$state),]
  # 
  #   plotA <- ggplot(honey_data_state, aes(x = factor(honey_data_state$year), y = honey_data_state$numcol)) +
  #     geom_bar(stat = "identity") +
  #     labs(x = "blah", y = "Numcol", title = paste("Number of Colonies for:", input$state))
  #   
  #   return(plotA)
  #   
  # })
  
  output$plotlyA1 <- renderPlotly({
    
    honey_data_state <- honey_data[which(honey_data$state == input$state),]
    
    plotly1 <- ggplot(subset(honey_data, state%in%input$state), 
                      aes(x = factor(year), y = totalprod / 100000, group = state, color = state)) +
      geom_line(size = 2) +
      #---Adjusting label orientation
      theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
      labs(title = paste("Total Honey Production for US States"),
           x = "Year", y = "Amount (in 100,000 lbs)",
           color = "State(s)")
    
    ggplotly(plotly1)
    
  })
  
  # output$plotlyA2 <- renderPlotly({
  #   
  #   honey_data_state2 <- honey_data[which(honey_data$state == input$state2),]
  #   
  #   plotly1 <- ggplot(subset(honey_data, state%in%input$state2), 
  #                     aes(x = factor(year), y = numcol, group = state, color = state)) +
  #     geom_line(size = 2) +
  #     labs(x = "blah", y = "Numcol", title = paste("Number of Colonies for:"))
  #   
  #   ggplotly(plotly1)
  #   
  # })
  

  #---Graph 2 (Jinhee Lee)
  
  output$plotB <- renderPlot({
    plotB <- ggplot(honey_data, aes(x = factor(year), y = numcol)) +
      geom_bar(stat = "identity")
    return(plotB)
  })
  
  
  #---Graph 3
  output$plotlyC <- renderPlotly({
    
    honey_data_state <- honey_data[which(honey_data$state == input$state),]
    
    plotlyC <- ggplot(data = subset(honey_data, state%in%input$state), 
                      aes(y = priceperlb, x = totalprod, group = state)) + geom_point()
    ggplotly(plotlyC)
    
  })
  
  
  #---Graph 4
  
  output$plotlyD <- renderPlotly({
  
  foo <- input$variable
  
  plotlyD <- ggplot(data = honey_data, aes_string(x = 'state', y = input$variable)) + 
      geom_bar(stat = "identity") +
      theme_minimal()
    
  ggplotly(plotlyD)
  })
  
  #---Graph 5 
  output$plotE <- renderPlot({
    
    plotE <- ggplot(data=states.dat,aes(x=long.x, y = lat.x)) + 
      geom_map(aes_string(group = 'group.x', map_id = 'region.x', fill=input$mean_var), map = states) +
      coord_map(project="conic", lat0 = 30) +
      scale_fill_continuous(low="white", high="red", name ="input$mean_var") +
      labs(title = "Mean Total Production of Honey (lbs) by State (1998-2012)",
           caption = "Source: Honey Production In The USA (1998 -2012)") +
      theme_minimal() +
      theme(axis.ticks = element_blank(),
            axis.text.x = element_blank(),
            axis.text.y = element_blank(),
            axis.title.x= element_blank(),
            axis.title.y= element_blank(),
            panel.border = element_blank(),
            panel.grid.minor=element_blank(),
            panel.grid.major=element_blank())
    
    return(plotE)
  })

  #---Graph 6 
  

output$plotly6 <- renderPlotly({
  
  honey_data_state <- honey_data[which(honey_data$state == input$state2),]
  
  plotly6 <- ggplot(subset(honey_data, state%in%input$state2), 
                    aes(x = factor(year), y = priceperlb, group = state, color = state)) +
    geom_line(size = 1) +
    #---Adjusting label orientation
    theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
    labs(title = paste("National Average Price per pound of Honey (USD)"),
         x = "Year", y = "Average Price per pound (USD)",
         color = "State(s)")
  
  ggplotly(plotly6)
  
})


  

#---Graph 7

output$plotly7 <- renderPlotly({
  
  honey_data_state <- honey_data[which(honey_data$state == input$state3),]
  
  honey_data_selection <- subset(honey_data, state%in%input$state3)
  
  # base plot
  plotly7 = ggplot(honey_data_selection, aes(x = year, y = priceperlb, fill = state)) +
    stat_steamgraph(alpha = .5) + 
    xlab('') + 
    ylab('')  +
    labs(title = "Time Series: Steamgraph of Price of Honey ($/lb) ",
         caption = "Source: Honey Production In The USA (1998 -2012)") +
    theme_minimal() +
    coord_fixed( 0.2 * diff(range(honey_data_selection$year)) / diff(range(honey_data_selection$priceperlb))) 
  
   ggplotly(plotly7)
  
})


output$plotly8 <- renderPlotly({
  
  # base plot
  plotly8 = ggplot(honey_data, aes(x = totalprod, y = priceperlb)) + geom_point() 

  ggMarginal(plotly8, type = "histogram")
  ggplotly(plotly8)
  
  
})

}

