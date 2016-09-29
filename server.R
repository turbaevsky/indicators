#######################################################################################
# This shiny server script produces the source data, results, unit status, comments
# and OE data for quick checking. Should work with ui.R under R environment
#######################################################################################

# TODO:
# Fix Qreport.r date transfer

#source('data.r')

### Name of the elements ###
el <- function(e) { return(subset(elem,elem$LabelCode==e,LabelText)[[1]]) }
### Name of unit status ###
status <- function(cs) { return(subset(stat,stat[1]==cs,Description)[[1]]) }

shinyServer(function(input, output) {
    # OE DB
    uID <- reactive(subset(place,place$AbbrevLocName==input$name)[[1]]) # define unit ID

    oeid <- reactive(unlist(subset(units,units$INPORef==uID(),OEDBID))[[1]])
    eventCodes <- reactive(unlist(subset(eCode,eCode$UnitCode==oeid(),EventCode))) # list of events for selected unit
    repCodes <- reactive(unlist(subset(rCode,rCode$EventCode %in% eventCodes(),ReportCode)))
    lastDate <- reactive(dateToReal(input$qtr,'e'))
    ########################## Start date calculation have to be fixed ####################
    startDate <- reactive(lastDate()-31*as.numeric(input$window))
    events <- reactive(subset(event, event$EventCode %in% eventCodes() & as.Date(event$EventDate)<=lastDate()
                     & as.Date(event$EventDate)>=startDate(),c(EventDate, EventTitle)))

    # Is it unit or plant?
    uNo <- reactive({
        pNo <-  as.integer(unique(subset(relation,
                                         relation$LocId == subset(place,place$AbbrevLocName==input$name)[[1]]
	& relation$RelationId == 4
	& as.Date(relation$EndDate) >= Sys.Date(),
	select=ParentLocId)))
        if(input$ind %in% c('SP5  ','ISA1 ','ISA2 ','CISA1','CISA2')) uNo <- pNo
        else uNo <- subset(place,place$AbbrevLocName==input$name)[[1]]
    })

    sourceData <- reactive(
    {
    quarters <- c(input$qtr,as.numeric(input$qtr)-1,as.numeric(input$qtr)-2)
    s <- subset(data,data$SourceId ==  uNo() & data$YrMn %in% quarters & data$ElementCode %in% elByInd[input$ind][[1]])
    sourceData <- s
    sourceData <- cbind(s[1:3],apply(s[4],1,el),s[5:8])
    })

    res <- reactive(subset(r,r$LocId == uNo() & PeriodEndYrMn == input$qtr & r$IndicatorCode == input$ind & r$NumOfMonths == input$window))

    udate <- reactive({
        dt <- subset(dates,dates$LocId == subset(place,place$AbbrevLocName==input$name)[[1]])
        udate <- cbind(dt[1:2],apply(dt[3],1,status),dt[4])
        })

    com <- reactive(subset(comms,comms$SourceId == uNo() &
                                 comms$YrMn ==  input$qtr & comms$ElementCode %in% elByInd[input$ind][[1]]))

    rChart <- reactive({
        barplot(unlist(subset(r,r$LocId == uNo() & PeriodEndYrMn %in% qtrs & r$IndicatorCode == input$ind & r$NumOfMonths == input$window & r$NonQualCode == ' ',c(ResultsValue))),xlab="Quarters",xaxt='n')
        axis(side=1,at=c(1:length(qtrs)),labels=qtrs)})

    # progressbar for DB copying ################################################
    observeEvent(input$update,{
        withProgress(message = 'DB copying',value=0,DBCopy())
        source('shiny/data.r')
        output$dbcopydate <- renderPrint(dbcopy)
    }
    )
    # TISA (re)calculation ######################################################
    observeEvent(input$tisa,{
        source('tisa2.r')
        withProgress(message = 'Selected quarter TISA (re)calculating',value=0,tisa2(input$repqtr))})
    # (Re)create QReport ########################################################
    observeEvent(input$qreport,{
        withProgress(message = 'Selected quarter LTT report (re)generation',value=0,generate(input$lttqtr))
        Sweave('Qreport.rnw')
        system("C:\\Users\\volodymyr.turbaevsky\\portable\\MKTex\\miktex\\bin\\pdflatex.exe Qreport.tex")
    })
    # Excel (re)generation ######################################################
    observeEvent(input$excel,withProgress(message = 'Selected quarter excel (re)generation',value=0,xls(input$repqtr)))


    output$dbcopydate <- renderPrint(dbcopy)

    output$sourceData <- renderDataTable(sourceData(),options=list(paging = FALSE,searching=FALSE))
    output$result <- renderDataTable(res(),options=list(paging = FALSE,searching=FALSE))
    output$unitStatus <- renderDataTable(udate(),options=list(paging = FALSE,searching=FALSE))
    output$comments <- renderDataTable(com(),options=list(paging = FALSE,searching=FALSE))
    output$events <- renderDataTable(events(),options=list(paging = FALSE,searching=FALSE))
    output$resultChart <- renderPlot(rChart())


############################### LTT ################################

    ltt <- reactive({
        fn <- paste('LTT/Worldwide_LTT_',input$lttqtr,'.rds',sep='')
        ltt <- readRDS(fn)})
    rcltt <- reactive({
        fn <- paste('LTT/RCs_LTT_',input$lttqtr,'.rds',sep='')
        rcltt <- readRDS(fn)})


    output$wwltt <- renderDataTable(ltt(),options=list(paging = FALSE,searching=FALSE))
    output$rcltt <- renderDataTable(rcltt(),options=list(paging = FALSE,searching=FALSE))


############################ Downloads #########################

############################ Metrics ###########################

    metrics <- reactive(m(input$metricsqtr))
    output$metrics <- renderPrint(metrics())



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

