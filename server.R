#######################################################################################
# This shiny server script produces the source data, results, unit status, comments
# and OE data for quick checking. Should work with ui.R under R environment
#######################################################################################

# TODO:
# Fix Qreport.rnw last date (currently manually)

#source('data.r')

### Name of the elements ###
el <- function(e) { return(subset(elem,elem$LabelCode==e,LabelText)[[1]]) }
### Name of unit status ###
status <- function(cs) { return(subset(stat,stat[1]==cs,Description)[[1]]) }

units <- readRDS('DBCopy/CORE_Unit.rds') # Look at OEDBID there; IAEARef and INPORef looks useful as well

############################## Server ####################################
shinyServer(function(input, output, clientData, session) {
    # OE DB <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
    #uID <- reactive(subset(place,place$AbbrevLocName %in% input$name)[[1]]) # define unit ID

    #oeid <- reactive(unlist(subset(units,units$INPORef %in% uID(),OEDBID))[[1]])
    #eventCodes <- reactive(unlist(subset(eCode,eCode$UnitCode %in% oeid(),EventCode))) # list of events for selected unit
    #repCodes <- reactive(unlist(subset(rCode,rCode$EventCode %in% eventCodes(),ReportCode)))
    #lastDate <- reactive(dateToReal(input$qtr,'e'))
    ########################## Start date calculation have to be fixed ####################
                                        #startDate <- reactive(lastDate()-31*as.numeric(input$window))

    repCode <- function(eCode){
        reportCode <- subset(rCode,rCode$EventCode == eCode,ReportCode)[[1]]
        #print(reportCode)
        link <- paste('<a href="http://www.wano.org/OperatingExperience/OE_Database_2012/Pages/EventReportDetail.aspx?ids=',reportCode,'" target="_blank">Go to OE DB</a>',sep='')
        return(link)
        }

    events <- reactive({
        uID <- subset(place,place$AbbrevLocName %in% input$name)[[1]] # define unit ID
        oeid <- unlist(subset(units,units$INPORef %in% uID,OEDBID))[[1]]
        lastDate <- dateToReal(input$qtr,'e')
        startDate <- lastDate-31*as.numeric(input$window)
        eventCodes <- unlist(subset(eCode,eCode$UnitCode %in% oeid,EventCode)) # list of events for selected unit
        ev <- subset(event, event$EventCode %in% eventCodes & as.Date(event$EventDate)<=lastDate
                     & as.Date(event$EventDate)>=startDate,select=c(EventCode,EventDate,EventTitle))
        #print(ev[1])
        #repCodes <- unlist(subset(rCode,rCode$EventCode %in% ev$EventCode,ReportCode))
        #print(repCodes)

        #link <- paste('<a href="http://www.wano.org/OperatingExperience/OE_Database_2012/Pages/EventReportDetail.aspx?ids=',repCode(i),'" target="_blank">Go to OE DB</a>',sep='')
                                        #print(link)
            ######### TODO: fix link and ev ##########
        #print(ev)                                #events <- cbind(link,i)}
        events <- cbind(apply(t(ev[,1]),2,repCode),ev)
        #print(events)
    })

    output$events <- renderDataTable(events(),options=list(paging = FALSE,searching=FALSE),escape = FALSE)


    # Is it unit or plant?
    uNo <- reactive({
        pNo <-  as.integer(unique(subset(relation,
                                         relation$LocId %in% subset(place,place$AbbrevLocName %in% input$name)[[1]]
	& relation$RelationId == 4
	& as.Date(relation$EndDate) >= Sys.Date(),
	select=ParentLocId)))
        if(input$ind %in% c('SP5  ','ISA1 ','ISA2 ','CISA1', 'CISA2')) uNo <- pNo
        else uNo <- subset(place,place$AbbrevLocName %in% input$name)[[1]]
    })
### Comments for FRI ###
    bq2ci <- 3.7e10
    note <- reactive(if (input$ind == 'FRI  ')
                                out <- paste('Fuel criteria for BWR is 1.1E7 Bq/g =',signif(1.1E7/bq2ci,3),'Ci/g and for PWR/PWR - 1.9E1 Bq/g = ',signif(1.9E1/bq2ci,3),'Ci/g')
                     else out <- '')
    output$note <- renderText(note())


### Source data ###
    sourceData <- reactive(
    {
    quarters <- c(input$qtr,as.numeric(input$qtr)-1,as.numeric(input$qtr)-2)
    s <- subset(data,data$SourceId %in%  uNo() & data$YrMn %in% quarters & data$ElementCode %in% elByInd[input$ind][[1]])
    sourceData <- s
    sourceData <- cbind(s[1:3],apply(s[4],1,el),s[5:8])
    })
    ### Results ###
    res <- reactive(subset(r,r$LocId %in% uNo() & r$PeriodEndYrMn %in% input$qtr & r$IndicatorCode %in% input$ind & r$NumOfMonths == input$window))
    ### Index ###
    index <- reactive({
        unNo <- subset(place,place$AbbrevLocName %in% input$name)[[1]] # Anyway unit No
        index <- subset(idx,IndexId==4 & PeriodEndYrMn %in% input$qtr & LocId %in% unNo)})
    output$index <- renderDataTable(index(),options=list(paging = FALSE,searching=FALSE))
    ### Unit dates ###
    udate <- reactive({
        dt <- subset(dates,dates$LocId == subset(place,place$AbbrevLocName %in% input$name)[[1]])
        udate <- cbind(dt[1:2],apply(dt[3],1,status),dt[4])
        })
    ### Commentary ###
    com <- reactive(subset(comms,comms$SourceId %in% uNo() &
                                 comms$YrMn %in% input$qtr & comms$ElementCode %in% elByInd[input$ind][[1]]))
    ### Results chart ###
    rChart <- reactive({
        dataset <- subset(r,r$LocId %in% uNo() & PeriodEndYrMn %in% qtrs & r$IndicatorCode %in% input$ind & r$NumOfMonths == input$window & r$NonQualCode == ' ',c(ResultsValue,PeriodEndYrMn))
        d <- dataset[1]
        #print(d)
        rownames(d) <- dataset[[2]]
        #print(d)
        barplot(t(d),xlab="Quarters",main = input$ind)#,xaxt='n')
                                        #axis(side=1,at=c(1:length(dataset[[2]])),labels=dataset[[2]])
        ### Add abline for FRI ###
        #if (input$ind == 'FRI  '){
        #    bq2ci <- 3.7e10
        #    abline(h=1.1e7/bq2ci,col='red')
        #    abline(h=1.9e1/bq2ci,col='red')
        #    text(0,1.1e7/bq2ci,'BWR')
        #    text(0,1.9e1/bq2ci,'PWR/PHWR')
        #    }
    })

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
        Sweave('Qreport.rnw') #<<<<<<<<<<<<<<<<<<<<<<<<< The last date have to be switched manually
        system("C:\\Users\\volodymyr.turbaevsky\\portable\\MKTex\\miktex\\bin\\pdflatex.exe Qreport.tex")
    })
    # Excel (re)generation ######################################################
    observeEvent(input$excel,withProgress(message = 'Selected quarter TISA & excel (re)generation',value=0,xls(input$repqtr,input$Tisa)))

    output$table <- renderTable(err())
    output$dbcopydate <- renderPrint(dbcopy)

    output$sourceData <- renderDataTable(sourceData(),options=list(paging = FALSE,searching=FALSE))
    output$result <- renderDataTable(res(),options=list(paging = FALSE,searching=FALSE))
    output$unitStatus <- renderDataTable(udate(),options=list(paging = FALSE,searching=FALSE))
    output$comments <- renderDataTable(com(),options=list(paging = FALSE,searching=FALSE))
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
### Plotting industry and individual targets by ggplot
    library(ggplot2)
    output$IndLTT <- renderPlot(if (input$LTTChart){
        fn <- paste('LTT/RCs_LTT_',input$lttqtr,'.rds',sep='')
        rc <- readRDS(fn)
        fn <- paste('LTT/Worldwide_LTT_',input$lttqtr,'.rds',sep='')
        ww <- readRDS(fn)
        plot3 <- ggplot(rc,aes(unlist(Indicator),unlist(Ind.percentage),group=unlist(Centre),color=unlist(Centre)))+
            coord_polar()+
            geom_point()+
            geom_line()+
            theme(legend.title=element_blank(),axis.title.x=element_blank(),axis.title.y=element_blank())+
            ggtitle('The most recent percentage of units\nmeeting individual targets')
        print(plot3)
                                })
        output$IndustLTT <- renderPlot(if (input$LTTChart){
        fn <- paste('LTT/RCs_LTT_',input$lttqtr,'.rds',sep='')
        rc <- readRDS(fn)
        fn <- paste('LTT/Worldwide_LTT_',input$lttqtr,'.rds',sep='')
        ww <- readRDS(fn)
        plot3 <- ggplot(rc,aes(unlist(Indicator),unlist(Indust.percentage),group=unlist(Centre),color=unlist(Centre)))+
            coord_polar()+
            geom_point()+
            geom_line()+
            theme(legend.title=element_blank(),axis.title.x=element_blank(),axis.title.y=element_blank())+
            ggtitle('The most recent percentage of units\nmeeting industry targets')
        print(plot3)
                                       })


    output$wwltt <- renderDataTable(ltt(),options=list(paging = FALSE,searching=FALSE))
    output$wwlttplot <- renderPlot(lttplot())
    output$wwilttplot <- renderPlot(ilttplot())
    output$rcltt <- renderDataTable(rcltt(),options=list(paging = FALSE,searching=FALSE))
    output$rclttplot <- renderPlot(rcplot())


############################ Downloads #########################

    output$tisa_down <- downloadHandler(
        filename = function() {
            paste("TISA_", input$repqtr, ".csv", sep="")},
        content = function(file) file.copy(paste("csv/TISA_",input$repqtr,".csv",sep=''), file)
    )

    output$xls_down <- downloadHandler(
        filename = function() {
            fn <- paste(dateToQ(input$repqtr),"_AllLocationsResults.csv", sep="")
            print(fn)
        },
        content = function(file) file.copy(paste("spreadsheets/",dateToQ(input$repqtr),"_AllLocations_Results.csv", sep=""), file)
        )

    output$qRepDown <- downloadHandler(filename = 'Qreport.pdf', content = function(file) file.copy('Qreport.pdf', file))

############################ Metrics ###########################

    metrics.out <- reactive(if (input$mDetail)
                            withProgress(message="Calculating...",value=0,
                                         metrics(input$metricsqtr,as.numeric(input$centre),TRUE)))
    output$metrics <- renderPrint(metrics.out())
### charts
    #cNames <- c('AC','MC','PC','TC')
    mPlot <- reactive( if (input$mChart)
                           withProgress(message = 'Metrics calculation',value=0,{
                               res <- c()
                               for (d in input$metricsqtr)
                                   res <- rbind(res,metrics(d,as.numeric(input$centre)))
                               print(res)
                               mPlot <- barplot(res,names.arg = input$centre,legend = rownames(res),
                                                beside = TRUE, col = c("darkblue","green","yellow"))
                           }))
    output$pi1 <- renderPlot(mPlot())
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

    uDatas <- reactive(subset(uData,LocId == subset(place,place$AbbrevLocName==input$pname)[[1]]))
    output$uData <- renderDataTable(uDatas(),options=list(paging = FALSE,searching=FALSE))

################################ Submitting progress ##################
    subPlot <- reactive(
        withProgress(message="Calculating...",value=0,submitProgress(input$subqtr)))
    output$submit <- renderPlot(subPlot())
    sub <- reactive(
        if (input$sDetail)
            withProgress(message="Calculating...",value=0,submitProgress(input$subqtr,FALSE)))
    output$submitting <- renderPrint(sub())
################################ Indicator trend ##############################
    iPlot <- reactive(indicatorSummary(input$trendind,input$outliers,input$rType,input$country))
    output$indtrend <- renderPlot(iPlot())
    #output$Atable <- renderDataTable(iPlot$A)

    ###########################################################################
################################ PIRA #########################################
    ###########################################################################
    histAll <- reactive({
        Id <- unique(unlist(subset(place,place$AbbrevLocName %in% input$PRname,LocId)))
        print(paste('Id=',Id))
        plants <- c('SP5  ','ISA1 ','ISA2 ','CISA1','CISA2','TISA2')
        #if (input$PRind %in% plants) updateSelectInput(session,'dist',choices = c('Worldwide'))
        #else updateSelectInput(session,'dist',choices = c('Worldwide','Same reactor type','Same reactor type and RC'))
        #print(LocId)
        rt <- unique(unlist(subset(uData,LocId %in% Id,NsssTypeId))) # Reactor type
        print(paste('ReactorType=',rt))
        rc <- unique(unlist(subset(relation,relation$LocId %in% Id & relation$RelationId == 1 & as.Date(relation$EndDate) >= Sys.Date(), select=ParentLocId))) # Regional Centre
        print(paste('RC=',rc))
        #print(c(length(rt),length(rc)))
        #if (length(rc)==1 && length(rt)==1 & !(input$PRind %in% plants)) updateSelectInput(session,'dist',choices = c('Worldwide','Same reactor type','Same reactor type and RC'))
        #if (length(rc)>1) updateSelectInput(session,'dist',choices = c('Worldwide','Same reactor type'))
        #if (length(rt)>1 || (input$PRind %in% plants)) updateSelectInput(session,'dist',choices = c('Worldwide'))

        if (input$PRind %in% plants) # Station's value
            Id <- plantID(Id)
        print(Id)
        print(input$dist)
### Results distribution for AC report ###
        mRes <- unlist(subset(r,IndicatorCode==input$PRind & PeriodEndYrMn==input$PIRAqtr & NumOfMonths==input$PRwindow & NonQualCode == ' ',ResultsValue))
        if (input$dist == 'Worldwide')
            res <- mRes
        if (input$dist == 'Same reactor type' && !(input$PRind %in% plants))
            res <- unlist(subset(r,IndicatorCode==input$PRind & PeriodEndYrMn==input$PIRAqtr & NumOfMonths==input$PRwindow & NonQualCode == ' ' & LocId %in% uType$rType[[which(rTypeCode==rt)]],ResultsValue))
        if (input$dist == 'Same reactor type' && input$PRind %in% plants)
            res <- unlist(subset(r,IndicatorCode==input$PRind & PeriodEndYrMn==input$PIRAqtr & NumOfMonths==input$PRwindow & NonQualCode == ' ' & LocId %in% unique(plantID(uType$rType[[which(rTypeCode==rt)]])),ResultsValue))
        if (input$dist == 'Same reactor type and RC' && !(input$PRind %in% plants))
            res <- unlist(subset(r,IndicatorCode==input$PRind & PeriodEndYrMn==input$PIRAqtr & NumOfMonths==input$PRwindow & NonQualCode == ' ' & LocId %in% uType$rType[[which(rTypeCode==rt)]] & LocId %in% unitsByCentre$uList[[which(centreCode==rc)]],ResultsValue))
        if (input$dist == 'Same reactor type and RC' && input$PRind %in% plants)
            res <- unlist(subset(r,IndicatorCode==input$PRind & PeriodEndYrMn==input$PIRAqtr & NumOfMonths==input$PRwindow & NonQualCode == ' ' & LocId %in% unique(plantID(uType$rType[[which(rTypeCode==rt)]])) & LocId %in% unique(plantID(unitsByCentre$uList[[which(centreCode==rc)]])),ResultsValue))
        print(paste('Length of res=',length(res)))
### Unit value ###
        x <- unlist(subset(r,LocId %in% Id & IndicatorCode==input$PRind & PeriodEndYrMn==input$PIRAqtr & NumOfMonths==input$PRwindow & NonQualCode == ' ',ResultsValue))
        print(x)
################################# Plot the histogram ###############################
### colors ###
        color <- c()
        for (t in c(1:8)) color <- rbind(color,c(runif(1,0,1),runif(1,0,1),runif(1,0,1)))
        t<- cbind(color,c(0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5))
        #print(color)
        #print(tcolor)
                                        #if (input$rStyle == 'ac'){

            hist(res, breaks=10, col = 'green', xlab = 'indicator value ranges',ylab = 'number of units',main = paste(input$PRind,input$dist,'values distribution and unit(s) result'))
            for (i in c(1:length(x))){
                points(x=x[i],y=0,pch=19,cex=3,col=rgb(t[i,1],t[i,2],t[i,3],t[i,4]))
                text(x=x[i],y=0,signif(x[i],2))
            }
            legend('topright',legend=input$PRname,text.col=rgb(color))
                                        #}
        ############################################################################
### Create a table in the PC style ###
        #if (input$rStyle == 'pc'){
            col <- c('Indicator','Top quartile','Median','Bottom quartile','Unit Id','PI-36 result','PI-18 result','Performance tendency','Units reporting','Top quartile','2nd quartile','3rd quartile','Bott.quartile','Bott.10%')
        pcResult <- list()
        mRes36 <- unlist(subset(r,IndicatorCode==input$PRind & PeriodEndYrMn==input$PIRAqtr & NumOfMonths==36 & NonQualCode == ' ',ResultsValue))
        if (input$dist == 'Worldwide')
            res36 <- mRes36
        if (input$dist == 'Same reactor type' && !(input$PRind %in% plants))
            res36 <- unlist(subset(r,IndicatorCode==input$PRind & PeriodEndYrMn==input$PIRAqtr & NumOfMonths==36 & NonQualCode == ' ' & LocId %in% uType$rType[[which(rTypeCode==rt)]],ResultsValue))
        if (input$dist == 'Same reactor type' && input$PRind %in% plants)
            res36 <- unlist(subset(r,IndicatorCode==input$PRind & PeriodEndYrMn==input$PIRAqtr & NumOfMonths==36 & NonQualCode == ' ' & LocId %in% unique(plantID(uType$rType[[which(rTypeCode==rt)]])),ResultsValue))
        if (input$dist == 'Same reactor type and RC' && !(input$PRind %in% plants))
            res36 <- unlist(subset(r,IndicatorCode==input$PRind & PeriodEndYrMn==input$PIRAqtr & NumOfMonths==36 & NonQualCode == ' ' & LocId %in% uType$rType[[which(rTypeCode==rt)]] & LocId %in% unitsByCentre$uList[[which(centreCode==rc)]],ResultsValue))
        if (input$dist == 'Same reactor type and RC' && input$PRind %in% plants)
            res36 <- unlist(subset(r,IndicatorCode==input$PRind & PeriodEndYrMn==input$PIRAqtr & NumOfMonths==36 & NonQualCode == ' ' & LocId %in% unique(plantID(uType$rType[[which(rTypeCode==rt)]])) & LocId %in% unique(plantID(unitsByCentre$uList[[which(centreCode==rc)]])),ResultsValue))
### tendency ###
            #xCur <- unlist(subset(r,LocId %in% Id & IndicatorCode==input$PRind & PeriodEndYrMn==input$PIRAqtr & NumOfMonths==input$PRwindow & NonQualCode == ' ',ResultsValue))
            x18 <- unlist(subset(r,LocId %in% Id & IndicatorCode==input$PRind & PeriodEndYrMn==input$PIRAqtr & NumOfMonths==18 & NonQualCode == ' ',ResultsValue))
            x36 <- unlist(subset(r,LocId %in% Id & IndicatorCode==input$PRind & PeriodEndYrMn==input$PIRAqtr & NumOfMonths==36 & NonQualCode == ' ',ResultsValue))
            print(paste('18/36 results are:',x18,x36))
            for (i in c(1:length(x36))){
                tendency <- tendency(input$PRind,x18[i],x36[i])
                print(tendency)
### Which quantile ###
                X <- "X"
                print(paste('Quantile:',quantile(res36)))
                Q <- quart(input$PRind,x36[i],res36)
### create table ###
                if (input$PRind=='UCF  ')
                    d <- c(input$PRind,signif(quantile(res36)[[4]],3),signif(quantile(res36)[[3]],3),signif(quantile(res36)[[2]],3),Id[i],signif(x36[[i]],3),signif(x18[[i]],3),tendency,length(res36),unlist(Q))
                else
                    d <- c(input$PRind,signif(quantile(res36)[[2]],3),signif(quantile(res36)[[3]],3),signif(quantile(res36)[[4]],3),Id[i],signif(x36[[i]],3),signif(x18[[i]],3),tendency,length(res36),unlist(Q))
                #print(d)
                pcResult <- rbind(pcResult,d)
            }
            colnames(pcResult) <- col
            print(pcResult)
        #}
    })

    output$acAll <- renderPlot(histAll())
    output$pc <- renderDataTable(histAll(),options=list(paging = FALSE,searching=FALSE))

### Create PC style downloadable report ###<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
    observeEvent(input$piraTable,{
        withProgress(message="Calculating...",value=0,
        {
            pcAll <- list()
            Id <- unique(unlist(subset(place,place$AbbrevLocName %in% input$PRname,LocId)))
            plants <- c('SP5  ','ISA1 ','ISA2 ','CISA1','CISA2','TISA2')
            rt <- unique(unlist(subset(uData,LocId %in% Id,NsssTypeId))) # Reactor type
            rc <- unique(unlist(subset(relation,relation$LocId %in% Id & relation$RelationId == 1 & as.Date(relation$EndDate) >= Sys.Date(), select=ParentLocId))) # Regional Centre
### Worldwide list ###
            for (indicator in c('CISA2','ISA2 ','CRE  ','CY   ','FLR  ','GRLF ','SP1  ','SP2  ','SP5  ','UA7  ','UCF  ','UCLF ','US7  ')){
                incProgress(1/16,detail = indicator)
                print(indicator)
                if (indicator %in% plants) # Station's value
                    Id <- plantID(Id)
                else
                    Id <- unique(unlist(subset(place,place$AbbrevLocName %in% input$PRname,LocId)))
### Results distribution ###
                mRes36 <- unlist(subset(r,IndicatorCode==indicator & PeriodEndYrMn==input$PIRAqtr & NumOfMonths==36 & NonQualCode == ' ',ResultsValue))
                if (input$dist == 'Worldwide')
                    res36 <- mRes36
                if (input$dist == 'Same reactor type' && !(indicator %in% plants))
                    res36 <- unlist(subset(r,IndicatorCode==indicator & PeriodEndYrMn==input$PIRAqtr & NumOfMonths==36 & NonQualCode == ' ' & LocId %in% uType$rType[[which(rTypeCode==rt)]],ResultsValue))
                if (input$dist == 'Same reactor type' && indicator %in% plants)
                    res36 <- unlist(subset(r,IndicatorCode==indicator & PeriodEndYrMn==input$PIRAqtr & NumOfMonths==36 & NonQualCode == ' ' & LocId %in% unique(plantID(uType$rType[[which(rTypeCode==rt)]])),ResultsValue))
                if (input$dist == 'Same reactor type and RC' && !(indicator %in% plants))
                    res36 <- unlist(subset(r,IndicatorCode==indicator & PeriodEndYrMn==input$PIRAqtr & NumOfMonths==36 & NonQualCode == ' ' & LocId %in% uType$rType[[which(rTypeCode==rt)]] & LocId %in% unitsByCentre$uList[[which(centreCode==rc)]],ResultsValue))
                if (input$dist == 'Same reactor type and RC' && indicator %in% plants)
                    res36 <- unlist(subset(r,IndicatorCode==indicator & PeriodEndYrMn==input$PIRAqtr & NumOfMonths==36 & NonQualCode == ' ' & LocId %in% unique(plantID(uType$rType[[which(rTypeCode==rt)]])) & LocId %in% unique(plantID(unitsByCentre$uList[[which(centreCode==rc)]])),ResultsValue))
### Current value(s) ###
                x36 <- unlist(subset(r,LocId %in% Id & IndicatorCode==indicator & PeriodEndYrMn==input$PIRAqtr & NumOfMonths==36 & NonQualCode == ' ',ResultsValue))
                x18 <- unlist(subset(r,LocId %in% Id & IndicatorCode==indicator & PeriodEndYrMn==input$PIRAqtr & NumOfMonths==18 & NonQualCode == ' ',ResultsValue))

### tendency ###
                                  #xOld <- unlist(subset(r,LocId %in% Id & IndicatorCode==indicator & PeriodEndYrMn==input$PIRAqtr & NumOfMonths==36 & NonQualCode == ' ',ResultsValue))
                for (i in c(1:length(x36))){
                    print(paste(indicator,'x36=',x36,'x18=',x18))
                    tendency <- tendency(indicator,x18[i],x36[i])
### Which quantile ###
                    X <- "X"
                    print(paste('Quantile:',quantile(res36),"Result:",res36))
                    Q <- quart(indicator,x36[i],res36)
### create table ###
                    if (indicator=='UCF  ')
                        d <- c(indicator,signif(quantile(res36)[[4]],3),signif(quantile(res36)[[3]],3),signif(quantile(res36)[[2]],3),i,signif(x36[[i]],3),signif(x18[[i]],3),tendency,length(res36),unlist(Q))
                    else
                        d <- c(indicator,signif(quantile(res36)[[2]],3),signif(quantile(res36)[[3]],3),signif(quantile(res36)[[4]],3),i,signif(x36[[i]],3),signif(x18[[i]],3),tendency,length(res36),unlist(Q))
                    print(d)
                    pcAll <- rbind(pcAll,d)
                }}
            col <- c('Indicator','Top quartile','Median','Bottom quartile','Unit No','PI-36 result','PI-18 result','Performance tendency','Units reporting','Top quartile','2nd quartile','3rd quartile','Bott.quartile','Bott.10%')
            colnames(pcAll) <- col
        })
        #print(pcAll)
        output$pcAll <- renderDataTable(pcAll,options=list(paging = FALSE,searching=FALSE))
        ### save to file ###
        if (input$piraDown){
            fn <- paste(trimws(input$PRname[[1]]),"_PIRA_",Sys.Date(),"_",input$dist,"_Report.csv", sep="")
            print(fn)
            write.csv(pcAll,fn)
        }
    })

    #output$pcAll <- renderDataTable(pcAll,options=list(paging = FALSE,searching=FALSE))

                                        #observeEvent(updateSelectInput(session,'dist',selected = input$dist))

########################################## Downloadable report in PC style ###################################
    output$PIRA <- downloadHandler(
        filename = function() {
            fn <- paste(trimws(input$PRname[[1]]),"_PIRA_",Sys.Date(),"_",input$dist,"_Report.csv", sep="")
            print(fn)
        },
        content = function(file){
            write.csv(pcAll(),file)
        }
        )

########################################## Scrams statistics #################################################
    scramsTable <- reactive({
        if (input$as && input$ms) eCode <- c('C1   ','C3   ')
        if (input$as && !input$ms) eCode <- c('C1   ')
        if (!input$as && input$ms) eCode <- c('C3   ')
        scramsTable <- scrams(input$scramYr,eCode)
    })

    output$scrams <- renderDataTable(scramsTable(),options=list(paging = FALSE,searching=FALSE))

    scramsPlot <- reactive({
        if (input$as && input$ms) eCode <- c('C1   ','C3   ')
        if (input$as && !input$ms) eCode <- c('C1   ')
        if (!input$as && input$ms) eCode <- c('C3   ')
        d <- scrams(input$scramYr,eCode)
        AS <- d$AScrams
        MS <- d$MScrams
        rT <- d$rType
        out <- rbind(AS,MS)

        barplot(out,names.arg=unlist(rT),legend = c('Auto scrams','Manual scrams'))
    })

    output$scramPlot <- renderPlot(scramsPlot())

### Words cloud ###
#    #library(tm)
    library(wordcloud)
##    library(memoise)

    #events <- readRDS('DBCopy/OE_Event.rds')
    #eByKey <- readRDS('DBCopy/OE_EventKeyword.rds')
    #dCause <- readRDS('DBCopy/OE_DirectCause.rds')

    word <- reactive({
        if (input$as && input$ms)  key <-  c(646,871)
        if (input$as && !input$ms) key <-  c(871)
        if (!input$as && input$ms) key <-  c(646)
        eByKey <- unlist(subset(eByKey,KeywordCode %in% key,EventCode)) # 646 means manual scram, 871 - AS
        e <- subset(event,event$EventCode %in% eByKey & as.Date(event$EventDate) >= as.Date(paste(input$scramYr,'-01-01',sep='')) & as.Date(event$EventDate) <= as.Date(paste(input$scramYr,'-12-31',sep='')))
                                        #print(length(unlist(events)))
        directCause <- unlist(subset(e,select=DirectCauseCode))
        directCause <- directCause[!is.na(directCause)]
        word <- c()
        for (i in directCause)
            word <- c(word,subset(dCause,DirectCauseCode == i,DirectCause))
        word <- unlist(word)
    })
    #print(word)
    #wordcloud_rep <- repeatable(wordcloud)
    output$words <- renderPlot({
        #v <- terms()
        wordcloud(unlist(word()), min.freq = input$freq, max.words=input$max,
                  colors=brewer.pal(8, "Dark2"),random.order=FALSE)
        #wordcloud(word(),random.order=FALSE)
    })

############################## QRR ##############################
    qrr <- eventReactive(input$calc,{
        qrr <- list()
        withProgress(message="Calculating...",value=0,
        {
            if (input$qrrind %in% c('CISA1','CISA2','ISA1 ','ISA2 ','SP5  ')) U <- activeStation(input$qrrqtr,'p')
            else U <- activeStation(input$qrrqtr)
            for (u in U){
            #for (u in c(1200:1300)){
                incProgress(1/length(U),detail = nameByID(u))
                for (e in elByInd[[input$qrrind]]){
                                        # Avg ffrom 2007
                    avg <- mean(subset(data,SourceId == u & YrMn %in% qtrs & ElementCode == e & RecStatus == ' ',ElementValue)[[1]])
                    last <- subset(data,SourceId == u & YrMn == input$qrrqtr & ElementCode == e & RecStatus == ' ',ElementValue)[[1]]
                    #print(last)
                    #print(c(u,input$qrrind,input$qrrqtr,e,avg,last,signif(last/avg,2)))
                    if (!is.na(avg) && !is.na(last) && length(last) && length (avg) && !is.na(last/avg) && last/avg >= input$qrrcoef){
                        q <- c(nameByID(u),input$qrrind,input$qrrqtr,elByCode(e),signif(avg,2),signif(last,2),signif(last/avg,2))
                        print(q)
                        qrr <- rbind(qrr,q)
                    }}}
        })
        #print(qrr)
        colnames(qrr) <- c('Unit','Indicator','Quarter','Element','Average (5 yrs)','Last value','Discrepancy, times')
        return(qrr)
    })
    output$qrrt <- renderDataTable(qrr(),options=list(paging = FALSE,searching=FALSE))

### Unit index ###
    UIdx <- reactive({
        uNo <- subset(place,place$AbbrevLocName %in% input$idxName)[[1]]
        r <- UIndex(uNo,input$idxQtr)
    })
    output$UIdx <- renderDataTable(UIdx(),options=list(paging = FALSE,searching=FALSE))
    #output$UIdx <- renderText(UIdx())


############################### The end #################################

})

