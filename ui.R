library(shiny)
library(leaflet)

shinyUI(pageWithSidebar(  
    headerPanel(
        img(src = "quakinator.png")
    ),
    sidebarPanel(    
        sliderInput("range", h5("Step 1: Select range of earthquake intensites (Richter scale):"),
                    min = 1.6, max = 9.5,
                    value = c(6,9.5)),
        dateRangeInput("dates", h5("Step 2: Select date range (filtered by years only)"), start = '1981-01-05', end = Sys.Date(),format = "yyyy"),
        h5("Step 3: Show earthquakes causing tsunamis only."),
        checkboxInput("tsu", "Tsunamis only", FALSE),
        br(),
        h4("Predicted mean Richter scale of earthquakes in 2018:"),
        h3(textOutput("mypredict"))
    ),
    mainPanel(
        leafletOutput("mymap"),
        plotOutput("myplot")
        
        
    )
))