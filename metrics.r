#######################################################################
# Calculates PI and PL metrics
#######################################################################

m <- function(dates,centres){

#source('functions.r')

#setwd('c:/Users/volodymyr.turbaevsky/Desktop/programming/R/indicators/')

#relation <- readRDS('DBCopy/PI_PlaceRelationship.rds')
#place <- readRDS('DBCopy/PI_Place.rds')
#r <- readRDS('DBCopy/PI_Results.rds')
#placeAttributes <- readRDS('DBCopy/PI_PlaceAttribute.rds')

#dates <- c(201606)

# Units by centre ==================================
#centreCode <- c(1155,1158,1156,1159)	#AC,MC,PC,TC
#centreNames <- c('AC','MC','PC','TC')
#unitsByCentre <- list()
#for (centre in c(1:4))
#{ unitsByCentre$uList[centre] <- unique(subset(relation,relation$ParentLocId == centreCode[centre] & relation$RelationId == 1 & relation$EndDate >= '9999-01-01', select=c(LocId)))
#print(unitsByCentre$uList[centre])
#}

unitsByCentre <- uByCentre()

############################### PI-1 ##################################
print('PI-1 metric: unit and station reported out of 45 days period')
for (d in dates){
    for (centre in centres){
    subDate <- dateToReal(d,'s')
    #print(c(d,as.Date(subDate),centreNames[centre]))
    pi1list <- unlist(subset(submit, submit$YrMn==d & as.Date(submit$SubmittalDate)>=subDate & submit$LocId %in% unlist(unitsByCentre$uList[centre]),select=LocId))
    pi1 <- length(pi1list)
    names <- unlist(subset(place, place$LocId %in% pi1list,AbbrevLocName))
    ids <- unlist(subset(place, place$LocId %in% pi1list,LocId))
    print(paste(d,subDate,centreNames[centre],pi1,names,ids))
    incProgress(1/(length(centres)*length(dates)*3))
    }}
############################### LTP-2 ##################################
print('LTP-2 metric: time to promote data')
for (d in dates){
    for (centre in centres){
    subDate <- dateToReal(d,'e') #end of quarter
    sub <- as.Date(subset(submit, submit$YrMn==d & submit$LocId %in% unlist(unitsByCentre$uList[centre]),select=ProductionDate)[,1])
    mdate <- max(sub,na.rm=T)
    dd <- mdate-subDate
    lastUnit <- unique(unlist(subset(submit, submit$YrMn==d & submit$LocId %in% unlist(unitsByCentre$uList[centre]) & as.Date(submit$ProductionDate) == mdate,LocId)))
    names <- unlist(subset(place, place$LocId %in% lastUnit,AbbrevLocName))
    print(paste(d,centreNames[centre],mdate,dd,names))
    #ids <- unlist(subset(place, place$LocId %in% pi1list,LocId))
                                        #print(paste(d,subDate,centreNames[centre],ltp2,names,ids))
    incProgress(1/(length(centres)*length(dates)*3))
}}
############################## PI-2 and LTP-1 ###################################
# TODO: count a number
print('PI-2 metric: unit and station did not report any source data')
r <- subset(r,r$PeriodEndYrMn %in% dates)
for (d in dates){
    for (centre in centres){
        as <- activeStation(d,'p') # Active Plants
        plants <- intersect(as,unlist(unitsByCentre$uList[centre]))
                                        #print(plants)
        #print('Plants')
        for (p in plants){
            reported <- length(unlist(subset(r,r$PeriodEndYrMn == d & r$LocId == p & r$NumOfMonths == 3 & NonQualCode == ' ',LocId)))
            pi2 <- reported/5
            name <- unlist(subset(place, place$LocId == p,AbbrevLocName))
            if (!pi2) print(paste(d,centreNames[centre],'Station:',name,p))}
################### non-repoting Units
        #print('Units')
        as <- activeStation(d,'u') # Active Units
        units <- intersect(as,unlist(unitsByCentre$uList[centre]))
        #print(plants)
        for (u in units){
            reported <- length(unlist(subset(r,r$PeriodEndYrMn == d & r$LocId == u & r$NumOfMonths == 3 & NonQualCode == ' ',LocId)))
            pi2 <- reported/11
            name <- unlist(subset(place, place$LocId == p,AbbrevLocName))
            if (!pi2) print(paste(d,centreNames[centre],'Unit:',name,p))}
        incProgress(1/(length(centres)*length(dates)*3))

    }}}
