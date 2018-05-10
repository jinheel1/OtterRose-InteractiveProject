library(shiny)
library(shinydashboard)
library(ggplot2)
library(tidyverse)
library(plotly)
library(forcats)

honey_data <- read_csv("honeyproduction.csv")

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
                      aes(y = priceperlb, x = totalprod, group = state)) + 
      geom_point()
    ggplotly(plotlyC)
    
  })
  
  
  
  
  #---Graph 4
  
  output$plotD <- renderPlot({

    plotD <- ggplot(honey_data, aes(x = state, y = totalprod)) +
      geom_freqpoly(stat = "identity", aes(x = fct_reorder(state,totalprod, mean))) +
      coord_flip() +
      theme_minimal()
    return(plotD)
  })
  
  
  
  #---Graph 5 
  
  
  
  
  #---Graph 6 
  
  
  
  

  
  
}

