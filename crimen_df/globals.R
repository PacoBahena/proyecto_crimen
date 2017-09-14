

if(!require(shiny)){
  install.packages("shiny")
  library(shiny)
}

if(!require(shinydashboard)){
  install.packages("shinydashboard")
  library(shinydashboard)
}

if(!require(leaflet)){
  install.packages("leaflet")
  library(leaflet)
}

if(!require(tidyverse)){
  install.packages("tidyverse")
  library(tidyverse)
}


if(!require(lubridate)){
  install.packages("lubridate")
  library(lubridate)
}

if(!require(plotly)){
  install.packages("plotly")
  library(plotly)
}

#####Leer bases 
temp <- tempfile()
download.file("https://data.diegovalle.net/hoyodecrimen/cuadrantes.csv.zip",temp)
crime_points <- read.csv(unz(temp, "clean-data/crime-lat-long.csv"),stringsAsFactors = FALSE)

crime_points <- crime_points %>% 
  mutate( crime = gsub(' S.V','',crime)) %>%
  mutate( crime = gsub(' C.V','',crime)) 



ggplot(data=crime_stats, aes(x=month, y=average, group=crime)) +
  geom_point( aes(color = crime), size=1.2) + geom_line( aes( color = crime)) +
  theme(legend.position="none")







