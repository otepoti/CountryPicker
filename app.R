# Country picker app

library(rworldmap)
library(readr)
data(countryExData)
countryExData$Plot_Cat <- rep(factor('noShow', levels=c('noShow', 'Show')),
                              length.out = nrow(countryExData))
# Create a user defined colour palette
op <- palette(c('white', 'orange'))

library(shiny)

ui = fluidPage(
  sidebarPanel(
    selectInput("selectedCountries", "Choose some countries:",
                countryExData$Country, multiple = TRUE),
    tableOutput("data")
),

mainPanel(
  tabsetPanel(id="tp",
              tabPanel("Map View", plotOutput("mPlot", height="560px", width="950px")),
              tabPanel("Instructions", uiOutput("instruct"))
  )
)
)

server = function(input, output) {

  output$data <- renderTable({
    countryExData[countryExData$Country %in% input$selectedCountries,c(2, 5)]
  })
  # Generate the Map 
  output$mPlot <- renderPlot({
    countryExData$Plot_Cat[countryExData$Country %in% input$selectedCountries] <- 
      'Show'
    sPDF <- joinCountryData2Map( countryExData, joinCode = "ISO3",
                                 nameJoinColumn = "ISO3V10")
    mapParams <- mapCountryData(sPDF, 
                          nameColumnToPlot='Plot_Cat',
                          catMethod='categorical',
                          mapTitle='',
                          colourPalette='palette',
                          addLegend = FALSE,
                          oceanCol='lightblue',
                          missingCountryCol='white',
                          mapRegion = 'world')
  })
  
  output$instruct <- renderUI({
    HTML("
         </br>
         <p>Highlight countries in the Map View by selecting them from the list.</p>
         <p>You can delete countries by selecting the country in the box and hitting
         delete.</p>")
    })
  
}

shinyApp(ui = ui, server = server)
