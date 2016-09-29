####################################################################################
# The main function is tisa2 which expects the date for calculation in YYYYMM format
# The checking INPO stations has been added to fix/check data fullness
####################################################################################

source('functions.r')

tisa2 <- function(startDate)
{
print(startDate)
iv <- readRDS('DBCopy/PI_IndValues.rds')
place <- readRDS('DBCopy/PI_Place.rds')
#relation <- readRDS('DBCopy/PI_PlaceRelationship.rds')

#Getting active station list
activeStation <- merge(place,placeAttributes,by='LocId')
activeStation <- subset(activeStation,activeStation$PlaceTypeId == 19
	& activeStation$AttributeTypeId == 7 & activeStation$EndDate >= '9999-01-01'
	& (activeStation$StartDate <= dateToReal(startDate) | is.na(activeStation$StartDate)) & IsDeleted == 0, LocId)
INPOStation <- intersect(unlist(subset(place,place$CountryId==50, LocId)),unlist(activeStation)) # US plants
#print(INPOStation)
# Additional filtering (manual)
activeStation <- unlist(activeStation)
#activeStation <- activeStation[!activeStation %in% c(1360,10111,10115)]
#activeStation <- c(activeStation,10225)
#print(activeStation)

place <- data.frame(lapply(place, as.character), stringsAsFactors=FALSE)

iList <- c('M1   ','M2   ','M3   ','M5   ','M6   ','M8   ')
iList2 <- c('M4   ','M7   ')
aList <- c(iList,iList2)
month <- c(3,12,18,24,36,48)

# Data range
dateRange <- function(st,mnt)
{
rng <- st
for (m in 1:(mnt-1))
	{
	st <- st-1
	if (as.integer(st/100)==st/100)
		{
		st <- st-(100-12)
		}
	rng <- c(rng,st)
	}
return(rng)
}

RecStatuses <- c('L','R','U')
SourceCodes <- c('DN','L','UD','X','XX')

ind <- subset(iv,iv$ElementCode %in% unlist(aList) & iv$SourceId %in% activeStation
	& iv$RecStatus != 'U' & iv$SourceCode != 'DN')
ind <- merge(ind,place,by.x="SourceId",by.y="LocId")

#d <- data.frame(stringsAsFactor=FALSE)

data <- data.frame()

pb <- txtProgressBar(min = 1, max = length(unique(ind$SourceId)), style = 3)
i <- 0

for (u in unique(ind$SourceId))
#for (u in 886:888)
	{
	i <- i+1
	setTxtProgressBar(pb, i)
        incProgress(1/length(unique(ind$SourceId)),detail=u)
	r <- list()
	r <- c(r,as.integer(u),place[place$LocId==u,6])
	for (m in month)
		{
		dates <- dateRange(startDate,m)
		ss <- subset(ind,ind$SourceId == u & ind$ElementCode %in% iList & ind$YrMn %in% dates,
			select=ElementValue)
		#try(s <- sum(ss))
		dd <- subset(ind,ind$SourceId == u & ind$ElementCode %in% iList2 & ind$YrMn %in% dates,
			select=ElementValue)
		#try(d <- sum(dd))
		#print(c(u,m,length(dates),length(unlist(ss))/6))
		####### Check the source data completeness ##########
		# Point 12 p.4 PI RM
		#a. To compute a quarterly value, valid data for contributing data elements must be present. (The only exception is the fuel reliability indicator; only one month of data is required to compute this indicator.)
		#b. To compute results for other periods, valid data must exist for at least half of the period. For example, for a one-year (four-quarter) value to be computed, at least two quarters of qualified data must exist; for a two-year (eight-quarter) value to be computed, at least four quarters of qualified data must exist.
		#if (u==1836) print(c(u,m,length(unlist(ss)),length(unlist(dd))))
		if ((length(unlist(ss))/6>=m/2 & length(unlist(dd))/2>=m/2 & u %in% INPOStation) |
		(length(unlist(ss))/6>=m/6 & length(unlist(dd))/2>=m/6 & !(u %in% INPOStation)))
			{
			#if (u==1836) print(c(u,unlist(ss),unlist(dd)))
			s <- sum(unlist(ss),na.rm=TRUE)
			d <- sum(unlist(dd),na.rm=TRUE)
			tisa2 <- s/d*2E5
			tisa1 <- s/d*1E6
			#if (u==1836) print(c(u,s,d,tisa1,tisa2))
			}
		else { tisa2 <- NA; tisa1 <- NA}
		r <- c(r,round(tisa1,digits=4),round(tisa2,digits=4))
		#if (u==1836) print((length(unlist(ss))/6>=m/2 & length(unlist(dd))/2>=m/2 & u %in% INPOStation) |
		#(length(unlist(ss))/6>=m/6 & length(unlist(dd))/2>=m/6 & !(u %in% INPOStation)))
		}
	#if (length(r)==14)
		data <- rbind(data,t(r))
	rm(r)
	}
close(pb)
colnames(data) <- c('LocID','name','3-Mo TISA1','3-Mo TISA2','1-Yr TISA1','1-Yr TISA2',
	'18-Mo TISA1','18-Mo TISA2','2-Yr TISA1','2-Yr TISA2','3-Yr TISA1','3-Yr TISA2',
	'4-Yr TISA1','4-Yr TISA2')
#print(data)
fn1 <- paste('csv/TISA_',startDate,'.rds',sep='')
fn2 <- paste('csv/TISA_',startDate,'.csv',sep='')
saveRDS(t(t(data)),fn1)
write.csv(t(t(data)),file=fn2)
}

