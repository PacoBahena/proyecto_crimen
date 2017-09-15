
library(shiny)
library(shinydashboard)
source('globals.R')

header <- dashboardHeader(title = "Crime dashboard")

sidebar <- dashboardSidebar(
  br(),
  sidebarMenu(
    menuItem("Temporal", tabName = "evolucion", icon = icon("line-chart")),
    menuItem("Diario", tabName = "diario", icon = icon("clock-o")),
    menuItem("Mapas", tabName = "asesinos", icon = icon("map-o")),
    menuItem("Integrador", tabName = "integrador", icon = icon("lightbulb-o")),
    dateRangeInput("dates",start ='2013-01-01',end='2014-01-01',h3("Fechas")),
    selectInput("crimen", h3("Delito"), 
                choices = list(
                          "VIOLACION" = "VIOLACION", 
                          "ROBO A NEGOCIO." = "ROBO A NEGOCIO.",
                          "ROBO DE VEHICULO AUTOMOTOR." = "ROBO DE VEHICULO AUTOMOTOR.",
                          "ROBO A TRANSEUNTE." = "ROBO A TRANSEUNTE.",
                          "LESIONES POR ARMA DE FUEGO" = "LESIONES POR ARMA DE FUEGO",
                          "HOMICIDIO DOLOSO" = "HOMICIDIO DOLOSO",
                          "ROBO A REPARTIDOR." = "ROBO A REPARTIDOR.",
                          "ROBO A CUENTAHABIENTE." = "ROBO A CUENTAHABIENTE.",
                          "ROBO A BORDO DE TAXI." = "ROBO A BORDO DE TAXI.",
                          "ROBO A BORDO DE MICROBUS." = "ROBO A BORDO DE MICROBUS.",
                          "ROBO A TRANSPORTISTA." = "ROBO A TRANSPORTISTA.",
                          "ROBO A CASA HABITACION." = "ROBO A CASA HABITACION.",
                          "ROBO A BORDO DE METRO." = "ROBO A BORDO DE METRO.",
                          "todos" = "todos"), selected = "todos")
  )
)

body <- dashboardBody(
  tabItems(
    tabItem(tabName = "evolucion",
            fluidRow(
              box(
                title = "Evolución temporal", width = 12, background = "light-blue",
                "Las siguientes gráficas presentan el comportamiento del crimen en el tiempo, 
                en primer lugar el promedio de delitos por díadel mes, día de la semana, así como por mes."
              ),
              br(),
              box(
                title = "Promedio Delitos Mensual",
                status = "primary",
                solidHeader = TRUE,
                collapsible = TRUE,
                width = 6,
                plotlyOutput("crimen_mensual")
                
              ),
              box(
                title = "Promedio Delitos Mensual",
                status = "primary",
                solidHeader = TRUE,
                collapsible = TRUE,
                width = 6,
                plotlyOutput("crimen_semanal")
                
              ),
              box(
                title = "Delitos en el Tiempo", width = 12,
                plotlyOutput('Crimen_tiempo2',height = 600 )
              )
            )
    ),
    
    tabItem(
      tabName = "asesinos",
      fluidRow(
        box(
          title = "Información Georeferenciada", width = 12, background = "light-blue",
          "Los siguientes mapas presentan información de los delitos georreferenciados.
          Los circulos con número constituyen clusters de delitos, para ver como se agrupan,
          da click en algunos de ellos. Asimismo, depediendo de los inputs con respecto a fecha y delito, 
          se crea un mapa de calor con respecto a la concentración de los mismos. Los delitos individuales
          están coloreados según el crimen.
          "
        ),
        br(),
        box(
          title = "Crimen en la Ciudad de México.",
          status = "primary",
          solidHeader = TRUE,
          collapsible = TRUE,
          width = 12,
          leafletOutput("crimenes_violentos", height = 600)
        )
      )
    ),
    tabItem(tabName = "diario",
            fluidRow(
              box(
                title = "Pestaña general", width = 12, background = "light-blue",
                "La siguiente pestaña muestra visualizaciones temporales por hora, integradoras, de 
                todo el dashboard"
              ),
              box(
                title = "Delitos por Hora",
                status = "primary",
                solidHeader = TRUE,
                collapsible = TRUE,
                width = 12,
                plotlyOutput("crimen_por_hora1", height = 800)
                
              ),
              box(
                title = "Delitos por Hora",
                status = "primary",
                solidHeader = TRUE,
                collapsible = TRUE,
                width = 12,
                plotlyOutput("crimen_por_hora2",height = 1200)
                
              )
            )
    ),
    tabItem(
      tabName = "integrador",
      fluidRow(
        box(
          title = "Pestaña general", width = 12, background = "light-blue",
          "La siguiente pestaña muestra visualizaciones espacio-temporales, integradoras, de 
                todo el dashboard. Favor de esperar 12 segundos por los mapas y value boxes."
        ),
        valueBoxOutput("asesinatos"),
        valueBoxOutput("robo_a_casa"),
        valueBoxOutput("violacion"),
        valueBoxOutput("robo_a_repartidor"),
        valueBoxOutput("robo_a_taxi"),
        valueBoxOutput("robo_a_negocio"),
        box(
          title = "Asesinatos", width = 5, background = "light-blue",
          leafletOutput("Calor", height = 600)
        ),
        box(
          title = "Delitos en el Tiempo", width = 7,
          plotlyOutput('Crimen_tiempo',height = 600 )
        )
      )
    )
  )
)

dashboardPage(header, sidebar, body)


