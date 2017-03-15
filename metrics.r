#######################################################################
# Calculates PI and PL metrics
#######################################################################

metrics <- function(dates,centres,print=FALSE){

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

res <- c()

############################### PI-1 ##################################
    if (print) print('PI-1 metric: unit(s) sent data to RC out of 45 days period')
    pi1res <- c()
for (d in dates){
    for (centre in centres){
    subDate <- dateToReal(d,'s')
    #print(c(d,as.Date(subDate),centreNames[centre]))
    pi1list <- unlist(subset(submit, submit$YrMn==d & as.Date(submit$SubmittalDate)>=subDate
                             & submit$LocId %in% unlist(unitsByCentre$uList[centre]),select=LocId))
    pi1 <- length(pi1list)
    names <- unlist(subset(place, place$LocId %in% pi1list,AbbrevLocName))
    ids <- unlist(subset(place, place$LocId %in% pi1list,LocId))
    if (print) print(paste(d,subDate,centreNames[centre],pi1,names,ids))
    #incProgress(1/(length(centres)*length(dates)*3))
    pi1res <- c(pi1res,pi1)
    }}
res <- rbind(res,pi1res)
############################### LTP-2 ##################################
if (print) print('LTP-2 metric: time RC promoted data for calculation (target is 60)')
ltp2 <- c()

for (d in dates){
    for (centre in centres){
    subDate <- dateToReal(d,'e') #end of quarter
    sub <- as.Date(subset(submit, submit$YrMn==d & submit$LocId %in% unlist(unitsByCentre$uList[centre]),select=ProductionDate)[,1])
    mdate <- max(sub,na.rm=T)
    dd <- mdate-subDate
    lastUnit <- unique(unlist(subset(submit, submit$YrMn==d & submit$LocId %in% unlist(unitsByCentre$uList[centre]) & as.Date(submit$ProductionDate) == mdate,LocId)))
    names <- unlist(subset(place, place$LocId %in% lastUnit,AbbrevLocName))
    if (print) print(paste(d,centreNames[centre],mdate,dd,names))
    #ids <- unlist(subset(place, place$LocId %in% pi1list,LocId))
                                        #print(paste(d,subDate,centreNames[centre],ltp2,names,ids))
    #incProgress(1/(length(centres)*length(dates)*3))
    ltp2 <- c(ltp2,dd)
    }}
res <- rbind(res,ltp2)
############################## PI-2 and LTP-1 ###################################
# TODO: count a number
    if (print) print('PI-2 metric: unit(s) not reported 100% valid source data (based on calculation results)')
    pi2ltp1 <- c()
r <- subset(r,r$PeriodEndYrMn %in% dates)
for (d in dates){
    for (centre in centres){
#        as <- activeStation(d,'p') # Active Plants
#        plants <- intersect(as,unlist(unitsByCentre$uList[centre]))
                                        #print(plants)
        #print('Plants')
#        for (p in plants){
#            reported <- length(unlist(subset(r,r$PeriodEndYrMn == d & r$LocId == p & r$NumOfMonths == 3 & NonQualCode == ' ',LocId)))
#            pi2 <- reported/5
#            name <- unlist(subset(place, place$LocId == p,AbbrevLocName))
#            if (!pi2 && print) print(paste(d,centreNames[centre],'Station:',name,p))}
################### non-repoting Units
        #print('Units')
        as <- activeStation(d,'u') # Active Units
        units <- intersect(as,unlist(unitsByCentre$uList[centre]))
                                        #print(plants)
        cnt <- 0
        for (u in units){
            reported <- length(unlist(subset(r,r$PeriodEndYrMn == d & r$LocId == u & r$NumOfMonths == 3 & NonQualCode == ' ',LocId)))
            #print(paste(u,reported))
            pi2 <- reported/11
            name <- unlist(subset(place, place$LocId == u,AbbrevLocName))
            if (!pi2){
                if (print) print(paste(d,centreNames[centre],'Unit:',name,u))
                cnt <- cnt+1
            }}
        #incProgress(1/(length(centres)*length(dates)*3))
        pi2ltp1 <- c(pi2ltp1,cnt)
    }}
    res <- rbind(res,pi2ltp1)
    fn <- paste('metrics/metrics_',dates,'.rds',sep='')
    saveRDS(res,fn)
    print(dates)
    print(res)
    return(res)
}
