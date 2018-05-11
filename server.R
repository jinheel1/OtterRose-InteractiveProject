library(shiny)
library(shinydashboard)
library(ggplot2)
library(tidyverse)
library(plotly)
library(forcats)
library(ggmap)
library(maps)
library(mapdata)
library(RColorBrewer)
library(classInt)
library(rgdal)
library(sp)
library(maptools)
library(mapproj)
library(rgeos)
library("RColorBrewer")


honey_data <- read_csv("honeyproduction.csv")

#---------------------------------------------------
# CHLOROPLETH MAP ZONE - DO NOT TOUCH 
#---------------------------------------------------
honey_data2 <- read_csv("honeyproduction.csv")
honey_data2$mean_totalprod <- 0


enterST <- function(x){
  return (mean(honey_data2$totalprod[which(honey_data2$state == x)]));
}

for(i in 1:50){
  x = state.abb[i]
  honey_data2$mean_totalprod[which(honey_data2$state == x)] <- enterST(x)
}

state_tb <- as.data.frame(honey_data2)
names(state_tb)[1] <- paste("state")
names(state_tb)[2] <- paste("numcol")
names(state_tb)[3] <- paste("yieldpercol")
names(state_tb)[4] <- paste("totalprod")
names(state_tb)[5] <- paste("stocks")
names(state_tb)[6] <- paste("priceperlb")
names(state_tb)[7] <- paste("prodvalue")
names(state_tb)[8] <- paste("year")
names(state_tb)[9] <- paste("mean_totalprod")

states.coords <- map_data("state")
states <- map_data("state")

## Convert 'state_tb2' states abbreviations to full names states 'state_tb2$State_FN' using abb2state.R function (Thanks to Guangyang Li)
abb2state <- function(name, convert = F, strict = F){
  data(state)
  # state data doesn't include DC
  state = list()
  state[['name']] = c(state.name,"District Of Columbia")
  state[['abb']] = c(state.abb,"DC")
  
  if(convert) state[c(1,2)] = state[c(2,1)]
  
  single.a2s <- function(s){
    if(strict){
      is.in = tolower(state[['abb']]) %in% tolower(s)
      ifelse(any(is.in), state[['name']][is.in], NA)
    }else{
      # To check if input is in state full name or abb
      is.in = rapply(state, function(x) tolower(x) %in% tolower(s), how="list")
      state[['name']][is.in[[ifelse(any(is.in[['name']]), 'name', 'abb')]]]
    }
  }
  
  sapply(name, single.a2s)
}

states.coords$region_FN <- abb2state(states.coords$region)
state_tb$State_FN <- abb2state(state_tb$state)

# Merge states.coords and state_tb2 using respective columns 'region_FN' and 'State_FN'
states.dat<-merge(states.coords, state_tb, by.x = 'region_FN', by.y = 'State_FN')


# Download a shapefile with ALL states
tmp_dl <- tempfile()
download.file("http://www2.census.gov/geo/tiger/GENZ2013/cb_2013_us_state_20m.zip", tmp_dl)
unzip(tmp_dl, exdir=tempdir())
states50 <- readOGR(tempdir(), "cb_2013_us_state_20m")

# Change projection
states50 <- spTransform(states50, CRS("+proj=laea +lat_0=45 +lon_0=-100 +x_0=0 +y_0=0 +a=6370997 +b=6370997 +units=m +no_defs"))
states50@data$id <- rownames(states50@data)


# Rotate, Scale and Move Alaska
# Alaska State ID Number=02
# https://www.census.gov/geo/reference/docs/state.txt
alaska <- states50[states50$STATEFP=="02",]
alaska <- elide(alaska, rotate=-50)
alaska <- elide(alaska, scale=max(apply(bbox(alaska), 1, diff)) / 2.2)
alaska <- elide(alaska, shift=c(-2100000, -2500000))
# Force projection to be that of original plot
proj4string(alaska) <- proj4string(states50)

# Rotate and Move Hawaii, ID=15
hawaii <- states50[states50$STATEFP=="15",]
hawaii <- elide(hawaii, rotate=-35)
hawaii <- elide(hawaii, shift=c(5400000, -1400000))
proj4string(hawaii) <- proj4string(states50)


# Add Alaska and Hawaii to the 48 states
states48 <- states50[!states50$STATEFP %in% c("02", "15"),] 
states.final <- rbind(states48, alaska, hawaii)

# Load state_tb2
state_tb2 <- state_tb


# Merge data - STUSPS and State are the abbreviated state names in each dataset.
states.final@data <-merge(states.final@data, states.dat, by.x = 'STUSPS', by.y='state', sort = F, all.x=T)

states.plotting<-fortify(states.final@data, region='STUSPS')
states.dat<-merge(states.plotting, states.dat, by.x = 'id', by.y='state', sort = F, all.x=T)

#---------------------------------------------------



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
  
  output$plotly1 <- renderPlotly({
    
    #honey_data_state <- honey_data[which(honey_data$state == input$state),]
    
    plotly1 <- ggplot(subset(honey_data, state%in%input$state), 
                      aes(x = factor(year), y = totalprod / 100000, group = state, color = state)) +
      geom_line(size = 1) +
      #---Adjusting label orientation
      theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
      labs(title = paste("Total Honey Production for US States"),
           x = "Year", y = "Amount (in 100,000 lbs)",
           color = "State(s)") 
    
    ggplotly(plotly1)
    
  })
  
  # output$plotlyA2 <- renderPlotly({
  # 
  #   honey_data_state <- honey_data[which(honey_data$state == input$state),]
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
  
  
  output$plotly2 <- renderPlot({
    
    #honey_data_state2 <- honey_data[which(honey_data$state == input$state2),]
    #honey_data_state2 <- honey_data_state2[which(honey_data$year == input$year2)]
    
    honey_data_totalsold <- honey_data %>%
      group_by(state, totalprod, stocks) %>%
      mutate(totalsold = totalprod - stocks) %>%
      ungroup
    
    
    plotly2 <- ggplot(subset(honey_data_totalsold, state%in%input$state2), 
                      aes(x = state, y = totalsold)) +
      geom_bar(stat = "identity") +
      #---Adjusting label orientation
      #theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
      labs(title = paste("Amount of Honey Sold"),
           subtitle = "*By Dec. 15th",
           x = "State(s)", y = "Pounds (lbs)")
    
    ggplotly(plotly2)
    
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
  
  output$plotE <- renderPlot({
    states <- map_data("state")
    
    plotE <- ggplot(data=states.dat,aes(x=long.x, y = lat.x)) + 
      geom_map(aes(group = group.x, map_id = region.x, fill=mean_totalprod.x), map = states) +
      coord_map(project="conic", lat0 = 30) +
      scale_fill_continuous(low="white", high="red", name ="# mean totalprod") +
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
}
  #---Graph 6 
  
  
  
  

  
  


