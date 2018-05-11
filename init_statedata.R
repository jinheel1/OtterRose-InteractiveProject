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

write.csv(states.dat, file = "states_sata.csv")