####################################################################
# This file contains the common for many other R files functions
####################################################################
#setwd("c:/Users/volodymyr.turbaevsky/Desktop/programming/R/indicators")

ylab <- function(i)
{return(switch(
     i,
     'CISA1' = 'accident number per 1,000,000 wh',
     'ISA1 ' = 'accident number per 1,000,000 wh',
     'CISA2' = 'accident number per 200,000 wh',
     'TISA2' = 'accident number per 200,000 wh',
     'ISA2 ' = 'accident number per 200,000 wh',
     'UA7  ' = 'number per 7,000 critical hours',
     'UCF  ' = 'percent',
     'UCLF ' = 'percent',
     'FLR  ' = 'percent',
     'CY   ' = 'index',
     'FRI  ' = 'index',
     'GRLF ' = 'percent',
     'SP1  ' = 'unavailability',
     'SP2  ' = 'unavailability',
     'SP5  ' = 'index',
     'CRE  ' = 'man-rem',
     'US7  ' = 'number per 7,000 critical hours'
 ))}

bot <- function(msg) # Send a message to Telegram recipient(s)
{
    library(telegram)
    bot <- TGBot$new(token = '183104961:AAFOVTLmfQ0MDHdt2ZnLgtUZYkM_gbDFkLs')
    bot$set_default_chat_id(181982455)
    bot$sendMessage(msg)
}

secToTime <- function(eta)
	{
	eta.h <- floor(eta/3600)
	eta.m <- floor((eta-eta.h*3600)/60)
	eta.s <- floor(eta-eta.h*3600-eta.m*60)
	return(paste(eta.h,':',eta.m,':',eta.s,sep=''))
	}

dateToQ <- function(date)
	{
	yr <- substr(date,1,4)
	mn <- substr(date,5,6)
	if (mn=='03')	{m <- 'Q1'}
	if (mn=='06')	{m <- 'Q2'}
	if (mn=='09')	{m <- 'Q3'}
	if (mn=='12')	{m <- 'Q4'}
	return(paste(yr,m,sep=''))
	}

dateToReal <- function(date,mode="b") # Convert the date likes 201512 to 2015-12-01, 'b' means beginning of reported quartale, 's' means date of data to be submitted, 'p' - date of data to be promoded, 'e' means the end of quartale (the first day of the next month)
	{
	yr <- as.numeric(substr(date,1,4))
	mn <- as.numeric(substr(date,5,6))
        if (mode == "b"){
	if (mn==3)	{mn <- 1} else {mn <- mn-2}
	Rdate <- as.Date(paste(yr,mn,'01'),"%Y %m %d")
        }
        else if (mode == 'e'){
            if (mn==12) {mn<-1; yr<-yr+1} else {mn<-mn+1}
            Rdate <- as.Date(paste(yr,mn,'01'),"%Y %m %d")
            }
        else if (mode == 's' || mode == 'p')
        {
            if (mn<12) mn=mn+1 else {mn=1; yr=yr+1}
            if (mode  == 's') Rdate <- as.Date(paste(yr,mn,'01'),"%Y %m %d")+46
            else if (mode  == 'p') Rdate <- as.Date(paste(yr,mn,'01'),"%Y %m %d")+61
}
	return(Rdate)
	}


activeStation <- function(startDate,mode='u') # Getting active units list
# TODO: add additional checking for LTS station for all investigated period
                                        # Include Unit/Plant selector then change xlsGenerator and QReport files
# AttributeTypeId == 7 means Report PI Data, 22 means it is Unit, 19 means Plant; 15 means LocActive
{
    t <- c()
    if (mode == 'u'){
        t <- 22
        Station <- merge(place,placeAttributes,by='LocId')
        list1 <- unlist(subset(Station,Station$PlaceTypeId %in% t
                               & Station$AttributeTypeId == 7 & as.Date(Station$EndDate) >= dateToReal(startDate,'e')
                               & (as.Date(Station$StartDate) <= dateToReal(startDate) | is.na(Station$StartDate))
                               & IsDeleted == 0,LocId)) #List of units/plants wich is PI Reporter and is not deleted
        list2 <- unlist(subset(Station, Station$AttributeTypeId == 15 & as.Date(Station$EndDate) >= dateToReal(startDate,'e'),LocId)) # List of units/plants with LocActive status
                                        # List of units with [DateTypeId] Long-Term Shutdown Start (11) but not LTS End (9) status on [UnitDate]
        list3 <- unlist(subset(uDate,uDate$DateTypeId == 11 & as.Date(uDate$UnitDate) <= dateToReal(startDate),LocId))
        list4 <- unlist(subset(uDate,uDate$DateTypeId == 9 & as.Date(uDate$UnitDate) <= dateToReal(startDate),LocId))
        list5 <- unlist(subset(uData,uData$IsUnitActive == 1,LocId)) # has IsActive status
        LTS <- setdiff(list3,list4)
        Station <- intersect(intersect(list1,list2),list5)
        ### Commercial service started in previous quarter ###
        list6 <- unlist(subset(uDate,uDate$DateTypeId == 4 & as.Date(uDate$UnitDate) <= dateToReal(startDate),LocId))
        Station <- intersect(Station,list6)
        Station <- Station[!Station %in% LTS] # Remove LTS units
        Station <- Station[!Station %in% c(10117:10123,10212:10217)] # Remove reprocessing factories
                                        #Station <- c(Station,10213) # Add La Hague
    }
    if (mode=='p'){
        Station <- merge(place,placeAttributes,by='LocId')
        Station <- unique(unlist(subset(Station,PlaceTypeId == 19 & AttributeTypeId == 15 & as.Date(EndDate) >= as.Date('2100-01-01'),LocId)))# & AttributeTypeId == 7
                                 #& EndDate >= dateToReal(startDate)
                                 #& (StartDate <= dateToReal(startDate) | is.na(StartDate))
                                 #& IsDeleted == 0, LocId))
        #INPOStation <- intersect(unlist(subset(place,place$CountryId==50, LocId)),unlist(Station)) # US plants
    }
    if (mode=='a'){
        Station <- c(activeStation(startDate,'u'),activeStation(startDate,'p'))}
    return(Station)
}

### Units by centre ==================================
        centreCode <- c(1155,1158,1156,1159)	#AC,MC,PC,TC
        centreNames <- c('WANO:AC','WANO:MC','WANO:PC','WANO:TC')
uByCentre <- function()
    {
        unitsByCentre <- list()
        for (centre in c(1:4))
        {unitsByCentre$uList[centre] <- unique(subset(relation,relation$ParentLocId == centreCode[centre] & relation$RelationId == 1 & relation$EndDate >= '9999-01-01', select=c(LocId)))}
        return(unitsByCentre)
    }
### Units by reactor type ==================================
rType <- c('AGR','BWR','LWCGR','PHWR','PWR')
rTypeCode <- c(1,3,12,13,14)
uByType <- function(){
uType <- list()
for (t in c(1:5)){
    uType$rType[t] <- subset(UnitData,NsssTypeId == rTypeCode[t],select = 1)
}
return(uType)
}
### PLant Id by Unit Id(s) ###
plantID <- function(uID){
    return(unique(unlist(subset(relation,relation$LocId %in% uID
                               & relation$RelationId == 4
                               & as.Date(relation$EndDate) >= Sys.Date(),
                               select=ParentLocId))))
}

### Name by ID
nameByID <- function(ID) return(as.character(subset(place,LocId %in% ID,AbbrevLocName)[[1]]))
### Elem by code
elByCode <- function(code) return(as.character(subset(elem,LabelCode==code,LabelText)[[1]]))

### Tendency for PC-style report
tendency <- function(indicator,x18,x36){
    try({
    if (indicator!='UCF  '){
        if (x18==x36) tendency <- '0'
        if (x18<x36*0.7) tendency <- '++'
        if (x18>x36*0.7 && x18<=x36) tendency <- '+'
        if (x18>x36 && x18<=x36*1.3) tendency <- '-'
        if (x18>x36*1.3) tendency <- '--'
        }
    else {
        if (x18==x36) tendency <- '0'
        if (x18>x36*1.3) tendency <- '++'
        if (x18<x36*1.3 && x18>=x36) tendency <- '+'
        if (x18<x36 && x18>=x36*0.7) tendency <- '-'
        if (x18<x36*0.7) tendency <- '--'
    }
    })
    return(tendency)
}

### Quartile info for PC-style report
quart <- function(indicator,x,res){

    X <- "X"
    try({
        if (indicator!='UCF  '){
            if (x>=quantile(res)[[1]] && x<=quantile(res)[[2]]) Q <- c(X,'','','','')
            if (x>quantile(res)[[2]] && x<=quantile(res)[[3]]) Q <- c('',X,'','','')
            if (x>quantile(res)[[3]] && x<=quantile(res)[[4]]) Q <- c('','',X,'','')
            if (x>quantile(res)[[4]] && x<=quantile(res)[[5]]) Q <- c('','','',X,'')
            if (x>=quantile(res,probs=seq(0,1,0.1))[[9]] && x!=0) Q <- c('','','',X,X)
        }
        else {
            if (x<=quantile(res)[[5]] && x>quantile(res)[[4]]) Q <- c(X,'','','','')
            if (x<=quantile(res)[[4]] && x>quantile(res)[[3]]) Q <- c('',X,'','','')
            if (x<=quantile(res)[[3]] && x>quantile(res)[[2]]) Q <- c('','',X,'','')
            if (x<=quantile(res)[[2]] && x>quantile(res)[[1]]) Q <- c('','','',X,'')
            if (x<=quantile(res,probs=seq(0,1,0.1))[[2]]) Q <- c('','','',X,X)
        }
        })
    return(Q)
    }


plt <- function(i,safety=FALSE,us7=FALSE,group='ReactorType',col=TRUE){
    if (us7 & i=='US7'){
        f <- subset(dd,Indicator==i & as.numeric(as.character(date))>=2013)
                                        #loginfo('us7')
    }
    else
        f <- subset(dd,Indicator==i)
    fn <- paste(i,'_',group,'.png',sep='')
    plt <- ggplot(f)
    if (group=='ReactorType')
        plt <- plt + geom_line(aes(x=date,y=unlist(percentage),group=unlist(ReactorType),color=unlist(ReactorType)))
    else if (group=='Centre')
        plt <- plt + geom_line(aes(x=date,y=unlist(percentage),group=unlist(Centre),color=unlist(Centre)))

    if (!safety){
        plt <- plt +
            #geom_line(aes(x=date,y=unlist(percentage),group=unlist(ReactorType),color=unlist(ReactorType)))+
            theme(legend.title=element_blank())+
            geom_hline(data=idsPerc,aes(yintercept=75,color='Industry objective'))+
            geom_hline(data=indPerc,aes(yintercept=100,color='Individual objective'))+
            facet_grid(param~.)+
            ggtitle(paste(i,'performance'))+
            scale_y_continuous(name="Percentage of units that met target")+
            scale_x_discrete(name="Year")
        if ((i=='FLR' || i=='TISA')&& col) plt <- plt+scale_color_manual(values=c("#FF0033","#FFCC00","#CC33CC"))
        else if (col)  plt <- plt+scale_color_manual(values=c("#FF0033","#FFCC00","#FF9900","#FF3300","#33FF00","#330099","#996633","#CC33CC"))
        ggsave(fn)
}
    else if (safety){
        plt <- plt +
            theme(legend.title=element_blank())+
            geom_hline(data=idsPerc,aes(yintercept=100,color='Industry objective'))+
            geom_hline(data=indPerc,aes(yintercept=100,color='Individual objective'))+
            facet_grid(param~.)+
            ggtitle(paste(i,'performance'))+
            scale_y_continuous(name="Percentage of units that met target")+
            scale_x_discrete(name="Year")
        if (col)
            plt <- plt+scale_color_manual(values=c("#FF0033","#FFCC00","#FF9900","#FF3300","#996633","#CC33CC"))
        ggsave(fn)
    }
    return(plt)
}


### Create a list of months for predefined period ###
monthsList <- function(start,duration){
    start <- as.numeric(start)
    duration <- as.numeric(duration)
    #print(paste(start,duration))
    d <- c(start)
    while (duration>1){
        n <- tail(d,1)-1
        #print(paste(d/100,d%/%100))
        if ((n/100)==(n%/%100)){
            yr <- as.numeric(substr(n,1,4))-1
            mn <- 12
            n <- as.numeric(paste(yr,mn,sep=''))
            d <- c(d,n)
            #print(paste(n,d))
        }
        else d <- c(d,n)
        duration <- duration - 1
    }
    #print(d)
    return(d)
}
