
library(shiny)
library(shinydashboard)

header <- dashboardHeader(title = "Crime dashboard")

sidebar <- dashboardSidebar(
  br(),
  sidebarMenu(
    menuItem("Tendencia", tabName = "evolucion", icon = icon("line-chart")),
    menuItem("Asesinatos", tabName = "asesinos", icon = icon("map-o")),
    dateRangeInput("dates", h3("Date range")),
    selectInput("select", h3("Select box"), 
                choices = list("Choice 1" = 1, "Choice 2" = 2,
                               "Choice 3" = 3), selected = 1)
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


