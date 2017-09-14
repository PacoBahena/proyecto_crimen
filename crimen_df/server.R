#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
source('globals.R')

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
   
  output$crimen_mensual <- renderPlotly({ 
    ggplot(data=crime_stats, aes(x=month, y=average, group=crime)) +
          geom_point( aes(color = crime), size=1.2) + geom_line( aes( color = crime)) +
          theme(legend.position="none")
      
  })
  
  output$crimenes_violentos <- renderLeaflet({
    
    m2 <- leaflet(data=crimenes_violentos) %>% 
      addProviderTiles('CartoDB.Positron')%>% 
      # addCircleMarkers(~long,~lat,
      #                  radius = 1,
      #                  stroke=FALSE, color = ~crime,fillOpacity = .8) 
      addMarkers(~long,~lat,
        clusterOptions = markerClusterOptions())
    m2
    
  })
  
})
