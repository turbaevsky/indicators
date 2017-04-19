library(shiny)
library(datasets)

setwd("c:/Users/volodymyr.turbaevsky/Desktop/programming/R/indicators")
#setwd('../../indicators')

### Quarters list ###
curY <- as.numeric(format(Sys.Date(),"%Y"))
curM <- as.numeric(format(Sys.Date(),"%m"))

if (curM>=3 && curM<6) lastM <- '03'
if (curM>=6 && curM<9) lastM <- '06'
if (curM>=9 && curM<12) lastM <- '09'
if (curM==12) lastM <- '12'
if (curM<3) {lastM <- '12'; curY <- curY-1}

lastQtr <- paste(curY,lastM,sep='')
qtrs <- c(lastQtr)

for (i in c(1:30)){
    lastQ <- tail(qtrs,1)
    if (substr(lastQ,5,6)=='03') {Y <- as.numeric(substr(lastQ,1,4))-1; M <- 12; Q <- paste(Y,M,sep='')}
    else {M <- paste('0',as.numeric(substr(lastQ,5,6))-3,sep=''); Q <- paste(substr(lastQ,1,4),M,sep='')}
    qtrs <- c(qtrs,Q)
    }
qtrs <- sort(qtrs)

#qtrs <- c(201303,201306,201309,201312,
#          201403,201406,201409,201412,
#          201503,201506,201509,201512,
#          201603,201606,201609)

# Define server logic required to summarize and view the selected
# dataset
#--- from functions'r ---
placeAttributes <- readRDS('DBCopy/PI_PlaceAttribute.rds')
attrType <- readRDS('DBCopy/PI_PlaceAttributeTypeLookup.rds')
uDate <- readRDS('DBCopy/PI_UnitDate.rds')
uData <- readRDS('DBCopy/PI_UnitData.rds')
place <- readRDS('DBCopy/PI_Place.rds')
submit <- readRDS('DBCopy/PI_DataSubmittal.rds')
idx <- readRDS('DBCopy/PI_ResultsIndex.rds')
rTypes <- readRDS('DBCopy/PI_NsssTypeLookup.rds')
rSub <- readRDS('DBCopy/PI_NsssSubTypeLookup.rds')
###
data <- readRDS('DBCopy/PI_IndValues.rds') #Source  data
data <- subset(data, YrMn>=200700)

relation <- readRDS('DBCopy/PI_PlaceRelationship.rds')
relType <- readRDS('DBCopy/PI_PlaceRelationshipLookup.rds')
#dataStatus <- readRDS('DBCopy/PI_DataStatus.rds')
r <- readRDS('DBCopy/PI_Results.rds')
r <- subset(r,PeriodEndYrMn>=200700)

dates <- uDate
stat <- readRDS('DBCopy/PI_UnitDateTypeLookup.rds')
comms <- readRDS('DBCopy/PI_IndComments.rds')
dateType <- readRDS('DBCopy/PI_UnitDateTypeLookup.rds')
elem <- readRDS('DBCopy/PI_LabelCodes.rds')
effDate <- readRDS('DBCopy/PI_IndEffectiveDatedValues.rds')
cycle <- readRDS('DBCopy/PI_ResultsIndexCycleMns.rds')

dbcopy <- readRDS('DBCopy/PI_DataStatus.rds')

units <- readRDS('DBCopy/CORE_Unit.rds') # Look at OEDBID there; IAEARef and INPORef looks useful as well
eCode <- readRDS('DBCopy/OE_EventUnit.rds')
rCode <- readRDS('DBCopy/OE_EventReport.rds')
event <- readRDS('DBCopy/OE_Event.rds')
eByKey <- readRDS('DBCopy/OE_EventKeyword.rds')
dCause <- readRDS('DBCopy/OE_DirectCause.rds')


source('functions.r')
source('fullDBCopy.R')
source('Qreport.r')
source('xlsGenerator.R')
source('metrics.r')
source('submit.r')
source('indicators.R')
source('scrams.r')
source('tisa2.r')
source('index.r')

#qtrs <- sort(unique(unlist(subset(data,select=YrMn)))) # not sure if it is OK <<<<<<<

units <- activeStation(tail(qtrs,1)) ##################### Change to Sys.Date() but in the format YYYYMM
#units <- unique(unlist(subset(uData,select=LocId))) # show all units in the DB

uNames <- sort(as.character(subset(place,place$LocId %in% units,AbbrevLocName)[[1]]))

plants <- unique(unlist(subset(place,place$PlaceTypeId == 22,LocId)))
allNames <- sort(as.character(subset(place,place$LocId %in% plants,AbbrevLocName)[[1]]))
### List of indicators ###
i <- readRDS('DBCopy/PI_IndicatorCodes.rds')
i <- as.character(subset(i,i$IsActive==1,IndicatorCode)[[1]])
i <- c(i,"TISA2")

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


descriptions <- list('CISA1' = 'Contractor Industrial Safety Accident Rate',
              'ISA1 ' = 'Industrial Safety Accident Rate',
              'CISA2' = 'Contractor Industrial Safety Accident Rate',
              'TISA2' = 'Total Industrial Safety Accident Rate',
              'ISA2 ' = 'Industrial Safety Accident Rate',
              'UA7  ' = 'Unplanned Automatic Scrams Per 7,000 Hours Critical',
              'UCF  ' = 'Unit Capability Factor',
              'UCLF ' = 'Unplanned Capability Loss Factor',
              'FLR  ' = 'Forced Loss Rate',
              'CY   ' = 'Chemistry Performance',
              'FRI  ' = 'Fuel Reliability',
              'GRLF ' = 'Grid-Related Loss Factor',
              'SP1  ' = 'Safety System Performance \n(high pressure safety injection system)\n(high pressure injection/heat removal system)',
              'SP2  ' = 'Safety System Performance \n(auxiliary feedwater system)\n(residual heat removal system)',
              'SP5  ' = 'Safety System Performance \n(emergensy [diesel] generations)',
              'CRE  ' = 'Collective Radiation Exposure',
              'US7  ' = 'Unplanned Scrams Per 7,000 Hours Critical'
              )

### Individual targets 2020 ###
hidList <- list('CISA2' = 0.5,
            'ISA2 ' = 0.5,
            'TISA2' = 0.5,
            'FLR  ' = 5,
            'SP1  ' = 0.02,
            'SP2  ' = 0.02,
            'SP5  ' = 0.025,
            'CRE  ' = list('PWR' = 90, 'BWR' = 180)
            )
hisList <- list('CISA2' = 0.2,
            'ISA2 ' = 0.2,
            'TISA2' = 0.2,
            'FLR  ' = 2,
            'SP1  ' = 0.02,
            'SP2  ' = 0.02,
            'SP5  ' = 0.025,
            'CRE  ' = list('PWR' = 70, 'BWR' = 125)
            )
country = list('All' = c(1:100),
               'Argentina' = 3,
               'Australia' = 4,
               'Austria' = 5,
               'Belgium' = 7,
               'Brasil' = 9,
               'Armenia' = 10,
               'Bulgaria' = 11,
               'Canada' = 13,
               'China' = 14,
               'Czech' = 15,
               'Cuba' = 16,
               'Finland' = 21,
               'France' = 23,
               'Hungary' = 25,
               'India' = 27,
               'Unknown' = c(31,74,78),
               'Japan' = 33,
               'Korea' = 35,
               'Mexico' = 41,
               'Netherlands' = 43,
               'Pakistan' = 45,
               'Philipines' = 47,
               'Poland' = 49,
               'USA' = 50,
               'Romania' = 51,
               'South Africa' = 53,
               'Spain' = 55,
               'Sweden' = 57,
               'Switzerland' = 59,
               'Taiwan' = 61,
               'UK' = 65,
               'Litvania' = 66,
               'Russia' = 67,
               'Ukraine' = 68,
               'Germany' = 69,
               'Slovenia' = 71,
               'Slovakia' = 73,
               'Kazakhstan' = 76,
               'Iran' = 77,
               'UAE' = 79)

