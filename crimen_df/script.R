

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
                        group_by(month) %>%
                          summarise( average = round(mean(frecuencia)))



ggplot(data=crime_stats, aes(x=month, y=freq, group=crime)) +
  geom_point( aes( color = crime), size=1.2) + geom_line( aes( color = crime))



crime_m <- crime_stats %>% group_by(month) %>% summarise( freq = sum(frecuencia))

crime_m <- crime_m %>% ungroup()

crime_stats %>% group_by(month) %>% summarise( freq = sum(frecuencia))
  
  xlab("muestra") + ylab("error prueba") +
  ggtitle("Simulación error de prueba") + theme(axis.text.x=element_text(angle = -90, hjust = 0))


