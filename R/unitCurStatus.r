dates <- readRDS('DBCopy/PI_UnitDate.rds')
uData <- readRDS('DBCopy/PI_UnitData.rds')
stat <- readRDS('DBCopy/PI_UnitDateTypeLookup.rds')
place <- readRDS('DBCopy/PI_Place.rds')
relation <- readRDS('DBCopy/PI_PlaceRelationship.rds')
dataStatus <- readRDS('DBCopy/PI_DataStatus.rds')
attrib <- readRDS('DBCopy/PI_PlaceAttribute.rds')

print(dataStatus)
plants <- unique(unlist(subset(place,place$PlaceTypeId %in% c(19,22),LocId)))

pdate <- data.frame()

for (p in unlist(plants))
	{
	d <- as.Date(subset(dates,dates$LocId == p,select = UnitDate)[,1])
	d <- max(d)
	st <- as.numeric(subset(dates,dates$LocId == p & as.Date(dates$UnitDate) == as.character(d),select=DateTypeId)[,1])
	s <- as.character(stat[stat$DateTypeId==st,3])
	uname <- as.character(subset(place,place$LocId==p,AbbrevLocName)[,1])
	centre <- unique(subset(relation,relation$LocId == p & relation$RelationId == 1
		& relation$EndDate >= Sys.Date(), select=ParentLocId))
	centre <- substr(as.character(place[place$LocId == unlist(centre),5]),4,4+6)
        if (length(unlist(subset(attrib,attrib$LocId==p & attrib$AttributeTypeId==7 & attrib$EndDate>=Sys.Date(),LocId)))) piRep <- 'Y' else piRep <- 'N'
        if (length(unlist(subset(attrib,attrib$LocId==p & attrib$AttributeTypeId==15 & attrib$EndDate>=Sys.Date(),LocId)))) locActive <- 'Y' else locActive <- 'N'
        if (length(unlist(subset(uData,uData$LocId==p & uData$IsUnitActive==1,LocId)))) Active <- 'Y' else Active <- 'N'
	l <- list(uname,p,centre,as.character(d),s,piRep,Active,locActive)
	pdate <- rbind(pdate,t(l))
	}
colnames(pdate) <- c('UnitName','LocId','Centre','DateOfStatus','Status','PI Report','Active','LocActive')
#print(pdate)
write.csv(t(t(pdate)),file='UnitCurStatus.csv')
