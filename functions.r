####################################################################
# This file contains the common for many other R files functions
####################################################################
placeAttributes <- readRDS('DBCopy/PI_PlaceAttribute.rds')
uDate <- readRDS('DBCopy/PI_UnitDate.rds')
uData <- readRDS('DBCopy/PI_UnitData.rds')

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
	if (mn==03)	{mn <- 'Q1'}
	if (mn==06)	{mn <- 'Q2'}
	if (mn==09)	{mn <- 'Q3'}
	if (mn==12)	{mn <- 'Q4'}
	return(paste(yr,mn,sep=''))
	}

dateToReal <- function(date,mode="b") # Convert the date likes 201512 to 2015-12-01, 'b' means beginning of reported quartale, 's' means date of data to be submitted, 'p' - date of data to be promoded, 'e' means the end of quartale (the first day of the next month)
	{
	yr <- as.numeric(substr(date,1,4))
	mn <- as.numeric(substr(date,5,6))
        if (mode == "b"){
	if (mn==3)	{mn <- 1} else {mn <- mn-2}
	Rdate <- as.character(as.Date(paste(yr,mn,'01'),"%Y %m %d"))
        }
        else if (mode == 'e'){
            if (mn==12) {mn<-1; yr<-yr+1} else {mn<-mn+1}
            Rdate <- as.Date(paste(yr,mn,'01'),"%Y %m %d")
            }
        else if (mode == 's' || mode == 'p')
        {
            if (mn<12) mn=mn+1 else {mn=1; yr=yr+1}
            if (mode  == 's') Rdate <- as.Date(paste(yr,mn,'01'),"%Y %m %d")+45
            else if (mode  == 'p') Rdate <- as.Date(paste(yr,mn,'01'),"%Y %m %d")+60
}
	return(Rdate)
	}


activeStation <- function(startDate,mode='u') # Getting active units list
# TODO: add additional checking for LTS station for all investigated period
                                        # Include Unit/Plant selector then change xlsGenerator and QReport files
# AttributeTypeId == 7 means Report PI Data, 22 means it is Unit, 19 means Plant; 15 means LocActive
{
    t <- c()
    if (mode == 'u') t <- c(22)
    else if (mode == 'p') t <- c(19)
    else if (mode == 'a') t <- c(19,22)
    # TODO: remove units with LTS status =================================================================
    Station <- merge(place,placeAttributes,by='LocId')
    list1 <- unlist(subset(Station,Station$PlaceTypeId %in% t
		& Station$AttributeTypeId == 7 & Station$EndDate >= dateToReal(startDate,'e')
		& (Station$StartDate <= dateToReal(startDate) | is.na(Station$StartDate))
                & IsDeleted == 0,LocId)) #List of units/plants wich is PI Reporter and is not deleted
    list2 <- unlist(subset(Station, Station$AttributeTypeId == 15 & Station$EndDate >= dateToReal(startDate,'e'),LocId)) # List of units/plants with LocActive status
    # List of units with [DateTypeId] Long-Term Shutdown Start (11) but not LTS End (9) status on [UnitDate]
    list3 <- unlist(subset(uDate,uDate$DateTypeId == 11 & uDate$UnitDate <= dateToReal(startDate),LocId))
    list4 <- unlist(subset(uDate,uDate$DateTypeId == 9 & uDate$UnitDate <= dateToReal(startDate),LocId))
    list5 <- unlist(subset(uData,uData$IsUnitActive == 1,LocId)) # has IsActive status
    LTS <- setdiff(list3,list4)
    Station <- intersect(intersect(list1,list2),list5)
    Station <- Station[!Station %in% LTS] # Remove LTS units
    Station <- Station[!Station %in% c(10117:10123,10212:10217)] # Remove reprocessing factories
    return(Station)
}
