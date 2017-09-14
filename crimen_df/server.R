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
    
      
    if (input$crimen != 'todos') {
       crime_points <- crime_points %>% filter(crime == input$crimen)
     }
    
    crime_stats <- crime_points %>% filter(date > input$dates[1], date < input$dates[2]) %>%
                      mutate(month = month(date, label=TRUE, abbr=TRUE), year = year(date)) %>%
                      group_by(month,year,crime) %>% 
                      summarise(frecuencia = n()) %>% 
                      group_by(month,crime) %>%
                      summarise( average = mean(frecuencia))
    
    ggplot(crime_stats, aes(month,average)) + geom_bar(aes(fill=crime),stat="identity",width = 0.5)+ 
      theme(legend.position="none") + xlab('Mes') + ylab('Promedio anual Delitos')+ ggtitle('Promedio Delitos Mensual')
        
  })
  
  
  
  output$crimenes_violentos <- renderLeaflet({
    
    if( input$crimen != 'todos'){
    
    crimenes_violentos <- crime_points %>% 
                            filter(date > input$dates[1], date < input$dates[2], crime == input$crimen)
    } else {
      
      crimenes_violentos <- crime_points %>% 
        filter(date > input$dates[1], date < input$dates[2])
    }                         
                
    
    
    m2 <- leaflet(data=crimenes_violentos) %>% 
      addProviderTiles('CartoDB.Positron')%>% 
      # addCircleMarkers(~long,~lat,
      #                  radius = 1,
      #                  stroke=FALSE, color = ~crime,fillOpacity = .8) 
      addMarkers(~long,~lat,
        clusterOptions = markerClusterOptions(),  popup= ~crime)
    m2
    
  })
  
})
