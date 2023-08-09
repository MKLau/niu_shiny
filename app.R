pkgs <- c("leaflet", "readxl", "magrittr", "htmlwidgets", "shiny")
sapply(pkgs, library, character.only = TRUE)
source("R/lib.R")

## Load data

load("data/niu_map_data.save")

## Shiny App

ui <- fluidPage(

    titlePanel("Uluniu Collection Locations 2024"),
    leafletOutput("niumap"),    
    sidebarLayout(
        sidebarPanel("Click each point for collection data."),
        mainPanel("Data Source: Indrajit Gunesekara, Niu Now!")
    )

)


server <- function(input, output, session){

    output$niumap <- renderLeaflet({
        niu.map <- leaflet() %>% addTiles() %>% 
            setView(lng = -158.0280608216874, lat = 21.496369036987605, zoom = 9) %>%
            addMarkers(data = tab.niu, lat = ~ lat, lng = ~ lon, popup = tab.niu[, "Demographic information"])
    })
}

shinyApp(ui, server)
