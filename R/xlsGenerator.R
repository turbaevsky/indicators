#source('functions.r')

#dataStatus <- readRDS('DBCopy/PI_DataStatus.rds')
#print(dataStatus)

#if (readline('Need you update the Db copy (Y/n)?')=='Y')
#{
#source('fullDBCopy.R')
##print('DB copying...')
#DBCopy()	# Provide the last Db copy
##bot$sendMessage('DB has been updated')
#dataStatus <- readRDS('DBCopy/PI_DataStatus.rds')
#print(dataStatus)
#}

#dateRange <- c(201412,201512,201606)
# 2-years in depth dates from the last one ###################################################
                                        #analisedDate <- c(201412,201512,201606)	# Next - 2014Q4,2015Q4 and 2016Q1

xls <- function(analisedDate,Tisa=TRUE,session=TRUE)
    {
                                        #analisedDate <- 201606
        tisa2(analisedDate,session=session)
        dateRange <- analisedDate


#if (readline('Need you update all TISA calculation (Y/n)?')=='Y')
#{
#source('tisa2.r')
#print('TISA2 calculation...')
#for (d in dateRange)
#	{
#	tisa2(d)	# Provide the last date for analysis
#	}
#}

#place <- readRDS('DBCopy/PI_Place.rds')
##placeAttributes <- readRDS('DBCopy/PI_PlaceAttribute.rds')
results <- r
#relation <- readRDS('DBCopy/PI_PlaceRelationship.rds')
##uData <- readRDS('DBCopy/PI_UnitData.rds')
rTypes <- readRDS('DBCopy/PI_NsssTypeLookup.rds')
CYGroups <- readRDS('DBCopy/PI_CategoryGroupUnits.rds')
##uDate <- readRDS('DBCopy/PI_UnitDate.rds')
uCycle <- readRDS('DBCopy/PI_ResultsIndexCycleMns.rds')

#place <- data.frame(lapply(place, as.character), stringsAsFactors=FALSE)

fields <- c('CENTRE','MEMBER','UNIT NAME','REACTOR TYPE','Chemistry Group Code',
              'NSSS VENDOR','MWe RATING','Commercial Operation DATE',
              'Nominal Operating Cycle Months','1-Yr UCF','1-Yr UCF Data Code',
              '18-Mo UCF','18-Mo UCF Data Code','2-Yr UCF','2-Yr UCF Data Code',
              '3-Yr UCF','3-Yr UCF Data Code','1-Yr UCL','1-Yr UCL Data Code',
              '18-Mo UCL','18-Mo UCL Data Code','2-Yr UCL','2-Yr UCL Data Code',
              '3-Yr UCL','3-Yr UCL Data Code','1-Yr FLR','1-Yr FLR Data Code',
              '18-Mo FLR','18-Mo FLR Data Code','2-Yr FLR','2-Yr FLR Data Code',
              '3-Yr FLR','3-Yr FLR Data Code','1-Yr UA7','1-Yr UA7 Data Code',
              '18-Mo UA7','18-Mo UA7 Data Code','2-Yr UA7','2-Yr UA7 Data Code',
              '3-Yr UA7','3-Yr UA7 Data Code','1-Yr SP1','1-Yr SP1 Data Code',
              '18-Mo SP1','18-Mo SP1 Data Code','2-Yr SP1','2-Yr SP1 Data Code',
              '3-Yr SP1','3-Yr SP1 Data Code','1-Yr SP2','1-Yr SP2 Data Code',
              '18-Mo SP2','18-Mo SP2 Data Code','2-Yr SP2','2-Yr SP2 Data Code',
              '3-Yr SP2','3-Yr SP2 Data Code','1-Yr SP5','1-Yr SP5 Data Code',
              '18-Mo SP5','18-Mo SP5 Data Code','2-Yr SP5','2-Yr SP5 Data Code',
              '3-Yr SP5','3-Yr SP5 Data Code','Most Recent Operating Quarter FRI (Microcuries)',
              'Most Recent Operating Quarter FRI (Becquerels)','*FRI (No Units of Measure)',
              'FRI Data Code','1-Yr CPI','1-Yr CPI Data Code','18-Mo CPI','18-Mo CPI Data Code',
              '2-Yr CPI','2-Yr CPI Data Code','3-Yr CPI','3-Yr CPI Data Code','1-Yr CRE (Man-Rem)',
              '1-Yr CRE (Man-Sieverts)','1-Yr CRE Data Code','18-Mo CRE (Man-Rem)',
              '18-Mo CRE (Man-Sieverts)','18-Mo CRE Data Code','2-Yr CRE (Man-Rem)',
              '2-Yr CRE (Man-Sieverts)','2-Yr CRE Data Code','3-Yr CRE (Man-Rem)',
              '3-Yr CRE (Man-Sieverts)','3-Yr CRE Data Code',
              '1-Yr ISA1 (per 1,000,000 man-hours worked)',
              '1-Yr ISA2 (per 200,000 man-hours worked)','1-Yr ISA Data Code',
              '18-Mo ISA1 (per 1,000,000 man-hours worked)',
              '18-Mo ISA2 (per 200,000 man-hours worked)',
              '18-Mo ISA Data Code','2-Yr ISA1 (per 1,000,000 man-hours worked)',
              '2-Yr ISA2 (per 200,000 man-hours worked)',
              '2-Yr ISA Data Code','3-Yr ISA1 (per 1,000,000 man-hours worked)',
              '3-Yr ISA2 (per 200,000 man-hours worked)','3-Yr ISA Data Code',
              '1-Yr CISA1 (per 1,000,000 man-hours worked)',
              '1-Yr CISA2 (per 200,000 man-hours worked)',
              '1-Yr CISA Data Code','18-Mo CISA1 (per 1,000,000 man-hours worked)',
              '18-Mo CISA2 (per 200,000 man-hours worked)','18-Mo CISA Data Code',
              '2-Yr CISA1 (per 1,000,000 man-hours worked)',
              '2-Yr CISA2 (per 200,000 man-hours worked)',
              '2-Yr CISA Data Code','3-Yr CISA1 (per 1,000,000 man-hours worked)',
              '3-Yr CISA2 (per 200,000 man-hours worked)','3-Yr CISA Data Code',
              '1-Yr GRLF','1-Yr GRLF Data Code','18-Mo GRLF','18-Mo GRLF Data Code',
              '2-Yr GRLF','2-Yr GRLF Data Code','3-Yr GRLF','3-Yr GRLF Data Code',
              '1-Yr US7','1-Yr US7 Data Code','18-Mo US7','18-Mo US7 Data Code','2-Yr US7',
              '2-Yr US7 Data Code','3-Yr US7','3-Yr US7 Data Code')

tisa_fields <- c("1-Yr TISA1","1-Yr TISA2","18-Mo TISA1","18-Mo TISA2","2-Yr TISA1","2-Yr TISA2",
				"3-Yr TISA1","3-Yr TISA2")

if (Tisa) fields <- c(fields,tisa_fields)	# Add TISA fields

periods <- c(12,18,24,36)

indicators <- c('UCF  ','UCLF ','FLR  ','UA7  ','SP1  ','SP2  ','SP5  ','FRI  ','CY   ','CRE  ',
                'ISA','CISA','GRLF ','US7  ')
if (Tisa) indicators <- c(indicators,'TISA')

results <- subset(results,results$PeriodEndYrMn %in% analisedDate)
##################################################################

#pbFull <- txtProgressBar(min = 1, max = length(analisedDate), style = 3)

#print(analisedDate)

for (startDate in analisedDate)
{
if (session) setProgress(0)
print(dateToQ(startDate))
print(length(activeStation(startDate)))
pb <- txtProgressBar(min = 0, max = length(activeStation(startDate)), style = 3)
no <- 0
#noDate <- 1
sheet <- data.frame()
#print(paste(dateToQ(startDate),': #',noDate,'of',length(analisedDate)))

fn <- paste('csv/TISA_',startDate,'.csv',sep='')	# read TISA dataset ###### Check if exist otherwise calculate #####
tisa <- read.csv(fn)

for (u in activeStation(startDate))
#for (u in c(1463,1468))
	{
	#print(u)
	start.unit.time <-Sys.time()
	#print(paste('Unit ',nameByID(u),': #',no,' from ',length(activeStation(startDate))))
        setTxtProgressBar(pb, no)
        if (session) incProgress(1/length(activeStation(startDate)),detail=nameByID(u))

	centre <- unique(subset(relation,relation$LocId == u & relation$RelationId == 1
		& as.Date(relation$EndDate) >= Sys.Date(), select=ParentLocId))
	centre <- substr(as.character(place[place$LocId == unlist(centre),5]),4,4+6)
	if (length(centre)==0) centre <- 'N/A'
	name <- as.character(place[place$LocId == u,6])
	member <- unique(subset(relation,relation$LocId == u & relation$RelationId == 3
		& as.Date(relation$EndDate) >= Sys.Date(), select=ParentLocId))
	member <- substr(as.character(place[place$LocId == unlist(member),5]),1,3)
	if (length(member)==0) member <- 'N/A'
	rType <- unlist(subset(uData,uData$LocId == u,select=NsssTypeId))
	rType <- as.character(rTypes[rTypes$NsssTypeId == rType,2])
	if (length(rType)==0) rType <- 'N/A'
	mRate <- uData[uData$LocId == u,7]
	if (length(mRate)==0) mRate <- 'N/A'
	chemistry <- paste(trimws(as.character(CYGroups[CYGroups$LocId == u,2])[1],'r'),' ',sep='')
	#print(chemistry)
	vendor <- unique(subset(relation,relation$LocId == u & relation$RelationId == 9,
		select=ParentLocId))
	vendor <- as.character(place[place$LocId == unlist(vendor),5])[1]
	if (length(vendor)==0) vendor <- 'N/A'
	#print(vendor)
	commStart <- format(as.Date(as.character(uDate[uDate$DateTypeId == 4 & uDate$LocId == u,4]),"%Y-%m-%d"),"%m/%d/%Y")
	if (length(commStart)==0) commStart <- 'N/A'
	uC <- uCycle[uCycle$LocId == u & uCycle$EndYrMn == 999912,4]
	if (length(uC)==0) uC <- 'N/A'


	dataset <- c(centre,member,name,rType,chemistry,vendor,mRate,commStart,uC)
	#print(dataset)

	for (i in indicators)
		{
		#print(i)
		if (i == 'FRI  ') # Add other measuring units
			{
			r <- subset(results,results$LocId == u & results$IndicatorCode == i
				& results$PeriodEndYrMn == startDate & results$NumOfMonths == 3,
				select=c(ResultsValue,NonQualCode))
			if (rType %in% c('AGR  ','GCR  ','LWCGR','FBR  ')) # No units of measure
				{rst <- c('','',r$ResultsValue,trimws(as.character(r$NonQualCode),'b'))}
			else	{rst <- c(r$ResultsValue,r$ResultsValue*3.7E4,'',trimws(as.character(r$NonQualCode),'b'))}
			dataset <- c(dataset,t(rst))
			}
		else if (i == 'TISA') # read TISA data from the separate rds # Station's value
			{
			uNo <- as.integer(unique(subset(relation,relation$LocId == u
				& relation$RelationId == 4
				& as.Date(relation$EndDate) >= Sys.Date(),
				select=ParentLocId)))
                        #print(uNo)
			r <- subset(tisa,LocID==uNo,select=c(X1.Yr.TISA1,X1.Yr.TISA2,X18.Mo.TISA1,X18.Mo.TISA2,X2.Yr.TISA1,X2.Yr.TISA2,X3.Yr.TISA1,X3.Yr.TISA2))
                        #print(r)
			dataset <- c(dataset,t(r))
			}
		else
		{
		for (m in periods)
			{
			#print('Other indicators')
			if (i %in% c('SP5  ','ISA','CISA')) # Station's value
				{
				uNo <- as.integer(unique(subset(relation,relation$LocId == u
				& relation$RelationId == 4
				& as.Date(relation$EndDate) >= Sys.Date(),
				select=ParentLocId)))
				}
			else	{uNo <- u} # Unit's value
			# Get results
			r <- subset(results,results$LocId == uNo & results$IndicatorCode == i
				& results$PeriodEndYrMn == startDate & results$NumOfMonths == m,
				select=c(ResultsValue,NonQualCode))
			# Other units for CRE
			if (i == 'CRE  ')	{r <- c(r$ResultsValue,r$ResultsValue/100,trimws(as.character(r$NonQualCode),'b'))}
			else {r <- c(r$ResultsValue,trimws(as.character(r$NonQualCode),'b'))}
			if (i == 'ISA')
				{
				ind <- c('ISA1 ','ISA2 ')
				r <- subset(results,results$LocId == uNo & results$IndicatorCode %in% ind
				& results$PeriodEndYrMn == startDate & results$NumOfMonths == m,
				select=c(ResultsValue,NonQualCode))
				r <- c(r[1,1],r[2,1],trimws(as.character(r[1,2]),'b'))
				}
			if (i == 'CISA')
				{
				ind <- c('CISA1','CISA2')
				r <- subset(results,results$LocId == uNo & results$IndicatorCode %in% ind
				& results$PeriodEndYrMn == startDate & results$NumOfMonths == m,
				select=c(ResultsValue,NonQualCode))
				r <- c(r[1,1],r[2,1],trimws(as.character(r[1,2]),'b'))
				}
			# write dataset
			#print(r)
			#dataset <- c(dataset,t(r))
			tryCatch(dataset <- c(dataset,t(r)), error = function(e) {print(c(u,i,m))})
			}
		}
		}
                                        #print(dataset)
            tryCatch(sheet <- rbind(sheet,t(dataset)),error = function(e){
                err <- paste('Error in',nameByID(u),'data')
                print(err)
                return(err)
            })
	no <- no + 1
	try(unit.time <- Sys.time() - start.unit.time)
	eta <- as.integer(unit.time*(length(activeStation(startDate))-no+1))
	#finish.time <- as.integer(Sys.time()+unit.time*(length(activeStation)-no+1))
	#print(paste('ETA=',secToTime(eta),' (',as.integer(unit.time),' sec. per unit)'))
	}
colnames(sheet) <- fields
if (Tisa) fn <- paste('spreadsheets/',substr(startDate,1,4),'_WANO_PIData_Rev.csv',sep='')
else fn <- paste('spreadsheets/',dateToQ(startDate),'_AllLocations_Results.csv',sep='')
	write.csv(sheet,file=fn)
	#print('File has been saved')
	#close(pb)
	#noDate <- noDate + 1
	msg <- paste('CSV file has been completed for',startDate)
	#bot$sendMessage(msg)
}

#close(pbFull)
#end.time <- Sys.time()
#taken.time <- end.time-start.time
#print(paste('It has taken',secToTime(as.integer(taken.time))))
}
