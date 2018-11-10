######################################################################################
# This is a calculation for the updated indexes
# 3-Yr parameters are using only
# System uses precalculated TISA parameters from TISA.rds
######################################################################################

#r <- readRDS('DBCopy/PI_Results.rds')
#uData <- readRDS('DBCopy/PI_UnitData.rds')
#rTypes <- readRDS('DBCopy/PI_NsssTypeLookup.rds')
#relation <- readRDS('DBCopy/PI_PlaceRelationship.rds')
# List of reactor by type
#rType <- c('AGR','BWR','LWCGR','PHWR','PWR')
rTypeCode <- c(1,3,12,13,14)
#iList <- c('CRE  ','FLR  ','UCF  ','SP1  ','SP2  ','SP5  ','US7  ','TISA')

UIndex <- function(Id,lastDate) # function expects the LocID as Id and the lastDate to reduse the results DB
{
#Id <- readline('Enter the LocID of the unit you are interested:')
#lastDate <- readline('Enter the date for analysis in format YYYYMM:')

    r <- subset(r,r$PeriodEndYrMn == lastDate)

# List of the lower and upper limits for each indicator - NEW
#limits <- list(CRE=list(AGR=c(1.32,10.9),BWR=c(84.8,162),LWCGR=c(97,390),PHWR=c(56,128),PWR=c(37,75)),
#				FLR=c(0.57,3.75),
#				SP1=c(0,0.003),
#				SP2=c(0,0.004),
#				SP5=c(1E-4,0.012),
#				US7=list(AGR=c(0.51,2.72),BWR=c(0,0.98),LWCGR=c(0,0.82),PHWR=c(0.28,1.76),PWR=c(0,0#.75)),
#               TISA=c(0.03,0.4),
#               UCF=c(91,86))
                                        #weight <- list(FLR=0.15,UCF=0.15,US7=0.1,SP1=0.1,SP2=0.1,SP5=0.1,CRE=0.1,TISA=0.2)

### Method 4 ###
    iList <- c('CRE  ','FLR  ','UCF  ','SP1  ','SP2  ','SP5  ','UA7  ','ISA2 ','CY   ','FRI  ')
    limits <- list(CRE=list(AGR=c(2,10),BWR=c(120,220),LWCGR=c(150,500),PHWR=c(80,140),PWR=c(60,120)),
                   FLR=c(1,8),
                   SP1=c(0.02,0.03),
                   SP2=c(0.02,0.03),
                   SP5=c(0.025,0.035),
                   UA7=c(.5,1.5),
                   FRI=list(BWR=c(300,3000),PWR=c(5e-4,5e-3),PHWR=c(5e-4,5e-3),AGR=c(1e-3,2e-3)),
                   CY=c(1.01,1.2),
                   ISA2=c(0.2,1),
                   UCF=c(80,92))

    weight <- list(FLR=0.15,UCF=0.15,UA7=0.1,SP1=0.1,SP2=0.1,SP5=0.1,CRE=0.1,CY=0.05,ISA2=0.05,FRI=0.1)
    cyl <- subset(cycle,LocId==Id & EndYrMn>=205000,NumOfMonths)[[1]]
    month <- list(FLR=cyl,UCF=cyl,UA7=24,SP1=36,SP2=36,SP5=36,CRE=cyl,CY=cyl,ISA2=cyl,FRI=3)

    "For most indicators, if a refuelling cycle is 12 or 24 months, or the unit is a PHWR or LWCGR, a 2-year value is used; if the refuelling cycle is 18 months, an 18-month value is used. Safety system performance indicators (SP1, SP2, SP5) always use 3-year values. The index calculations also use a fuel reliability indicator (FRI) value based on the most recent operating quarter. The unplanned automatic scrams per 7,000 hours critical indicator (UA7) always uses the 2-year value"


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
            if (i %in% c('CRE  ','US7  ','FRI  '))
                lim <- limits[[trimws(i)]][[rType]] else lim <- limits[[trimws(i)]]
            coeff <- 100/(lim[2]-lim[1])
            if (i %in% c('SP5  ','TISA','ISA2 '))
                Idd <- as.integer(unique(subset(
                    relation,relation$LocId == Id & relation$RelationId == 4 &
                             relation$EndDate >= '9999-01-01',select=ParentLocId)))
            else Idd <- Id
            if (i!='TISA'){
                result <- unlist(subset(r,r$LocId == Idd & r$IndicatorCode == i & r$PeriodEndYrMn == lastDate & r$NumOfMonths == month[[trimws(i)]] & r$NonQualCode==' ', ResultsValue)) #### Set the correct Num of Month for Method 4 ###
                                        #print(result)
            }
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
            ds <- rbind(ds,c(i,signif(result,3),signif(rr,3),signif(index,3)))
	#d <- rbind(d,ds)
            no<-no+1
	#setTxtProgressBar(pb, no)
	}
    s <- signif(s,3)
    ds <- rbind(ds,c('Sum','','',s))

    #print(ds)
    #print(s)

    return(ds)
}
