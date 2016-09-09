# This procedure returns the annual average whole the WANO data promoting time
# It is so called PI metric
submit <- readRDS('DBCopy/PI_DataSubmittal.rds')
qtr <-c('2015-07-01','2015-10-01','2016-01-01','2016-04-01')
date <- c(201506,201509,201512,201603)
dd <- c()
for (i in c(1:4))
	{
	sub <- as.Date(subset(submit,submit$YrMn==date[i],ProductionDate)[,1])
	d <- max(sub,na.rm=T)
	dd <- c(dd,d-as.Date(qtr[i]))
	}
print(mean(dd))