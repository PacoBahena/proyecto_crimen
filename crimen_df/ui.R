
library(shiny)
library(shinydashboard)
#source('globals.R')

header <- dashboardHeader(title = "Crime dashboard")

sidebar <- dashboardSidebar(
  br(),
  sidebarMenu(
    menuItem("Tendencia", tabName = "evolucion", icon = icon("line-chart")),
    menuItem("Asesinatos", tabName = "asesinos", icon = icon("map-o")),
    dateRangeInput("dates",start ='2013-01-01',end='2014-01-01',h3("Date range")),
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
                "Las siguientes gráficas presentan el comportamiento del crimen en el tiempo"
              ),
              br(),
              box(
                title = "Crimen mensual",
                status = "primary",
                solidHeader = TRUE,
                collapsible = TRUE,
                width = 6,
                plotlyOutput("crimen_mensual")
                
              )
            )
    ),
    
    tabItem(
      tabName = "asesinos",
      fluidRow(
        box(
          title = "Información Georeferenciada", width = 12, background = "light-blue",
          "Los siguientes mapas presentan información de los delitos georreferenciados."
        ),
        br(),
        box(
          title = "Crimen mensual",
          status = "primary",
          solidHeader = TRUE,
          collapsible = TRUE,
          width = 6,
          leafletOutput("crimenes_violentos")
        )
      )
    )
  )
)

dashboardPage(header, sidebar, body)


