library(shiny)
library(datasets)

elByInd <- list('CISA1' = c('M5   ','M6   ','M7   ','M8   '),
                'CRE  ' = c('D7   ','D8   ')) # Elements By Indicators

# Define server logic required to summarize and view the selected
# dataset

data <- readRDS('DBCopy/PI_IndValues.rds') #Source  data
#dataStatus <- readRDS('DBCopy/PI_DataStatus.rds')
r <- readRDS('DBCopy/PI_Results.rds')

#source('../functions.r')

shinyServer(function(input, output) {

    table <- reactive({subset(data,data$SourceId == subset(place,place$AbbrevLocName==input$name)[[1]] & data$YrMn == input$qtr & data$ElementCode %in% elByInd[input$ind][[1]])})

    res <- reactive({subset(r,r$LocId == subset(place,place$AbbrevLocName==input$name)[[1]] & PeriodEndYrMn == input$qtr & r$IndicatorCode == input$ind & r$NumOfMonths == input$window)})

    output$sourceData <- renderTable(table())
    output$result <- renderTable(res())
    output$Indicator <- reactive({input$ind})
    output$Elements <- reactive({elByInd[input$ind][[1]]})

  # Return the requested dataset
#   datasetInput <- reactive({
#     switch(input$dataset,
#            "rock" = rock,
#            "pressure" = pressure,
#            "cars" = cars)
#   })

  # print(input$dataset)

  # Generate a summary of the dataset
#   output$summary <- renderPrint({
#     dataset <- datasetInput()
#     summary(dataset)
#   })

  # Show the first "n" observations
  #output$view <- renderTable({
    #head(datasetInput(), n = input$obs)
  #})
  #output$dataset = renderText({input$dataset})
})

