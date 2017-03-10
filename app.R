# Country picker app

library(rworldmap)
library(readr)
data(countryExData)

library(shiny)

ui = fluidPage(
selectInput("selectedCountries", "Choose some countries:",
            countryExData$Country, multiple = TRUE),
tableOutput("data")
)

server = function(input, output) {
  output$data <- renderTable({
    countryExData[countryExData$Country %in% input$selectedCountries,1:2]
  })
}

shinyApp(ui = ui, server = server)
