##################################################################################################
#  This is report generator to produce Long-Term Target Performance Table
#  to replace the existing one at http://www.wano.org/xwp10webapp/reports/TableReport.pdf?x=774741
#  To generate pdf report the Sweave('QReport.rnw') command should be ran
##################################################################################################
library(logging)
basicConfig()
setLevel('DEBUG',getHandler('basic.stdout'))
#source('functions.r')

#if (readline('Need you update the Db copy (Y/n)?')=='Y')
#{
#source('fullDBCopy.R')
##print('DB copying...')
#DBCopy()	# Provide the last DB copy
#}

#dateRange <- c(200712,200812,200912,201012,201112,201212,201312,201412,201512,201603)
#dateRange <- input$qtr

#if (readline('Need you update all TISA calculation (Y/n)?')=='Y')
#{
#source('tisa2.r')
#print('TISA2 calculation...')
#for (d in dateRange)
#	{
#	tisa2(d)	# Provide the last date for analysis
#	}
#}

##placeAttributes <- readRDS('DBCopy/PI_PlaceAttribute.rds')
#r <- readRDS('DBCopy/PI_Results.rds')
#place <- readRDS('DBCopy/PI_Place.rds')
                                        #relation <- readRDS('DBCopy/PI_PlaceRelationship.rds')
#source('shiny/data.r')
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
centreNames <- c('WANO:AC','WANO:MC','WANO:PC','WANO:TC')
unitsByCentre <- list()
for (centre in c(1:4))
	{ unitsByCentre$uList[centre] <- unique(subset(relation,relation$ParentLocId == centreCode[centre]
		& relation$RelationId == 1 & as.Date(relation$EndDate) >= Sys.Date(), select=LocId)) }

# Reactor type related calculations ==================================================================
rTypeResults <- function(centre,i,lastDate,byType=FALSE)
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
                #print(uNum)
		}
	Id <- round(sum(lowerId)/sum(uNum)*100,1)
	Is <- round(sum(lowerIs)/sum(uNum)*100,1)
	data.local <- list(as.character(centreNames[centre]),as.character(i),as.numeric(Id),
                           as.numeric(Is),as.integer(sum(lowerId)),as.integer(sum(lowerIs)),as.integer(sum(uNum)))
        #print (t(data.local))
	if (!byType) return(data.local)
        else {
            saveRDS(lowerId/uNum,paste('LTT/',i,'_idv_',lastDate,'.rds',sep=''))
            saveRDS(lowerIs/uNum,paste('LTT/',i,'_ids_',lastDate,'.rds',sep=''))
        }
	}

# Calculate statistics by centre ==========================================================================
# Key indicator list

generate <- function(dateRange,session=TRUE)
    {
indicators <- c('FLR','CRE','TISA','US7','SSPI')

for (lastDate in dateRange)
{
fn <- paste('csv/TISA_',lastDate,'.csv',sep='')
tisa <- read.csv(fn)
loginfo(lastDate)
# pb <- txtProgressBar(min = 0, max = length(indicators)*4, style = 3)
count <- 0
d <- data.frame(stringsAsFactors=FALSE)
sspi <- data.frame()

for (centre in c(1:4))	# By centre
{
    loginfo('Centre = %s',centre)
    for (i in indicators)
    {
        loginfo(i)
        count <- count + 1
                                        #Initialisation
                                        #lowerId <- 0; lowerIs <- 0; uNum <- 0; Id <- 0; Is <- 0
                                        #Calculation
        if (i %in% c('CRE','US7')) {d <- rbind(d,c(t(rTypeResults(centre,i,lastDate)),'NA'))}
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
            d <- rbind(d,t(list(centreNames[centre],i,Id,Is,lowerId,lowerIs,uNum,'NA')))
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
            d <- rbind(d,t(list(as.character(centreNames[centre]),as.character(i),Id,Is,lowerId,lowerIs,uNum,'NA')))
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
            uNumS <- c()
            for (sys in c('SP1  ','SP2  ','SP5  '))
                uNumS <- c(uNumS,length(unlist(subset(r,r$IndicatorCode==sys
                                                      & r$PeriodEndYrMn == lastDate & r$NumOfMonths == 36 & r$NonQualCode == ' ' & r$LocId %in% unlist(unitsByCentre$uList[centre]) & r$ResultsValue >= 0 ,LocId))))

            Id <- round(sum(lowerId)/uNum*100,1)
                        #IdperS <- lowerId/uNumS
			#Is <- Id	# Check the calculation - is it really the same as individual or I have to combine unit's system together
			#lowerIs <- sum(lowerId)
                        ###############################################################################
### Industry level should be calculated as number of units didn't meet any of SSPI targets
### then comment two code lines above
### Check if it is applicable for US plants !!!

            lowerIs <- 0
            sspiNum <- length(intersect(unlist(unitsByCentre$uList[centre]),activeStation(lastDate)))
            loginfo('There are %d units in the %d centre',sspiNum,centre)
            rr <- subset(r,PeriodEndYrMn==lastDate)
            for (uN in intersect(unlist(unitsByCentre$uList[centre]),activeStation(lastDate))){
                                        #loginfo('unit=%d',uN)

                sp1 <- subset(rr,rr$IndicatorCode=='SP1  ' & rr$PeriodEndYrMn == lastDate
                              & rr$NumOfMonths == 36 & rr$NonQualCode == ' ' & rr$LocId == uN,ResultsValue)[[1]]
                                        #loginfo('sp1 of type %s is %f',typeof(sp1),sp1)
                sp2 <- subset(rr,rr$IndicatorCode=='SP2  ' & rr$PeriodEndYrMn == lastDate
                              & rr$NumOfMonths == 36 & rr$NonQualCode == ' ' & rr$LocId == uN,ResultsValue)[[1]]
                                        #logdebug('sp2=%f',sp2)
                sp5 <- subset(rr,rr$IndicatorCode=='SP5  ' & rr$PeriodEndYrMn == lastDate
                              & rr$NumOfMonths == 36 & rr$NonQualCode == ' ' & rr$LocId == plantID(uN),ResultsValue)[[1]]
                                        #logdebug('sp5=%f',sp5)
                                        #loginfo('%f %f %f',sp1,sp2,sp5)
                if (length(sp1) && length(sp2) && length(sp5) && sp1 <= hid('SP1  ') && sp2 <= hid('SP2  ') && sp5 <= hid('SP5  ')) lowerIs <- lowerIs+1
                else if (length(sp1) && length(sp2) && length(sp5) && (sp1 > hid('SP1  ') || sp2 > hid('SP2  ') || sp5 > hid('SP5  '))) loginfo('Unit %s did not meet industry target due to SP1=%f, SP2=%f and SP5=%f',nameByID(uN),sp1,sp2,sp5)
                #else if (length(sp1) && length(sp2) && length(sp5))
                #    logdebug('for unit %s sp1=%f, sp2=%f, sp5=%f',nameByID(uN),sp1,sp2,sp5)
                else {
                    logwarn('Unit %s does not have all SSPI data',nameByID(uN))
                    sspiNum <- sspiNum-1
                }
            }

            Is <- round(sum(lowerIs)/sspiNum*100,1) ###################
################################################################################
            loginfo('Industry SSPI is %d (%d) units out of %d, or %.1f percent',lowerIs,sum(lowerIs),sspiNum,Is)
            d <- rbind(d,t(list(as.character(centreNames[centre]),as.character(i),Id,Is,sum(lowerId),lowerIs,uNum,sspiNum)))
        }
        #setTxtProgressBar(pb, count)
        if (session) incProgress(1/(length(indicators)*4),detail=i)
    }
### calculate SP1-5 details
    sspi <- rbind(sspi,c(lowerId,uNumS))
    colnames(sspi) <- c('SP1','SP2','SP5','uNumSP1','uNumSP2','uNumSP5')
    print(sspi)
}
colnames(d) <- c('Centre','Indicator','Ind.percentage','Indust.percentage','Units met Id','Units met Is','Qualified units','SSPI.qual.units')
print(d)
                                        # Worldwide status
w <- data.frame()
for (i in indicators)
{
    Ud <- sum(unlist(subset(d,d$Indicator==i,'Units met Id')))
    Us <- sum(unlist(subset(d,d$Indicator==i,'Units met Is')))
    Un <- sum(unlist(subset(d,d$Indicator==i,'Qualified units')))
    if (i=='SSPI') sUn <- sum(unlist(subset(d,d$Indicator==i,'SSPI.qual.units')))
    else sUn <- NA
    Id <- round(Ud/Un*100,1)
    if (i!='SSPI') Is <- round(Us/Un*100,1)
    else Is <- round(Us/sUn*100,1)
    w <- rbind(w,t(list(as.character('WANO'),as.character(i),Id,Is,Ud,Us,Un,sUn)))
}
colnames(w) <- c('Centre','Indicator','Ind.percentage','Indust.percentage','Units met Id','Units met Is','Qualified units','SSPI.qual.units')


print(w)

saveRDS(w,paste('LTT/Worldwide_LTT_',lastDate,'.rds',sep=''))
saveRDS(d,paste('LTT/RCs_LTT_',lastDate,'.rds',sep=''))
saveRDS(sspi,paste('LTT/WW_SSPI_',lastDate,'.rds',sep=''))

#close(pb)
#print(w)
#print(d)
}}

#bot$sendMessage('QReport processing is completed')

