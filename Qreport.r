##################################################################################################
#  This is report generator to produce Long-Term Target Performance Table
#  to replace the existing one at http://www.wano.org/xwp10webapp/reports/TableReport.pdf?x=774741
#  To generate pdf report the Sweave('QReport.rnw') command should be ran
##################################################################################################

source('functions.r')

if (readline('Need you update the Db copy (Y/n)?')=='Y')
{
source('fullDBCopy.R')
#print('DB copying...')
DBCopy()	# Provide the last DB copy
}

#dateRange <- c(200712,200812,200912,201012,201112,201212,201312,201412,201512,201603)
dateRange <- c(201606)

if (readline('Need you update all TISA calculation (Y/n)?')=='Y')
{
source('tisa2.r')
print('TISA2 calculation...')
for (d in dateRange)
	{
	tisa2(d)	# Provide the last date for analysis
	}
}

#placeAttributes <- readRDS('DBCopy/PI_PlaceAttribute.rds')
r <- readRDS('DBCopy/PI_Results.rds')
place <- readRDS('DBCopy/PI_Place.rds')
relation <- readRDS('DBCopy/PI_PlaceRelationship.rds')
ic <- readRDS('DBCopy/PI_IndicatorCodes.rds')
ic <- t(subset(ic,ic$IsActive== 1)[1])
UnitData <- uData

# List of reactor by type
rType <- c('AGR','BWR','LWCGR','PHWR','PWR','FBR')
rTypeCode <- c(1,3,12,13,14,4)
# 2020-LTT by reactor types
creIdTg <- c(10,180,320,200,90)
creIsTg <- c(5,125,240,115,70)
us7IdTg <- c(2,1,1,1.5,1)
us7IsTg <- c(1,0.5,0.5,1,0.5)
# Other 2020-LTT
hid <- function(i)
	{return(switch(
		i,
		'CISA2' = 0.5,
		'ISA2 ' = 0.5,
		'TISA2' = 0.5,
		'FLR  ' = 5,
		'SP1  ' = 0.02,
		'SP2  ' = 0.02,
		'SP5  ' = 0.025
		))
	}
his <- function(i)
	{return(switch(
		i,
		'CISA2' = 0.2,
		'ISA2 ' = 0.2,
		'TISA2' = 0.2,
		'FLR  ' = 2,
		'SP1  ' = 0.02,
		'SP2  ' = 0.02,
		'SP5  ' = 0.025
		))
	}
# Units by reactor type
uType <- list()
for (t in c(1:6))
	{ uType$rType[t] <- subset(UnitData,NsssTypeId == rTypeCode[t],select = 1)}
# Units by centre
centreCode <- c(1155,1158,1156,1159)	#AC,MC,PC,TC
centreNames <- c('AC','MC','PC','TC')
unitsByCentre <- list()
for (centre in c(1:4))
	{ unitsByCentre$uList[centre] <- unique(subset(relation,relation$ParentLocId == centreCode[centre]
		& relation$RelationId == 1 & as.Date(relation$EndDate) >= Sys.Date(), select=LocId)) }

# Reactor type related calculations ==================================================================
rTypeResults <- function(centre,i,lastDate)
	{
	lowerId <- c()
	lowerIs <- c()
	uNum <- c()
	for (type in c(1:5))	# By reactor type, FBR is excluded <================================
		{
		if (i == 'CRE')	{ind <- 'CRE  '; IdLimit <- creIdTg[type]; IsLimit <- creIsTg[type]}
		if (i == 'US7')	{ind <- 'US7  '; IdLimit <- us7IdTg[type]; IsLimit <- us7IsTg[type]}

		# Units lower the limits
		# Individual
		lowerId <- c(lowerId,length(unlist(subset(r,r$IndicatorCode==ind & r$PeriodEndYrMn == lastDate
			& r$NumOfMonths == 36 & r$NonQualCode == ' ' & r$LocId %in% unlist(uType$rType[type])
			& r$LocId %in% unlist(unitsByCentre$uList[centre]) & r$ResultsValue <= IdLimit & r$LocId %in% activeStation(lastDate),LocId))))
		lowerIs <- c(lowerIs,length(unlist(subset(r,r$IndicatorCode==ind & r$PeriodEndYrMn == lastDate
			& r$NumOfMonths == 36 & r$NonQualCode == ' ' & r$LocId %in% unlist(uType$rType[type])
			& r$LocId %in% unlist(unitsByCentre$uList[centre]) & r$ResultsValue <= IsLimit & r$LocId %in% activeStation(lastDate),LocId))))
                #upperIs <- subset(r,r$IndicatorCode==ind & r$PeriodEndYrMn == lastDate
                #& r$NumOfMonths == 36 & r$NonQualCode == ' ' & r$LocId %in% unlist(uType$rType[type])
		#& r$LocId %in% unlist(unitsByCentre$uList[centre]) & r$ResultsValue > IsLimit,LocId)
                # Test
                #print(c(centreName[centre],i,upperIs))

		# Num of units
		uNum <- c(uNum,length(unlist(subset(r,r$IndicatorCode==ind & r$PeriodEndYrMn == lastDate
			& r$NumOfMonths == 36 & r$NonQualCode == ' ' & r$LocId %in% unlist(uType$rType[type])
			& r$LocId %in% unlist(unitsByCentre$uList[centre]) & r$ResultsValue >=0 & r$LocId %in% activeStation(lastDate) ,LocId))))
		}
	Id <- round(sum(lowerId)/sum(uNum)*100,1)
	Is <- round(sum(lowerIs)/sum(uNum)*100,1)
	data.local <- list(as.character(centreNames[centre]),as.character(i),as.numeric(Id),
                           as.numeric(Is),as.integer(sum(lowerId)),as.integer(sum(lowerIs)),as.integer(sum(uNum)))
        #print (data.local)
	return(data.local)
	}

# Calculate statistics by centre ==========================================================================
# Key indicator list
indicators <- c('FLR','CRE','TISA','US7','SSPI')

for (lastDate in dateRange)
{
fn <- paste('csv/TISA_',lastDate,'.csv',sep='')
tisa <- read.csv(fn)
print(lastDate)
pb <- txtProgressBar(min = 0, max = length(indicators)*4, style = 3)
count <- 0
d <- data.frame(stringsAsFactors=FALSE)
for (centre in c(1:4))	# By centre
	{
	for (i in indicators)
		{
		count <- count + 1
		#Initialisation
		#lowerId <- 0; lowerIs <- 0; uNum <- 0; Id <- 0; Is <- 0
		#Calculation
		if (i %in% c('CRE','US7')) {d <- rbind(d,t(rTypeResults(centre,i,lastDate)))}
		if (i == 'TISA')
			{
			lowerId <- length(unlist(subset(tisa,tisa$LocID %in% unlist(unitsByCentre$uList[centre]) &
			tisa$X3.Yr.TISA2 <= hid('TISA2'),LocID)))
			lowerIs <- length(unlist(subset(tisa,tisa$LocID %in% unlist(unitsByCentre$uList[centre]) &
                        tisa$X3.Yr.TISA2 <= his('TISA2'),LocID)))
                        # Double checking units out of range
                        #upperId <- length(unlist(subset(tisa,tisa$LocID %in% unlist(unitsByCentre$uList[centre]) &
			#tisa$X3.Yr.TISA2 > hid('TISA2'),LocID)))
                        ### Fixed uNum excluded NA values
			uNum <- length(unlist(subset(tisa,tisa$LocID %in% unlist(unitsByCentre$uList[centre]) & tisa$X3.Yr.TISA2>=0,LocID)))
			Id <- round(lowerId/uNum*100,1)
			Is <- round(lowerIs/uNum*100,1)
			d <- rbind(d,t(list(centreNames[centre],i,Id,Is,lowerId,lowerIs,uNum)))
                        # Test
                        #print(c(centreNames[centre],lowerId,upperId,uNum))
			}
		if (i == 'FLR')
			{
			ind <- 'FLR  '
			lowerId <- length(unlist(subset(r,r$IndicatorCode==ind & r$PeriodEndYrMn == lastDate
			& r$NumOfMonths == 36 & r$NonQualCode == ' ' & r$LocId %in% unlist(unitsByCentre$uList[centre])
			& r$ResultsValue <= hid(ind) & r$LocId %in% activeStation(lastDate),LocId)))
			lowerIs <- length(unlist(subset(r,r$IndicatorCode==ind & r$PeriodEndYrMn == lastDate
			& r$NumOfMonths == 36 & r$NonQualCode == ' ' & r$LocId %in% unlist(unitsByCentre$uList[centre])
			& r$ResultsValue <= his(ind) & r$LocId %in% activeStation(lastDate),LocId)))
			uNum <- length(unlist(subset(r,r$IndicatorCode==ind & r$PeriodEndYrMn == lastDate
                        & r$NumOfMonths == 36 & r$NonQualCode == ' ' & r$LocId %in% unlist(unitsByCentre$uList[centre])
                        & r$ResultsValue>=0 & r$LocId %in% activeStation(lastDate),LocId)))
			Id <- round(lowerId/uNum*100,1)
			Is <- round(lowerIs/uNum*100,1)
			d <- rbind(d,t(list(as.character(centreNames[centre]),as.character(i),Id,Is,lowerId,lowerIs,uNum)))
			}
		if (i == 'SSPI')
			{
			lowerId <- c()
			lowerId <- c(lowerId,length(unlist(subset(r,r$IndicatorCode=='SP1  ' & r$PeriodEndYrMn == lastDate
			& r$NumOfMonths == 36 & r$NonQualCode == ' ' & r$LocId %in% unlist(unitsByCentre$uList[centre])
			& r$ResultsValue <= hid('SP1  '),LocId))))
			lowerId <- c(lowerId,length(unlist(subset(r,r$IndicatorCode=='SP2  ' & r$PeriodEndYrMn == lastDate
			& r$NumOfMonths == 36 & r$NonQualCode == ' ' & r$LocId %in% unlist(unitsByCentre$uList[centre])
			& r$ResultsValue <= hid('SP2  '),LocId))))
			lowerId <- c(lowerId,length(unlist(subset(r,r$IndicatorCode=='SP5  ' & r$PeriodEndYrMn == lastDate
			& r$NumOfMonths == 36 & r$NonQualCode == ' ' & r$LocId %in% unlist(unitsByCentre$uList[centre])
			& r$ResultsValue <= hid('SP5  '),LocId))))
			uNum <- length(unlist(subset(r,r$IndicatorCode %in% c('SP1  ','SP2  ','SP5  ') & r$PeriodEndYrMn == lastDate & r$NumOfMonths == 36 & r$NonQualCode == ' '
			& r$LocId %in% unlist(unitsByCentre$uList[centre]) & r$ResultsValue >= 0 ,LocId)))
			Id <- round(sum(lowerId)/uNum*100,1)
			Is <- Id	# Check the calculation - is it really the same as individual or I have to combine unit's system together
			lowerIs <- sum(lowerId)
			d <- rbind(d,t(list(as.character(centreNames[centre]),as.character(i),Id,Is,sum(lowerId),lowerIs,uNum)))
			}
		setTxtProgressBar(pb, count)
		}
	}
colnames(d) <- c('Centre','Indicator','Ind.percentage','Indust.percentage','Units met Id','Units met Is','Qualified units')
# Worldwide status
w <- data.frame()
for (i in indicators)
	{
	Ud <- sum(unlist(subset(d,d$Indicator==i,'Units met Id')))
	Us <- sum(unlist(subset(d,d$Indicator==i,'Units met Is')))
	Un <- sum(unlist(subset(d,d$Indicator==i,'Qualified units')))
	Id <- round(Ud/Un*100,1)
	Is <- round(Us/Un*100,1)
	w <- rbind(w,t(list(as.character('WANO'),as.character(i),Id,Is,Ud,Us,Un)))
	}
colnames(w) <- c('Centre','Indicator','Ind.percentage','Indust.percentage','Units met Id','Units met Is','Qualified units')

saveRDS(w,paste('LTT/Worldwide_LTT_',lastDate,'.rds',sep=''))
saveRDS(d,paste('LTT/RCs_LTT_',lastDate,'.rds',sep=''))

close(pb)
#print(w)
#print(d)
}

#bot$sendMessage('QReport processing is completed')

