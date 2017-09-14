

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

# temp <- tempfile()
# download.file("https://data.diegovalle.net/hoyodecrimen/cuadrantes.csv.zip",temp)
data <- read.csv(unz(temp, "clean-data/crime-lat-long.csv"))

crime_stats <- crime_points %>% 
  mutate( crime = gsub(' S.V','',crime)) %>%
  mutate( crime = gsub(' C.V','',crime)) %>%
  mutate(month = month(date, label=TRUE, abbr=TRUE), year = year(date)) %>%
  group_by(month,year,crime) %>% 
  summarise(frecuencia = n()) %>% 
  group_by(month,crime) %>%
  summarise( average = mean(frecuencia))

crimenes_violentos <- data %>% filter( crime %in% c('VIOLACION','HOMICIDIO DOLOSO'), !is.na(lat), !is.na(long))









