#library(telegram)
#bot <- TGBot$new(token = '183104961:AAFOVTLmfQ0MDHdt2ZnLgtUZYkM_gbDFkLs')
#bot$set_default_chat_id(181982455)

ucl <- read.csv('../../../programming/R/indicators/ucl.csv',header=F)
ucf <- read.csv('../../../programming/R/indicators/ucf.csv',header=F)
flr <- read.csv('../../../programming/R/indicators/flr.csv',header=F)
ua7 <- read.csv('../../../programming/R/indicators/ua7.csv',header=F)
us7 <- read.csv('../../../programming/R/indicators/us7.csv',header=F)



indValues <- readRDS('DBCopy/PI_IndValues.rds')
results <- readRDS('DBCopy/PI_Results.rds')
relation <- readRDS('DBCopy/PI_PlaceRelationship.rds')
place <- readRDS('DBCopy/PI_Place.rds')

### CUTTING THE DB ####
indValues <- subset(indValues, YrMn>=201600)
results <- subset(results,PeriodEndYrMn>=201600)


uID <- read.csv('../../../programming/R/indicators/unitsID.csv')

indicators <- c('UCLF ','UCF  ','FLR  ','UA7  ','US7  ')

lastDate = 201612
period <- c(201601:201612)
m = 12

r <- data.frame()

compare <- function(uNo,pris,pidb,delta,comm)
	{
	res<-c()
	centre <- unique(subset(relation,relation$LocId == uNo & relation$RelationId == 1 & relation$EndDate == '9999-12-31', select=ParentLocId))
	centre <- substr(as.character(place[place$LocId == unlist(centre),5]),4,4+6)
	if (!length(centre)) {centre<-'NA'}

	#print(c(abs(pidb-pris)/pidb,delta))
	#if (pidb>0 && (abs(pidb-pris)/pidb)>delta)
	if (pidb>0 && abs(pidb-pris)>delta) # Switched to the absolute difference
        {
            res <- t(c(u,centre,i,pris,round(pidb,2),as.integer(abs(pidb-pris)),comm))
            #print(res)
        }
	return(res)
	}

################################################################################

pb <- txtProgressBar(min = 1, max = length(unlist(uID['UnitName']))*length(indicators), style = 3)
no <- 0

for (u in unlist(uID['UnitName']))
#for (u in c('ANGRA-1','ANGRA-2'))
	{
            #print(u)
            for (i in indicators)
            {
                                        #print(i)
                setTxtProgressBar(pb, no<-no+1)
                uNo <- as.numeric(uID[uID['UnitName']==u][3])[1]
                pidb <- as.numeric(subset(results,results$LocId == uNo & results$IndicatorCode == i & results$PeriodEndYrMn == lastDate & results$NumOfMonths == m,
                                          select=ResultsValue)$ResultsValue)
                try(switch(i,
                           'UCLF ' = {pris<-as.numeric(ucl[ucl['V1']==u][2]); delta<-5
                               comm <- sum(subset(indValues,indValues$SourceId==uNo & indValues$YrMn %in% period & indValues$ElementCode=='B3   ' & indValues$RecStatus==' ', select=ElementValue))
                               comm1 <- sum(subset(indValues,indValues$SourceId==uNo & indValues$YrMn %in% period & indValues$ElementCode=='B1   ' & indValues$RecStatus==' ', select=ElementValue))
                               comm3 <- sum(subset(indValues,indValues$SourceId==uNo & indValues$YrMn %in% period & indValues$ElementCode=='B4   ' & indValues$RecStatus==' ', select=ElementValue))
                               comm <- paste('FEL=',comm,'REG=',comm1,'OEL=',comm3)

                       },
		'UCF  ' = {pris<-as.numeric(ucf[ucf['V1']==u][2]); delta<-5
                    comm <- sum(subset(indValues,indValues$SourceId==uNo & indValues$YrMn %in% period & indValues$ElementCode=='B3   ' & indValues$RecStatus==' ', select=ElementValue))
                    comm1 <- sum(subset(indValues,indValues$SourceId==uNo & indValues$YrMn %in% period & indValues$ElementCode=='B1   ' & indValues$RecStatus==' ', select=ElementValue))
                    comm2 <- sum(subset(indValues,indValues$SourceId==uNo & indValues$YrMn %in% period & indValues$ElementCode=='B2   ' & indValues$RecStatus==' ', select=ElementValue))
                    comm3 <- sum(subset(indValues,indValues$SourceId==uNo & indValues$YrMn %in% period & indValues$ElementCode=='B4   ' & indValues$RecStatus==' ', select=ElementValue))
                    comm <- paste('FEL=',comm,'REG=',comm1,'PEL=',comm2,'OEL=',comm3)
					},
		'FLR  ' = {pris<-as.numeric(flr[flr['V1']==u][2]); delta<-5
                    comm <- sum(subset(indValues,indValues$SourceId==uNo & indValues$YrMn %in% period & indValues$ElementCode=='B3   ' & indValues$RecStatus==' ', select=ElementValue))
                    comm1 <- sum(subset(indValues,indValues$SourceId==uNo & indValues$YrMn %in% period & indValues$ElementCode=='B1   ' & indValues$RecStatus==' ', select=ElementValue))
                    comm2 <- sum(subset(indValues,indValues$SourceId==uNo & indValues$YrMn %in% period & indValues$ElementCode=='B2   ' & indValues$RecStatus==' ', select=ElementValue))
                    comm3 <- sum(subset(indValues,indValues$SourceId==uNo & indValues$YrMn %in% period & indValues$ElementCode=='B4   ' & indValues$RecStatus==' ', select=ElementValue))
                    comm <- paste('FEL=',comm,'REG=',comm1,'PEL=',comm2,'OEL=',comm3)
					},
		'UA7  ' = { pris<-as.numeric(ua7[ua7['V1']==u][2])
                    delta <- 1e-1
                    comm <- sum(subset(indValues,indValues$SourceId==uNo & indValues$YrMn %in% period & indValues$ElementCode=='C1   ' & indValues$RecStatus==' ', select=ElementValue))
                    comm1 <- sum(subset(indValues,indValues$SourceId==uNo & indValues$YrMn %in% period & indValues$ElementCode=='C2   ' & indValues$RecStatus==' ', select=ElementValue))
                    comm <- paste('AS=',comm,'HC=',comm1)
                },
		'US7  ' = {pris<-as.numeric(us7[us7['V1']==u][2]); delta<-1e-1;
                    comm <- sum(subset(indValues,indValues$SourceId==uNo & indValues$YrMn %in% period & indValues$ElementCode %in% c('C1   ','C3   ') & indValues$RecStatus==' ', select=ElementValue))
                    comm1 <- sum(subset(indValues,indValues$SourceId==uNo & indValues$YrMn %in% period & indValues$ElementCode=='C2   ' & indValues$RecStatus==' ', select=ElementValue))
                    comm <- paste('AS&MS=',comm,'HC=',comm1)
                }
		))
            #print(paste(pris,pidb))
            try(if (!is.na(pris) && !is.na(pidb)) {r <- rbind(r,compare(uNo,pris,pidb,delta,comm))})
        }
	}
close(pb)
colnames(r) <- c('Unit name','RC','Indicator','PRIS','PI DB','Absolute difference in percent','Comms')
#bot$sendMessage('PRIS comparison has been completed')
#print(r)
write.csv(r,'PrisCompareResult.csv')

