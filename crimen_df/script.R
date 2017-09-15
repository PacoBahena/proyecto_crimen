

library(leaflet)
library(ggplot2)
library(tidyverse)
library(readr)
library(jsonlite)

temp <- tempfile()
download.file("https://data.diegovalle.net/hoyodecrimen/cuadrantes.csv.zip",temp)
crime_points <- read_csv(unz(temp, "clean-data/crime-lat-long.csv"))
crime_polygon_data <- read_csv(unz(temp, "clean-data/"))

table(crime_points$crime)


crime_stats <- crime_points %>% 
                mutate( crime = gsub(' S.V','',crime)) %>%
                  mutate( crime = gsub(' C.V','',crime)) %>%
                  mutate(month = month(date, label=TRUE, abbr=TRUE), year = year(date)) %>%
                    group_by(month,year,crime) %>% 
                      summarise(frecuencia = n()) %>% 
                        group_by(month,crime) %>%
                          summarise( average = round(mean(frecuencia)))



p <- ggplot(crime_stats, aes(month,average)) + geom_bar(aes(fill=crime),stat="identity")+ 
    theme(legend.position="none") + xlab('Mes') + ylab('Promedio anual Delitos')+ ggtitle('Promedio Delitos Mensual')
p <- ggplotly(p)


crime_stats <- crime_points %>% 
  mutate( crime = gsub(' S.V','',crime)) %>%
  mutate( crime = gsub(' C.V','',crime), date = as.Date(date)) %>%
  filter(date > '2013-01-01', date< '2013-04-01') %>%
  select(crime,date) %>% group_by(date,crime) %>% summarise(freq = n())

ggplot(crime_stats, aes(date,freq,color=crime)) + geom_point() + geom_line()



crime_points$hora <- as.integer(substr(crime_points$hour,1,2))

base <-crime_points %>% group_by(hora,crime) %>% summarise(frequency=n())

base$tipo <- ifelse( base$crime == 'HOMICIDIO DOLOSO','homicidio', ifelse(base$crime == 'VIOLACION','violación','Robo'))

ggplotly(ggplot(base, aes(hora,frequency)) + geom_bar(stat='identity') + facet_grid( tipo~ .))





