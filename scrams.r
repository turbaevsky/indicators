##############################################################
# This script calculates the number of scrams during 2013-2015
# by reactor types
##############################################################

scrams <- function(yr,eCode){
#setwd('c://Users//volodymyr.turbaevsky//Desktop//programming//R//indicators//')
r <- data
#eCode <- c('C1   ','C3   ')
r <- subset(r,r$YrMn>=200700 & r$ElementCode %in% eCode & r$RecStatus == ' ')
#yr <- c('2013','2014','2015','2016')

# List of reactor by type
UnitData <- uData
rType <- c('AGR','BWR','LWCGR','PHWR','PWR')
rTypeCode <- c(1,3,12,13,14)
uType <- list()
for (t in c(1:5))
{ uType$rType[t] <- subset(UnitData,NsssTypeId == rTypeCode[t],select = 1)}

options(stringsAsFactors = FALSE)
data <- data.frame()

for (y in yr){
    for (t in c(1:5)){
    	ys <- paste(y,'00',sep='')
	ye <- paste(y,'12',sep='')
	s <- try(sum(subset(r,r$SourceId %in% unlist(uType$rType[t]) & r$YrMn>=ys & r$YrMn<=ye & r$ElementCode %in% eCode & r$RecStatus == ' ', select='ElementValue'),na.rm=TRUE))
        sa <- try(sum(subset(r,r$SourceId %in% unlist(uType$rType[t]) & r$YrMn>=ys & r$YrMn<=ye & r$ElementCode == 'C1   ' & r$RecStatus == ' ', select='ElementValue'),na.rm=TRUE))
        sm <- try(sum(subset(r,r$SourceId %in% unlist(uType$rType[t]) & r$YrMn>=ys & r$YrMn<=ye & r$ElementCode == 'C3   ' & r$RecStatus == ' ', select='ElementValue'),na.rm=TRUE))
        uNo <- length(unique(unlist(subset(r,r$SourceId %in% unlist(uType$rType[t]) & r$YrMn>=ys & r$YrMn<=ye,select='SourceId'))))
        avg <- s/uNo
        list <- c(y,rType[t],uNo,s,sa,sm,avg)
	#print(list)
        data <- rbind(data,list)
    }
}
colnames(data) <- c('Yr','rType','uNum','TScrams','AScrams','MScrams','Avg.Scrams by reactor')
    #print(data)
    return(data)
}
### drawing

