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

units <- readRDS('DBCopy/CORE_Unit.rds') # Look at OEDBID there; IAEARef and INPORef looks useful as well

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
    ### Source data ###
    sourceData <- reactive(
    {
    quarters <- c(input$qtr,as.numeric(input$qtr)-1,as.numeric(input$qtr)-2)
    s <- subset(data,data$SourceId ==  uNo() & data$YrMn %in% quarters & data$ElementCode %in% elByInd[input$ind][[1]])
    sourceData <- s
    sourceData <- cbind(s[1:3],apply(s[4],1,el),s[5:8])
    })
    ### Results ###
    res <- reactive(subset(r,r$LocId == uNo() & PeriodEndYrMn == input$qtr & r$IndicatorCode == input$ind & r$NumOfMonths == input$window))
    ### Unit dates ###
    udate <- reactive({
        dt <- subset(dates,dates$LocId == subset(place,place$AbbrevLocName==input$name)[[1]])
        udate <- cbind(dt[1:2],apply(dt[3],1,status),dt[4])
        })
    ### Commentary ###
    com <- reactive(subset(comms,comms$SourceId == uNo() &
                                 comms$YrMn ==  input$qtr & comms$ElementCode %in% elByInd[input$ind][[1]]))
    ### Results chart ###
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
    lttplot <- reactive(if (input$LTTChart){
        fn <- paste('LTT/Worldwide_LTT_',input$lttqtr,'.rds',sep='')
        ltt <- readRDS(fn)
        barplot(unlist(ltt$Ind.percentage),names.arg = unlist(ltt$Indicator),main = "Individual LTT(target=100%)",ylim=c(0,105))
        abline(h=100, col='red')
        #barplot(table(unlist(ltt$Ind.percentage),unlist(ltt$Indust.percentage)),names.arg = unlist(ltt$Indicator),beside=TRUE,legend = c('Individual','Industry'))
    })
    ilttplot <- reactive(if (input$LTTChart){
        fn <- paste('LTT/Worldwide_LTT_',input$lttqtr,'.rds',sep='')
        ltt <- readRDS(fn)
        barplot(unlist(ltt$Indust.percentage),names.arg = unlist(ltt$Indicator),main = "Industry LTT (target=75%)")
        abline(h=75, col='red')
    })
    rcplot <- reactive(if (input$LTTChart){
        fn <- paste('LTT/RCs_LTT_',input$lttqtr,'.rds',sep='')
        rcltt <- readRDS(fn)
        #barplot((unlist(ltt$Ind.percentage),names.arg = unlist(ltt$Indicator))
    })


    output$wwltt <- renderDataTable(ltt(),options=list(paging = FALSE,searching=FALSE))
    output$wwlttplot <- renderPlot(lttplot())
    output$wwilttplot <- renderPlot(ilttplot())
    output$rcltt <- renderDataTable(rcltt(),options=list(paging = FALSE,searching=FALSE))
    output$rclttplot <- renderPlot(rcplot())


############################ Downloads #########################

############################ Metrics ###########################

    metrics <- reactive(if (input$mDetail)
                            withProgress(message="Calculating...",value=0,
                                         m(input$metricsqtr,as.numeric(input$centre))))
    output$metrics <- renderPrint(metrics())
### charts
#    reactive(
#        withProgress(message = 'Metrics calculation',value=0,{
#            lastQtr <- which(qtrs == input$metricsqtr)
#            firstQtr <- which(qtrs == input$metricsFirstQtr)
#            pi1 <- data.frame()
#            pi2 <- data.frame()
#            ltp1 <- data.frame()
#            for (d in qtrs[firstQtr,lastQtr]){
#                pi1 <- rbind(pi1,m(d)


############################ Outliers ##########################

    out <- reactive({
        uList <- subset(r,r$IndicatorCode == input$outind & r$PeriodEndYrMn == input$outqtr & r$NumOfMonths == input$outwindow & r$NonQualCode == ' ',c(LocId,ResultsValue))
        outList <- boxplot.stats(uList$ResultsValue,coef = as.numeric(input$coef))
        outList <- outList$out
        out <- subset(uList,uList$ResultsValue %in% outList,c(LocId,ResultsValue))
                                        # Add unit names
        unames <- subset(place,place$LocId %in% out$LocId,AbbrevLocName)
        out <- cbind(out,unames)
    })

    outliers <- reactive(boxplot(unlist(subset(r,r$IndicatorCode == input$outind & r$PeriodEndYrMn == input$outqtr & r$NumOfMonths == input$outwindow & r$NonQualCode == ' ',ResultsValue)),range =  as.numeric(input$coef)))

    output$outliers <- renderDataTable(out(),options=list(paging = FALSE,searching=FALSE))

    ### boxplot for outliers ###
    output$boxplot <- renderPlot(outliers())

################################# Unit status #########################
    pdate <- reactive({
        p <- subset(dates,dates$LocId == subset(place,place$AbbrevLocName==input$pname)[[1]])
        pdate <- cbind(p[1:2],apply(p[3],1,status),p[4])
        #pdate <- pdate[order(UnitDate),]
    })
    output$status <- renderDataTable(pdate(),options=list(paging = FALSE,searching=FALSE))

})

