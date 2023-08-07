pkgs <- c("leaflet", "readxl", "magrittr", "htmlwidgets")
sapply(pkgs, library, character.only = TRUE)
source("R/lib.R")

## Data prep

x <- readxl::read_xlsx("data/UHWO Niu Nursery Narration of 24 niu varities 7.29.2023.xlsx", sheet = 1)
x <- data.frame(x)
colnames(x) <- x[1, ]
x <- x[-1:-2, ]
x <- x[-nrow(x), ]
latlon <- convert_latlon(x[, 2])
colnames(latlon) <- c("lat", "lon")
latlon[, "lon"] <- latlon[, "lon"] * -1
x <- cbind(number = x[, 1], latlon, x[, -1:-2])
loc.name <- sapply(x[, 4], function(x) strsplit(x, ":")[[1]][1])
names(loc.name) <- seq(1, length(loc.name))
x <- cbind("Location Name" = loc.name, x[, c(5, 7, 12, 14)])

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
            addMarkers(data = x, lat = ~ lat, lng = ~ lon, popup = x[, "Demographic information"])
    })
}

shinyApp(ui, server)
