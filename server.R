library(shiny)
library(leaflet)

earthquakes <- read.csv(file='shinyEarthquake.csv', sep = '\t')


shinyServer(  
    function(input, output) {

        filteredData <- reactive({
                # earthquakes[((earthquakes$FLAG_TSUNAMI == 'Tsu') == input$tsu) && earthquakes$EQ_PRIMARY > 6,]
                if (input$tsu) {
                    tsuFilter = 'Tsu'
                } else {
                    tsuFilter = c('Tsu','')
                }
                earthquakes[earthquakes$FLAG_TSUNAMI %in% tsuFilter
                            & earthquakes$EQ_PRIMARY >= input$range[1] & earthquakes$EQ_PRIMARY <= input$range[2]
                            & earthquakes$YEAR >= lubridate::year(input$dates[1]) & earthquakes$YEAR<= lubridate::year(input$dates[2]),]
            })
        
        output$mymap <- renderLeaflet({
            leaflet(filteredData()) %>% addTiles() %>%
               addCircles(data = filteredData(),weight=1,radius = (earthquakes$EQ_PRIMARY)*5000)
        })
        
        output$myplot <- renderPlot({
          plot(aggregate(EQ_PRIMARY ~ YEAR, filteredData(), mean), ylab='Mean Richter scale of earthquakes')
            abline(linFit(), col="red", lwd = 2)
            points(2018,predict(linFit(),data.frame(YEAR=2018)), col = "red", pch=16, cex=2)
        })
        linFit <- reactive({
          data <- aggregate(EQ_PRIMARY ~ YEAR, filteredData(), mean)
          lm(EQ_PRIMARY ~ YEAR, data)
        })
        output$mypredict <- renderText({ 
          round(predict(linFit(),data.frame(YEAR=2018))*10)/10
        })

        }
)