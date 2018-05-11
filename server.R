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
states.dat <- read_csv("states_data.csv")
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
  
  output$plotly1 <- renderPlotly({
    
    #honey_data_state <- honey_data[which(honey_data$state == input$state),]
    
    plotly1 <- ggplot(subset(honey_data, state%in%input$state), 
                      aes(x = factor(year), y = totalprod / 100000, group = state, color = state)) +
      geom_line(size = .5) +
      #---Adjusting label orientation
      theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
      labs(title = paste("Total Honey Production for US States"),
           x = "Year", y = "Amount (in 100,000 lbs)",
           color = "State(s)") 
    
    ggplotly(plotly1) %>%
      layout(
        margin = list(b = 50, l = 50) # to fully display the x and y axis labels
      )
    
  })
  
  
  #---Graph 2 (Jinhee Lee)
  
  output$plotly2 <- renderPlotly({
    
    #honey_data_state2 <- honey_data[which(honey_data$state == input$state2),]
    #honey_data_state2 <- honey_data_state2[which(honey_data$year == input$year2)]
    
    honey_data_totalsold <- honey_data %>%
      group_by(state, totalprod, stocks) %>%
      mutate(totalsold = totalprod - stocks) %>%
      ungroup
    
    
    plotly2 <- ggplot(subset(honey_data_totalsold, year%in%input$year2 & state%in%input$state2), 
                      aes(x = state, y = totalsold / 100000,
                          group = state, fill = state)) +
      geom_bar(stat = "identity") +
      #---Adjusting label orientation
      #theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
      labs(title = paste("Amount of Honey Sold by Dec. 15th"),
           x = "State(s)", y = "Amount (in 100,000 lbs)",
           fill = "State(s)")
    
    ggplotly(plotly2)
    
  })

  
  
  # #---SCRAPPED
  # 
  # output$plotlyC <- renderPlotly({
  #   
  #   honey_data_state <- honey_data[which(honey_data$state == input$state),]
  #   
  #   plotlyC <- ggplot(data = subset(honey_data, state%in%input$state), 
  #                     aes(y = priceperlb, x = totalprod, group = state)) + geom_point()
  #   ggplotly(plotlyC)
  #   
  # })
  
  
  #---Graph 3
  
  output$plotlyD <- renderPlotly({
  
  foo <- input$variable
  
  
  
  plotlyD <- ggplot(data = honey_data, aes_string(x = 'state', y = input$variable, fill = 'state')) + 
    geom_bar(stat = "identity") +
    theme(legend.position="none") +
    theme(axis.text.x = element_text(angle = 45, hjust = 1))
    
    ggplotly(plotlyD) %>%
      layout(
        margin = list(b = 50, l = 50) # to fully display the x and y axis labels
      )
    
  })
  
  #---Graph 4
  
  output$plotE <- renderPlot({
    
    plotE <- ggplot(data=states.dat,aes(x=long.x, y = lat.x)) + 
      geom_map(aes_string(group = 'group.x', map_id = 'region.x', fill = input$mean_var), map = states) +
      coord_map(project="conic", lat0 = 30) +
      scale_fill_continuous(low="white", high="red", name ="mean_totalprod (lbs)") +
      labs(title = paste(input$mean_var, "by State (1998-2012)")) +
      theme_minimal() +
      theme(axis.ticks = element_blank(),
            axis.text.x = element_blank(),
            axis.text.y = element_blank(),
            axis.title.x= element_blank(),
            axis.title.y= element_blank(),
            panel.border = element_blank(),
            panel.grid.minor=element_blank(),
            panel.grid.major=element_blank())
    
    return (plotE)
  })

  #---Graph 5
  

output$plotly6 <- renderPlotly({
  
  honey_data_state <- honey_data[which(honey_data$state == input$state6),]
  
  plotly6 <- ggplot(subset(honey_data, state%in%input$state6), 
                    aes(x = factor(year), y = priceperlb, group = state, color = state)) +
    geom_line(size = 1) +
    #---Adjusting label orientation
    theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
    labs(title = paste("National Average Price per pound of Honey (USD)"),
         x = "Year", y = "Average Price per pound (USD)",
         color = "State(s)")
  
  ggplotly(plotly6)
  
})


  

#---Graph 6

output$plotly7 <- renderPlotly({
  
  honey_data_state <- honey_data[which(honey_data$state == input$state7),]
  
  honey_data_selection <- subset(honey_data, state%in%input$state7)
  
  # base plot
  plotly7 = ggplot(honey_data_selection, aes(x = year, y = priceperlb, fill = state)) +
    stat_steamgraph(alpha = .5) + 
    xlab('') + 
    ylab('')  +
    labs(title = "Time Series: Steamgraph of Price of Honey ($/lb) ",
         caption = "Source: Honey Production In The USA (1998-2012)") +
    theme_minimal() +
    coord_fixed( 0.2 * diff(range(honey_data_selection$year)) / diff(range(honey_data_selection$priceperlb))) 
  
   ggplotly(plotly7)
  
})


#--- SCRAPPED

# output$plotly8 <- renderPlotly({
#   
#   # base plot
#   plotly8 = ggplot(honey_data, aes(x = totalprod, y = priceperlb)) + geom_point() 
# 
#   ggMarginal(plotly8, type = "histogram")
#   ggplotly(plotly8)
#   
#   
# })

}

