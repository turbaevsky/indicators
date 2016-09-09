r <- readRDS('DBCopy/PI_Results.rds')
ic <- c('SP1  ','SP2  ','SP5  ')
UnitData <- readRDS('DBCopy/PI_UnitData.rds')
place <- readRDS('DBCopy/PI_Place.rds')
relation <- readRDS('DBCopy/PI_PlaceRelationship.rds')
# List of reactor by type
uType <- subset(UnitData,NsssTypeId == 14,select = 1) # 14=PWR
dateList <- c(200712,200812,200912,201012,201112,201212,201312,201412,201512)
lastDate <- 201512
NumOfMonths <- 36
# Units by centre
centreCode <- c(1155,1158,1156,1159)	#AC,MC,PC,TC
centreNames <- c('AC','MC','PC','TC')
unitsByCentre <- list()
for (centre in c(1:4))
	{unitsByCentre$uList[centre] <- unique(subset(relation,relation$ParentLocId == centreCode[centre] 
	 & relation$RelationId == 1 & relation$EndDate == '9999-12-31', select=LocId))}

l <- length(unlist(unitsByCentre))*4*length(dateList)
cnt <- 0
#pb <- txtProgressBar(min = 1, max = l, style = 3)		
for (lastDate in dateList)
	{
	for (centre in c(1:4))			
		{
		num <- 0
		counter <- c(0,0,0)
		for (u in unitsByCentre$uList[centre])
			{
			cnt <- cnt + 1
			setTxtProgressBar(pb, cnt)
			for (i in ic)
				{
				val2007 <- subset(r,r$IndicatorCode==i & r$PeriodEndYrMn==200712 & r$NumOfMonths==36 & r$NonQualCode==' ' & r$LocId==u,ResultsValue)
				#print('i')
				if (!is.null(val2007))
					{
					num <- num + 1 
					curRes <- subset(r,r$IndicatorCode==i & r$PeriodEndYrMn==200712 & r$NumOfMonths==36 & r$NonQualCode==' ' & r$LocId==u,ResultsValue)
					#print('val is not null')
					if (i=='SP1  ') {val<-0.020; n<-1}
					if (i=='SP2  ') {val<-0.020; n<-2}
					if (i=='SP5  ') {val<-0.025; n<-3}
					#print(n)
					if (!is.null(curRes) & curRes<=val & curRes<=val2007) 
						{counter[n] <- counter[n] + 1}
					#print('val is not null')
					}
				print(paste(i,counter[i]))
				}
			}
		}
	}
	
