#######################################################################
# This module combine PI and OE DB and provide more comprehensive
# information about events and unit status
#######################################################################

source('functions.r')

units <- readRDS('DBCopy/CORE_Unit.rds') # Look at OEDBID there; IAEARef and INPORef looks useful as well
eCode <- readRDS('DBCopy/OE_EventUnit.rds')
rCode <- readRDS('DBCopy/OE_EventReport.rds')
event <- readRDS('DBCopy/OE_Event.rds')

uNo<-as.numeric(readline('Enter PI DBunit ID:'))
qtr<-as.numeric(readline('Enter the last quarter you are interested in format YYYYMM'))
mns<-as.numeric(readline('Enter the data window (in months) you are interested:'))

lastDate <- dateToReal(qtr,'e')
startDate <- lastDate-31*mns

print(paste(startDate,lastDate))

oeid <- unlist(subset(units,units$INPORef==uNo,OEDBID))[1]
eventCodes <- unlist(subset(eCode,eCode$UnitCode==oeid,EventCode)) # list of events for selected unit
repCodes <- unlist(subset(rCode,rCode$EventCode %in% eventCodes,ReportCode))
events <- subset(event, event$EventCode %in% eventCodes & as.Date(event$EventDate)<=lastDate & as.Date(event$EventDate)>=startDate,c(EventDate, EventTitle))
print(events)

