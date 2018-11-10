i <- readRDS('PI_ResultsIndex .rds')
relation <- readRDS('PI_PlaceRelationship .rds')

dates <- c(201003,201006,201009,201012,
			201103,201106,201109,201112,
			201203,201206,201209,201212,
			201303,201306,201309,201312,
			201403,201406,201409,201412,
			201503,201506,201512)
			
TCunits <- relation[relation$RelationId == 1 & relation$ParentLocId == 1159,2]

Sendai <- c(1326,1468,1469)

plotting <- function(fn,index,dates,title)
	{
	print.table(c(index,dates))
	png(file = fn)
	plot(dates,index,main=title)
	# basic straight line of fit
	fit <- glm(index~dates)
	co <- coef(fit)
	abline(fit, col="blue", lwd=1)
	dev.off()
	}
			
Mean <- c()
MeanTC <- c()
Median <- c()
MedianTC <- c()
			
for (d in dates)
	{
	Mean <- c(Mean,mean(unlist(subset(i,i$PeriodEndYrMn == d & NonQualCode == ' ' & IndexId == 4,IndexValue))))
	MeanTC <- c(MeanTC,
		mean(unlist(subset(i,i$PeriodEndYrMn == d & NonQualCode == ' ' & IndexId == 4 & i$LocId %in% TCunits,IndexValue))))

	Median <- c(Median,median(unlist(subset(i,i$PeriodEndYrMn == d & NonQualCode == ' ' & IndexId == 4,IndexValue))))
	MedianTC <- c(MedianTC,
		median(unlist(subset(i,i$PeriodEndYrMn == d & NonQualCode == ' ' & IndexId == 4 & i$LocId %in% TCunits,IndexValue))))

	}

#library(R2HTML)
#dir.create("example")
#HTMLStart("example",echo = T)
	
plotting('whole_WANO.png',Mean,dates,'Overall WANO index (mean)')
#HTMLplot()
plotting('TC.png',MeanTC,dates,'WANO TC index (mean)')
#HTMLplot()
#plotting('sendai.png',MeanS,dates,'Sendai plant index')
plotting('whole_WANO_med.png',Median,dates,'Overall WANO index (median)')
#HTMLplot()
plotting('TC_med.png',MedianTC,dates,'WANO TC index (median)')
#HTMLplot()
#plotting('Sendai_med.png',MedianS,dates,'Sendai plant index (median)')
#HTMLStop()




