library(shiny)
library(datasets)

elByInd <- list('CISA1' = c('M5   ','M6   ','M7   ','M8   '), # Elements By Indicators
                'CISA2' = c('M5   ','M6   ','M7   ','M8   '),
                'ISA1 ' = c('M1   ','M2   ','M3   ','M4   '),
                'ISA2 ' = c('M1   ','M2   ','M3   ','M4   '),
                'CRE  ' = c('D7   ','D8   '),
                'UCF  ' = c('B1   ','B2   ','B3   ','B4   '),
                'UCLF ' = c('B1   ','B3   ','B4   '),
                'FLR  ' = c('B1   ','B2   ','B3   ','B4   '),
                'GRLF ' = c('B1   ','B6   '),
                'UA7  ' = c('C1   ','C2   '),
                'US7  ' = c('C1   ','C2   ','C3   '),
                'SP1  ' = c('F1   ','F2   ','F3   ','F4   '),
                'SP2  ' = c('F5   ','F6   ','F7   ','F8   '),
                'SP5  ' = c('H1   ','H2   ','H3   ','H4   '),
                'FRI  ' = c('J1   ','J2   ','J3   ','K1   ','K2   ','K3   ','K4   ',
                            'K5   ','K6   ','K7   ','K8   ',
                            'N1   ','N2   ','N3   ','N4   '),
                'CY   ' = c('L2   ','L3   ','L4   ','L5   ','L6   ','L7   ','L8   ',
                            'L9   ','L10  ','L11  ','L12  ','L13  ','L14  ','L15  ',
                            'L16  ','L17  ','L18  ','L19  ','L20  ','L21  ','L22  ',
                            'L23  ','L24  ','L25  ','L26  ','L27  ','L28  ','L29  ',
                            'L30  ','L31  ','L32  ','L33  ','L34  ','L35  ','L36  '))

# Define server logic required to summarize and view the selected
# dataset

data <- readRDS('DBCopy/PI_IndValues.rds') #Source  data
relation <- readRDS('DBCopy/PI_PlaceRelationship.rds')
#dataStatus <- readRDS('DBCopy/PI_DataStatus.rds')
r <- readRDS('DBCopy/PI_Results.rds')
dates <- readRDS('DBCopy/PI_UnitDate.rds')
stat <- readRDS('DBCopy/PI_UnitDateTypeLookup.rds')
comms <- readRDS('DBCopy/PI_IndComments.rds')
dateType <- readRDS('DBCopy/PI_UnitDateTypeLookup.rds')

units <- readRDS('DBCopy/CORE_Unit.rds') # Look at OEDBID there; IAEARef and INPORef looks useful as well
eCode <- readRDS('DBCopy/OE_EventUnit.rds')
rCode <- readRDS('DBCopy/OE_EventReport.rds')
event <- readRDS('DBCopy/OE_Event.rds')

source('functions.r')

shinyServer(function(input, output) {

    uID <- reactive(subset(place,place$AbbrevLocName==input$name)[[1]]) # define unit ID

    oeid <- reactive(unlist(subset(units,units$INPORef==uID(),OEDBID))[[1]])
    eventCodes <- reactive(unlist(subset(eCode,eCode$UnitCode==oeid(),EventCode))) # list of events for selected unit
    repCodes <- reactive(unlist(subset(rCode,rCode$EventCode %in% eventCodes(),ReportCode)))
    lastDate <- reactive(dateToReal(input$qtr,'e'))
    startDate <- reactive(lastDate()-31*as.numeric(input$window))
    events <- reactive(subset(event, event$EventCode %in% eventCodes() & as.Date(event$EventDate)<=lastDate()
                     & as.Date(event$EventDate)>=startDate(),c(EventDate, EventTitle)))
    output$events <- renderTable(events())

    uNo <- reactive({
        pNo <-  as.integer(unique(subset(relation,
                                         relation$LocId == subset(place,place$AbbrevLocName==input$name)[[1]]
	& relation$RelationId == 4
	& as.Date(relation$EndDate) >= Sys.Date(),
	select=ParentLocId)))
        if(input$ind %in% c('SP5  ','ISA1  ','ISA2  ','CISA1','CISA2')) uNo <- pNo
        else uNo <- subset(place,place$AbbrevLocName==input$name)[[1]]
    })

    table <- reactive(subset(data,data$SourceId ==  uNo() & data$YrMn == input$qtr & data$ElementCode %in% elByInd[input$ind][[1]]))

    res <- reactive(subset(r,r$LocId == uNo() & PeriodEndYrMn == input$qtr & r$IndicatorCode == input$ind & r$NumOfMonths == input$window))

    date <- reactive(subset(dates,dates$LocId == subset(place,place$AbbrevLocName==input$name)[[1]]))

    com <- reactive(subset(comms,comms$SourceId == uNo() &
                                 comms$YrMn ==  input$qtr & comms$ElementCode %in% elByInd[input$ind][[1]]))

    output$sourceData <- renderTable(table())
    output$result <- renderTable(res())
    output$unitStatus <- renderTable(date())
    output$comments <- renderTable(com())

    #output$Indicator <- reactive(input$ind)
    #output$Elements <- reactive(elByInd[input$ind][[1]])

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

