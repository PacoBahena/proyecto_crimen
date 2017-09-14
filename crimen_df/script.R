

library(leaflet)
library(ggplot2)
library(tidyverse)
library(readr)


temp <- tempfile()
download.file("https://data.diegovalle.net/hoyodecrimen/cuadrantes.csv.zip",temp)
crime_points <- read_csv(unz(temp, "clean-data/crime-lat-long.csv"))
crime_polygon_data <- read_csv(unz(temp, "clean-data/crime-lat-long.csv"))

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



  
