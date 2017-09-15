#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)


factpal = colorFactor(palette = 'RdYlBu',crime_points$crime)

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
  
  output$crimen_semanal <- renderPlotly({ 
    
    
    if (input$crimen != 'todos') {
      crime_points <- crime_points %>% filter(crime == input$crimen)
    }
    
    crime_stats <- crime_points %>% filter(date > input$dates[1], date < input$dates[2]) %>%
      mutate(weekday = weekdays(as.Date(date, abbr=TRUE)), day = day(as.Date(date)))%>%
      group_by(day,weekday,month,year,crime) %>% 
      summarise(frecuencia = n()) %>% 
      group_by(weekday,crime) %>%
      summarise( average = round(mean(frecuencia)))
    
    crime_stats$weekday <- factor( crime_stats$weekday, levels= c("lunes", "martes", 
                                                                  "miércoles", "jueves", "viernes", "sábado", "domingo"))
    crime_stats[order(crime_stats$weekday), ]
    
    ggplot(crime_stats, aes(weekday,average)) + geom_bar(aes(fill=crime),stat="identity",width = 0.5)+ 
      theme(legend.position="none") + xlab('Mes') + ylab('Promedio Semanal Delitos')+ ggtitle('Promedio Delitos Semanal')
    
  })
  
  
  
  output$crimenes_violentos <- renderLeaflet({
    
    if( input$crimen != 'todos'){
    
    crimenes_violentos <- crime_points %>% 
                            filter(date > input$dates[1], date < input$dates[2], crime == input$crimen, !is.na(long), !is.na(lat))
    
    } else {
      
      crimenes_violentos <- crime_points %>% 
        filter(date > input$dates[1], date < input$dates[2], !is.na(long), !is.na(lat))
      
    }                         
                
    m2 <- leaflet(data=crimenes_violentos) %>% 
      addProviderTiles('CartoDB.DarkMatter', group='Carto black')%>% 
      addProviderTiles('CartoDB.Positron', group='Carto gray')%>% 
      addCircleMarkers(~long,~lat,stroke = FALSE,fillOpacity = 1,
                       clusterOptions = markerClusterOptions(),
                       popup= ~crime, color=~factpal(crime),
                       group='Puntos y Clusters') %>%
      addLegend("bottomright", pal = factpal, values = ~crime,title = "Delito",opacity = 1) %>%
      addWebGLHeatmap(lng=~long, lat=~lat, size = 1500,opacity = .8, group = 'Heatmap') %>%
      addLayersControl(
        baseGroups = c("Carto black", "Carto gray"),
        overlayGroups = c("Puntos y Clusters", "Heatmap"),
        options = layersControlOptions(collapsed = FALSE)
      )
    

    m2
    
  })
  
  
  
  output$asesinatos <- renderValueBox({
    
    crimenes_violentos <- crime_points %>% 
      filter(date > input$dates[1], date < input$dates[2], crime == 'HOMICIDIO DOLOSO') 
    
    valueBox(
      nrow(crimenes_violentos), "Asesinatos", icon = icon("list"),
      color = "purple"
    )
  })
  
  output$robo_a_casa <- renderValueBox({
    
    crimenes_violentos <- crime_points %>% 
      filter(date > input$dates[1], date < input$dates[2], crime == 'ROBO A CASA HABITACION.') 
    
    valueBox(
      nrow(crimenes_violentos), "Robo Casa", icon = icon("thumbs-up", lib = "glyphicon"),
      color = "yellow"
    )
  })
  
  output$violacion <- renderValueBox({
    
    crimenes_violentos <- crime_points %>% 
      filter(date > input$dates[1], date < input$dates[2], crime == 'VIOLACION') 
    
    valueBox(
      nrow(crimenes_violentos), "Violación", icon = icon("list"),
      color = "blue"
    )
  })
  
  output$robo_a_taxi <- renderValueBox({
    
    crimenes_violentos <- crime_points %>% 
      filter(date > input$dates[1], date < input$dates[2], crime == 'ROBO A BORDO DE TAXI.') 
    
    valueBox(
      nrow(crimenes_violentos), "Robo taxi", icon = icon("list"),
      color = "green"
    )
  })
  
  output$robo_a_repartidor <- renderValueBox({
    
    crimenes_violentos <- crime_points %>% 
      filter(date > input$dates[1], date < input$dates[2], crime == 'ROBO A REPARTIDOR.') 
    
    valueBox(
      nrow(crimenes_violentos), "Robo a Repartidor", icon = icon("list"),
      color = "yellow"
    )
  })
  
  output$robo_a_negocio <- renderValueBox({
    
    crimenes_violentos <- crime_points %>% 
      filter(date > input$dates[1], date < input$dates[2], crime == 'ROBO A NEGOCIO.') 
    
    valueBox(
      nrow(crimenes_violentos), "Robo a Negocio", icon = icon("list"),
      color = "maroon"
    )
  })
  
  output$crimen_por_hora1 <- renderPlotly({
    
    cp <- cp <- crime_points %>% filter(date > input$dates[1], date < input$dates[2])
    cp$hora <- as.integer(substr(cp$hour,1,2))
    base <-cp %>% group_by(hora,crime) %>%
            summarise(frequency=n()) %>%
            filter( crime %in% c("HOMICIDIO DOLOSO","VIOLACION","LESIONES POR ARMA DE FUEGO","ROBO A NEGOCIO."))
    
    ggplot(base, aes(hora,frequency)) + geom_bar(stat='identity') + facet_grid( crime~ .)
    
    
  })
  
  output$crimen_por_hora2 <- renderPlotly({
    
    cp <- crime_points %>% filter(date > input$dates[1], date < input$dates[2])
    cp$hora <- as.integer(substr(cp$hour,1,2))
    base <-cp %>% group_by(hora,crime) %>%
      summarise(frequency=n()) %>%
      filter( !crime %in% c("HOMICIDIO DOLOSO","VIOLACION","LESIONES POR ARMA DE FUEGO","ROBO A NEGOCIO."))
    
    ggplot(base, aes(hora,frequency)) + geom_bar(stat='identity') + facet_grid( crime~ .)
    
    
  })
  
  output$Calor <- renderLeaflet({
    
      
      crimenes_violentos <- crime_points %>% 
        filter(date > input$dates[1], date < input$dates[2], crime == 'HOMICIDIO DOLOSO', !is.na(long), !is.na(lat))
 
    
    m <- leaflet(data=crimenes_violentos) %>% 
      addProviderTiles('CartoDB.Positron', group='Carto gray')%>% 
      addCircleMarkers(~long,~lat,stroke = FALSE,fillOpacity = .4,
                       clusterOptions = markerClusterOptions(),
                       popup= ~crime, color=~factpal(crime), radius= 1)
    m
    
    
  })
  
  output$Crimen_tiempo <- renderPlotly({
    
    
    if( input$crimen != 'todos'){
      
      crime_points <- crime_points %>% 
        filter(crime == input$crimen)
    } 

    
    crimenes_violentos <- crime_points %>% 
      filter(date > input$dates[1], date < input$dates[2]) %>%
    mutate( date = as.Date(date)) %>%
    select(crime,date) %>% group_by(date,crime) %>% summarise(freq = n())
    
    ggplot(crimenes_violentos, aes(date,freq,color=crime)) + geom_point() + geom_line() +
      theme(legend.position="none") + xlab('Tiempo') + ylab('Frecuencia')
    
  })
  
  output$Crimen_tiempo2 <- renderPlotly({
    
    t
    if( input$crimen != 'todos'){
      
      crime_points <- crime_points %>% 
        filter(crime == input$crimen)
    } 
    
    
    crimenes_violentos <- crime_points %>% 
      filter(date > input$dates[1], date < input$dates[2]) %>%
      mutate( date = as.Date(date)) %>%
      select(crime,date) %>% group_by(date,crime) %>% summarise(freq = n())
    
    ggplot(crimenes_violentos, aes(date,freq,color=crime)) + geom_point() + geom_line() + xlab('Tiempo') + ylab('Frecuencia')
    
  })
  
})
