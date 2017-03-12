# Country picker app

library(rworldmap)
data(countryExData)
countryExData$Plot_Cat <- rep(factor('noShow', levels=c('noShow', 'Show', 'NGO')),
                              length.out = nrow(countryExData))

ngoCountries <- c('CMR', 'GHA', 'KEN', 'MWI', 'NGA', 'NPL', 'TZA', 'UGA', 'ZMB')
countryExData$Plot_Cat[countryExData$ISO3V10 %in% ngoCountries] <- 'NGO'
# Create a user defined colour palette
op <- palette(c('white','yellow', 'orange'))

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
    HTML('
         </br>
         <p>Highlight countries in the Map View by selecting them from the list.</p>
         <p>You can delete countries by selecting the country in the box and hitting
         delete.</p>
         <p>Start typing a country name to bring up possibilities</p>
         <p>You can even type another part of the name - for example, if you want to 
         select the "stans", try typing "stan".
         <p>If you want to list the population of one of the original NGO countries 
         you will have to select it from the list</p>
         <p>There is currently no way to remove the original NGO countries (something
         will be added later!).</p>')
    })
  
}

shinyApp(ui = ui, server = server)
