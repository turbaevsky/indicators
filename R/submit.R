#####################################################################
# To show the units numbers did not send (submit) data in time
#####################################################################
#place <- readRDS('DBCopy/PI_Place.rds')
#placeAttributes <- readRDS('DBCopy/PI_PlaceAttribute.rds')
#submit <- readRDS('DBCopy/PI_DataSubmittal.rds')
                                        #elements <- readRDS('DBCopy/PI_IndValues.rds')
#elements <- data #<<<<<<<<<<<<<<<<<<<< if needed
#relation <- readRDS('DBCopy/PI_PlaceRelationship.rds')

#Getting active units list
#activeStation <- merge(place,placeAttributes,by='LocId')
#activeStation <- subset(activeStation,activeStation$PlaceTypeId %in% c(19,22) #19 for stations, 22 for units
#	& activeStation$AttributeTypeId == 7 & activeStation$EndDate >= '9999-01-01'
#	& IsDeleted == 0, LocId)
#activeStation <- unlist(activeStation)
#Remove some extra units and fuel reprocessing factories
#activeStation <- activeStation[which(!activeStation %in% c(10159,10111,10115,1871,1872,1360,1569,1330))]

#source('functions.r')
                                        #aDate <- 201606

uName <- function(centre,u){return(paste(centre,u,unlist(subset(place,place$LocId==u,select=AbbrevLocName))))}

submitProgress <- function(aDate,plot=TRUE){
    as <- activeStation(aDate,'a')
    uList <- c()
    uByCentre <- c(0,0,0,0)

    for (u in as)
    {
        incProgress(1/length(as))
	if (!(u %in% submit[submit$YrMn == aDate,1]))	# For submitted data only
		{
		uList <- c(uList,u)
		centre <- unique(subset(relation,relation$LocId == u & relation$RelationId == 1
			& relation$EndDate >= '9999-01-01', select=ParentLocId))
		centre <- substr(as.character(place[place$LocId == unlist(centre),5]),4,4)
		if (length(centre))
		{
		#print(c(u,centre))
		if (centre == 'A')	{uByCentre[1] <- uByCentre[1]+1; print(uName('AC',u))}
		if (centre == 'M')	{uByCentre[2] <- uByCentre[2]+1; print(uName('MC',u))}
		if (centre == 'P')	{uByCentre[3] <- uByCentre[3]+1; print(uName('PC',u))}
		if (centre == 'T')	{uByCentre[4] <- uByCentre[4]+1; print(uName('TC',u))}
		}
		}
	}
#print (c(uList,length(uList),uByCentre))
print('Units and plants did not submit data to the RCs (AC/MC/PC/TC):')
print(uByCentre)
#print('Units did not submit data:')
                                        #print(subset(place,place$LocId %in% uList,select=AbbrevLocName))
if (plot) barplot(uByCentre,names.arg = c('A','M','P','T'), main = paste('Num of units and plants did not \nsubmit their data for',aDate))
}
