library(shiny)
library(datasets)

setwd("c:/Users/volodymyr.turbaevsky/Desktop/programming/R/indicators")

qtrs <- c(201303,201306,201309,201312,
          201403,201406,201409,201412,
          201503,201506,201509,201512,
          201603,201606)

# Define server logic required to summarize and view the selected
# dataset
#--- from functions'r ---
placeAttributes <- readRDS('DBCopy/PI_PlaceAttribute.rds')
uDate <- readRDS('DBCopy/PI_UnitDate.rds')
uData <- readRDS('DBCopy/PI_UnitData.rds')
place <- readRDS('DBCopy/PI_Place.rds')
submit <- readRDS('DBCopy/PI_DataSubmittal.rds')
###
data <- readRDS('DBCopy/PI_IndValues.rds') #Source  data
relation <- readRDS('DBCopy/PI_PlaceRelationship.rds')
#dataStatus <- readRDS('DBCopy/PI_DataStatus.rds')
r <- readRDS('DBCopy/PI_Results.rds')
dates <- uDate
stat <- readRDS('DBCopy/PI_UnitDateTypeLookup.rds')
comms <- readRDS('DBCopy/PI_IndComments.rds')
dateType <- readRDS('DBCopy/PI_UnitDateTypeLookup.rds')
elem <- readRDS('DBCopy/PI_LabelCodes.rds')

dbcopy <- readRDS('DBCopy/PI_DataStatus.rds')

units <- readRDS('DBCopy/CORE_Unit.rds') # Look at OEDBID there; IAEARef and INPORef looks useful as well
eCode <- readRDS('DBCopy/OE_EventUnit.rds')
rCode <- readRDS('DBCopy/OE_EventReport.rds')
event <- readRDS('DBCopy/OE_Event.rds')


source('functions.r')
source('fullDBCopy.R')
source('Qreport.r')
source('xlsGenerator.R')
source('metrics.r')

#qtrs <- sort(unique(unlist(subset(data,select=YrMn)))) # not sure if it is OK <<<<<<<

units <- activeStation(tail(qtrs,1)) ##################### Change to Sys.Date() but in the format YYYYMM
#units <- unique(unlist(subset(uData,select=LocId))) # show all units in the DB

uNames <- sort(as.character(subset(place,place$LocId %in% units,AbbrevLocName)[[1]]))
i <- readRDS('DBCopy/PI_IndicatorCodes.rds')
i <- as.character(subset(i,i$IsActive==1,IndicatorCode)[[1]])

#data <- readRDS('DBCopy/PI_IndValues.rds') #Source  data

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


