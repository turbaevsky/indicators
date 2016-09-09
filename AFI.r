r <- readRDS('DBCopy/PI_Results.rds')
relation <- readRDS('DBCopy/PI_PlaceRelationship.rds')
ic <- c('SP1  ','SP2  ','SP5  ')
lastDate <- 201512
NumOfMonths <- 36
uList <- list(c(1062,1063,1109,1110,1118,1117,1069,1070,1044,1045,1046,1047,1135),c(1177,1878,1879,1880,1462,1463),c(1583,1584,1645,1645,1568,1656,1657,1574),c(1466,1467,10187,1489,1490,1479,1480,1481,1482,10177,10277,1496,1495,2463,2464,10175,10183)) #Units by AC,MC,PC,TC
rc <- c ('AC','MC','PC','TC')

for (i in 1:4)#:4
	{
	print(rc[i])
	for (ind in ic)
		{
		print(ind)
		if (ind != 'SP5  ')	{U <- unlist(uList[i])}
		else {U <- unlist(unique(subset(relation,relation$LocId %in% unlist(uList[i]) 
				& relation$RelationId == 4 & relation$EndDate == '9999-12-31', select=ParentLocId)))}
		#print(U)
		dataset <- unlist(subset(r,r$IndicatorCode==ind & r$PeriodEndYrMn==lastDate & r$NumOfMonths==NumOfMonths 
			& r$NonQualCode==' ' & r$LocId %in% U,ResultsValue))
			#print(dataset)
		print(c('Mean=',mean(dataset)))
		print(c('Median=',median(dataset)))
		}
	}