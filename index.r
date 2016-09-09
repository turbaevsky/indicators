######################################################################################
# This is a calculation for the updated indexes
# 3-Yr parameters are using only
# System uses precalculated TISA parameters from TISA.rds
######################################################################################

r <- readRDS('DBCopy/PI_Results.rds')
uData <- readRDS('DBCopy/PI_UnitData.rds')
rTypes <- readRDS('DBCopy/PI_NsssTypeLookup.rds')
relation <- readRDS('DBCopy/PI_PlaceRelationship.rds')
# List of reactor by type
#rType <- c('AGR','BWR','LWCGR','PHWR','PWR')
rTypeCode <- c(1,3,12,13,14)
iList <- c('CRE  ','FLR  ','UCF  ','SP1  ','SP2  ','SP5  ','US7  ','TISA')

idx <- function(Id,lastDate) # function expects the LocID as Id and the lastDate to reduse the results DB
{
#Id <- readline('Enter the LocID of the unit you are interested:')
#lastDate <- readline('Enter the date for analysis in format YYYYMM:')

r <- subset(r,r$PeriodEndYrMn == lastDate)

# List of the lower and upper limits for each indicator
limits <- list(CRE=list(AGR=c(1.32,10.9),BWR=c(84.8,162),LWCGR=c(97,390),PHWR=c(56,128),PWR=c(37,75)),
				FLR=c(0.57,3.75),
				SP1=c(0,0.003),
				SP2=c(0,0.004),
				SP5=c(1E-4,0.012),
				US7=list(AGR=c(0.51,2.72),BWR=c(0,0.98),LWCGR=c(0,0.82),PHWR=c(0.28,1.76),PWR=c(0,0.75)),
               TISA=c(0.03,0.4),
               UCF=c(91,86))
weight <- list(FLR=0.15,UCF=0.15,US7=0.1,SP1=0.1,SP2=0.1,SP5=0.1,CRE=0.1,TISA=0.2)

rType <- unique(unlist(subset(uData,uData$LocId == Id,select=NsssTypeId)))
rType <- trimws(as.character(rTypes[rTypes$NsssTypeId == rType,2]))

#d <- data.frame(stringsAsFactors = F)
s <- 0
#pb <- txtProgressBar(min = 0, max = length(iList), style = 3)
no<-0
ds <-c()

for (i in iList)
	{

	#print(i)
	if (i=='CRE  ' | i=='US7  ') lim <- limits[[trimws(i)]][[rType]] else lim <- limits[[trimws(i)]]
	coeff <- 100/(lim[2]-lim[1])
	if (i=='SP5  ' | i=='TISA') Idd <- as.integer(unique(subset(relation,relation$LocId == Id & relation$RelationId == 4
										& relation$EndDate == '9999-12-31',	select=ParentLocId)))
	else Idd <- Id
	if (i!='TISA') result <- unlist(subset(r,r$LocId == Idd & r$IndicatorCode == i & r$PeriodEndYrMn == lastDate & r$NumOfMonths == 36 & r$NonQualCode==' ', ResultsValue))
	else ### Add TISA results here
		{
		fn <- paste('csv/TISA_',lastDate,'.rds',sep='')
		tisa <- readRDS(fn)
		row.names(tisa) <- tisa[,1]
		result <- unlist(tisa[as.character(Idd),'3-Yr TISA2'])
		}
                                        #print(c(result, lim, coeff))
        if (i!='UCF  ')
                if (result<=lim[1]) rr<-100 else if (result>=lim[2]) rr<-0 else rr <- (lim[2]-result)*coeff
        else # for UCF
                if (result>=lim[1]) rr<-100 else if (result<=lim[2]) rr<-0 else rr <- (lim[1]-result)*coeff
	index<-rr*weight[[trimws(i)]]
	#print(c(i,result,rr,index))
	s <- s + index
	ds <- rbind(ds,c(i,result,rr,index))
	#d <- rbind(d,ds)
	no<-no+1
	#setTxtProgressBar(pb, no)
	}

#print(ds)
#print(s)

return(s)
}
