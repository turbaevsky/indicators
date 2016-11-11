#########################################################################################################
# This soft provides indicator statistics including quartile data distribution
#########################################################################################################

# 5-years indicator statistics
# library(ggplot2)

source('functions.r')

################# Hid and his might be replaced by lists (see data.r) in indicators.r ###
hid <- function(i)
{return(switch(
		i,
		'CISA2' = 0.5,
		'ISA2 ' = 0.5,
		'TISA2' = 0.5,
		'FLR  ' = 5,
		'SP1  ' = 0.02,
		'SP2  ' = 0.02,
		'SP5  ' = 0.025
		))}
his <- function(i)
{return(switch(
		i,
		'CISA2' = 0.2,
		'ISA2 ' = 0.2,
		'TISA2' = 0.2,
		'FLR  ' = 2,
		'SP1  ' = 0.02,
		'SP2  ' = 0.02,
		'SP5  ' = 0.025
 ))}

#lims <- function(b){return(paste(b$stats[2],b$stats[3],b$stats[4],100/abs(as.numeric(b$stats[4])-as.numeric(b$stats[2]))))}
 # lims for LTT-2025
limNum <- c(3,4) # Number of boxplot.stats limits; 3 means median, 4 means upper hinge
lims <- function(b){return(paste('&',signif(b$stats[limNum[1]],2),'&',signif(b$stats[limNum[2]],2),'\\'))} #'&',signif(100/abs(as.numeric(b$stats[4])-as.numeric(b$stats[2])),2),'\\'))}

#r <- readRDS('DBCopy/PI_Results.rds')
#ic <- readRDS('DBCopy/PI_IndicatorCodes.rds')
#ic <- unlist(t(subset(ic,ic$IsActive== 1)[1]))
#relation <- readRDS('DBCopy/PI_PlaceRelationship.rds')
                                        #print(ic)

#ic <- i
#ic <- c(ic,"TISA2")
#print(ic)
UnitData <- uData
#place <- readRDS('DBCopy/PI_Place.rds')
# List of reactor by type ##########################
#rType <- c('AGR','BWR','LWCGR','PHWR','PWR')
#rTypeCode <- c(1,3,12,13,14)
#uType <- list()
#for (t in c(1:5))
#{uType$rType[t] <- subset(UnitData,NsssTypeId == rTypeCode[t],select = 1)}

# Units by centre ##################################
#centreCode <- c(1155,1158,1156,1159)	#AC,MC,PC,TC
#centreNames <- c('AC','MC','PC','TC')
#unitsByCentre <- list()
#for (centre in c(1:4))
#	{ unitsByCentre$uList[centre] <- unique(subset(relation,relation$ParentLocId == centreCode[centre]
                                        #		& relation$RelationId == 1 & relation$EndDate >= '9999-01-01', select=LocId)) }

uType <- uByType() # from functions.r
unitsByCentre <- uByCentre() # from functions.r
####################################################################################
dateList <- c(200712,200812,200912,201012,201112,201212,201312,201412,201512,201606)
lastDate <- tail(dateList,1)
####################################################################################
NumOfMonths <- 36

# Define list of units by RC

# Calculate the trend and plot a picture =================================================
indicatorSummary <- function(i,outliers=FALSE,rT)
{
#print(i)
if (i %in% c("CRE  ","US7  "))
	{ creId <- 0; us7Id <- 0; creIs <- 0; us7Is <- 0 # Individual and industry targets
	  creIdTg <- c(10,180,320,200,90)
	  creIsTg <- c(5,125,240,115,70)
	  us7IdTg <- c(2,1,1,1.5,1)
	  us7IsTg <- c(1,0.5,0.5,1,0.5)
	  creSum <- 0; us7Sum <- 0
	#for (type in c(1:5))
        #{
          type <- which(rType == rT)
          print(rT)
          print(type)
          res <- subset(r,r$IndicatorCode==i & r$PeriodEndYrMn %in% dateList
                        & r$NumOfMonths == 36 & r$NonQualCode != 'M' & r$LocId %in% unlist(uType$rType[type]))
          lastRes <- subset(r,r$IndicatorCode==i & r$PeriodEndYrMn == lastDate
                            & r$NumOfMonths == 36 & r$NonQualCode != 'M' & r$LocId %in% unlist(uType$rType[type]))
		#print(paste(i,rType[type]))
		#print('All results')
		#print(summary(res))
		#print('Last results')
		#print(summary(lastRes))
          b <- boxplot.stats(unlist(res[5]))
          print(paste(i,rType[type],lims(b))) # print the data quartiles
          l <- length(b$out)/length(dateList) # Average number of outliers a year
		#print('Ouliers:')
          m <- merge(lastRes,place,by="LocId")
          lim <- boxplot.stats(unlist(lastRes[5]))$stats[5] # Higher extreme
          outLiers <- subset(m,m$ResultsValue>lim,select=c(AbbrevLocName,ResultsValue)) # outliers
		#print(outLiers)
          s <- b$stats
		#print(s)
		#print(l)
		#print('Last results/limits')
          b <- boxplot.stats(unlist(lastRes[5]))
		#print(b$stats)
		#print('Length of dataset:')
		#print(length(unlist(lastRes[5])))
		#print('Median:')
		#print(median(unlist(lastRes[5])))
		#print('Length of outliers')
		#print(length(b$out))
		# Units met the targets
          if (i == 'CRE  ')
          {creId <- creId + length(unlist(subset(lastRes,lastRes$ResultsValue<=creIdTg[type],select=LocId)))
              creIs <- creIs + length(unlist(subset(lastRes,lastRes$ResultsValue<=creIsTg[type],select=LocId)))
              creSum <- creSum + length(lastRes$LocId)
          }
          if (i == 'US7  ')
          {us7Id <- us7Id + length(unlist(subset(lastRes,lastRes$ResultsValue<=us7IdTg[type],select=LocId)))
              us7Is <- us7Is + length(unlist(subset(lastRes,lastRes$ResultsValue<=us7IsTg[type],select=LocId)))
              us7Sum <- us7Sum + length(lastRes$LocId)
          }
                                        # Plot
          fn = paste("pict/",i,"-",rType[type],".png",sep="")
          fn2 = paste("pict/",i,"-",rType[type],"-out.png",sep="")
          mTitle <- paste(i,rType[type])
          if (i == 'CRE  ')
          {
              ylab <- 'man-Rem'
              hid <- creIdTg[type]
              his <- creIsTg[type]
          }
          else
          {
              ylab <- 'number per 7,000 critical hours'
              hid <- us7IdTg[type]
              his <- us7IsTg[type]
          }
          png(fn)
          mval <- boxplot.stats(t(res[5]))
          mval <- mval$stats[length(mval$stats)]
          boxplot(t(res[5])~t(res[3]),outline = FALSE,notch=F,col='royalblue2',fg = "grey")
		### Reverce chart
		#boxplot(t(res[5])~t(res[3]),outline = FALSE,notch=F,col='royalblue2',fg = "grey",ylim = c(mval,min(res[5])))

		#ggplot(t(res[5])~t(res[3]),aes(x=res[3],y=res[5],color=res[5])) + geom_point()
		#means <- by(t(res[5]),t(res[3]),mean)
		#points(1:2, means, pch = 23, cex = 0.75, bg = "red")
		#text(1:2 - 0.4, means, labels = formatC(means, format = "f", digits = 1),
		#	pos = 2, cex = 0.9, col = "red")
          abline(h=hid, col = 'red', lwd = 3)
		#text(1,hid,"Individual target",col="red",adj = c(-.1,-.5))
          abline(h=his, col = 'green', lwd = 3)
		#text(1,his,"Industry target",col="green",adj = c(-.1,-.5))
          legend("topright", inset=.05, title="Targets",
                 c(paste("Individual =",hid),paste("Industry =",his)), fill=c("red","green"), horiz=FALSE)
		#qplot(factor(PeriodEndYrMn),ResultsValue,data=res, geom=c("boxplot"),xlab='quarter',main=i,ylab=ylab)
          title(main=mTitle,xlab='quarter',ylab = ylab)
          dev.off()
          png(fn2)
          boxplot(t(res[5])~t(res[3]),outline = TRUE,notch=F,col='royalblue2',fg = "grey")
		### Reverce chart
		#boxplot(t(res[5])~t(res[3]),outline = TRUE,notch=F,col='royalblue2',fg = "grey",ylim = c(max(res[5]),min(res[5])))
          abline(h=hid, col = 'red', lwd = 3)
          abline(h=his, col = 'green', lwd = 3)
          title(main=mTitle,xlab='quarter',ylab = ylab)
          legend("topright", inset=.05, title="Targets",
                 c(paste("Individual =",hid),paste("Industry =",his)), fill=c("red","green"), horiz=FALSE)
          dev.off()

### plotting fot shiny ###
          boxplot(t(res[5])~t(res[3]),outline = outliers,notch=F,col='royalblue2',fg = "grey")
          abline(h=hid, col = 'red', lwd = 3)
          abline(h=his, col = 'green', lwd = 3)
          title(main=mTitle,xlab='quarter',ylab = ylab)
          legend("topright", inset=.05, title="Targets",
                 c(paste("Individual =",hid),paste("Industry =",his)), fill=c("red","green"), horiz=FALSE)
        }
	#if (i == 'CRE  ')
	#	{print(creId/creSum*100)
	#	print(creIs/creSum*100)}
	#if (i == 'US7  ')
	#	{print(us7Id/us7Sum*100)
	#	print(us7Is/us7Sum*100)}

if (i == "TISA2")
{
    #options(stringsAsFactors = FALSE, checknames = FALSE)
                                        #Tisa <- data.frame()
    Tisa <- c()
	for (d in dateList)
		{
		#tisa2(d)	# Uncomment it if you need to recalculate results
		fn <- paste('csv/TISA_',d,'.csv',sep='')
		tisa <- read.csv(fn)
		tisa <- tisa['X3.Yr.TISA2']
		#tisa <- boxplot.stats(tisa,do.conf=F,do.out=F)
		Tisa <- c(Tisa,tisa)
		#tisa <- c(d,tisa)
		}
                                        #Tisa <- Tisa[2:10]
    #print(Tisa)
    #print(structure(Tisa))
	#colnames(Tisa) <- dateList

	# Plotting
	fn = paste("pict/",i,".png")
	fn2 = paste("pict/",i,"-out.png")
	# No outliers
	png(fn)
	#boxplot(t(res[5])~t(res[3]),outline = FALSE,notch=F,col='royalblue2',fg = "grey",ylim = c(mval,min(res[5])))
	#print(max(Tisa,na.rm=T))

	b <- boxplot.stats(unlist(Tisa))
	print(paste(i,lims(b)))
	boxplot(Tisa,outline = F,notch=F,col='royalblue2',las=2,names=dateList)
	### Reverce chart
	#boxplot(Tisa,outline = F,notch=F,col='royalblue2',ylim=c(boxplot.stats(Tisa)$stats[4],0))
	abline(h=hid(i), col = 'red', lwd = 3)
	abline(h=his(i), col = 'green', lwd = 3)
	title(main=i,xlab='',ylab = ylab(i))
	legend("topright", inset=.05, title="Targets",
		c(paste("Individual =",hid(i)),paste("Industry =",his(i))), fill=c("red","green"), horiz=FALSE)
	dev.off()
	# With outliers
	png(fn2)
	boxplot(Tisa,outline = T,notch=F,col='royalblue2',names=dateList)
### Reverce chart
	#boxplot(Tisa,outline = T,notch=F,col='royalblue2',ylim=c(max(Tisa,na.rm=T),0))
	abline(h=hid(i), col = 'red', lwd = 3)
	abline(h=his(i), col = 'green', lwd = 3)
	title(main=i,xlab='quarter',ylab = ylab(i))
	legend("topright", inset=.05, title="Targets",
		c(paste("Individual =",hid(i)),paste("Industry =",his(i))), fill=c("red","green"), horiz=FALSE)
    dev.off()
### plotting ###
    boxplot(Tisa,outline = outliers,notch=F,col='royalblue2',names=dateList)
    abline(h=hid(i), col = 'red', lwd = 3)
    abline(h=his(i), col = 'green', lwd = 3)
    title(main=i,xlab='quarter',ylab = ylab(i))
    legend("topright", inset=.05, title="Targets",
           c(paste("Individual =",hid(i)),paste("Industry =",his(i))), fill=c("red","green"), horiz=FALSE)
	}
 #################################### any other indicators ###############################
if (!i %in% c("CRE  ","US7  ","TISA2"))
{
    print('Other indicators...')
	res <- subset(r,r$IndicatorCode==i & r$PeriodEndYrMn %in% dateList &
		r$NumOfMonths == 36 & r$NonQualCode != "M")
	lastRes <- subset(r,r$IndicatorCode==i & r$PeriodEndYrMn == lastDate &
		r$NumOfMonths == 36 & r$NonQualCode != "M")

	#print(summary(res))
	#print(i)
	#print(summary(res))
	#print('Last results:')
	#print(summary(lastRes))
	b <- boxplot.stats(unlist(res[5]))
	print(paste(i,lims(b)))
	l <- length(b$out)/length(dateList) # Average number of outliers a year
	s <- b$stats
	#print('Summary results')
	#print(s)
	#print('Lenght of dataset')
	#print(l)
	#print('Last results: outliers:')
	# Merge the units name with results
	m <- merge(lastRes,place,by="LocId")
	lim <- boxplot.stats(unlist(lastRes[5]))$stats[5] # Higher extreme
	outLiers <- subset(m,m$ResultsValue>lim,select=c(AbbrevLocName,ResultsValue)) # outliers
	#print(outLiers)
	b <- boxplot.stats(unlist(lastRes[5]))
	#print(b$stats)
	#print(length(b$out))
	fn = paste("pict/",i,".png")
	fn2 = paste("pict/",i,"-out.png")
	png(fn)
	mval <- boxplot.stats(t(res[5]))
	mval <- mval$stats[length(mval$stats)]
	boxplot(t(res[5])~t(res[3]),outline = FALSE,notch=F,col='royalblue2')
	### Reverce chart
	#boxplot(t(res[5])~t(res[3]),outline = FALSE,notch=F,col='royalblue2',ylim = c(mval,min(res[5])))
	abline(h=hid(i), col = 'red', lwd = 3)
	abline(h=his(i), col = 'green', lwd = 3)
	#qplot(factor(PeriodEndYrMn),ResultsValue,data=res, geom=c("boxplot"),xlab='quarter',main=i,ylab=ylab)
	title(main=i,xlab='quarter',ylab=ylab(i))
	if (!is.null(his(i)) && !is.null(hid(i)))
	{legend("topright", inset=.05, title="Targets",
			c(paste("Individual =",hid(i)),paste("Industry =",his(i))), fill=c("red","green"), horiz=FALSE)}
	dev.off()
	png(fn2)
	boxplot(t(res[5])~t(res[3]),outline = TRUE,notch=F,col='royalblue2')
	### Reverce chart
	#boxplot(t(res[5])~t(res[3]),outline = TRUE,notch=F,col='royalblue2',ylim = c(max(res[5]),min(res[5])))
	abline(h=hid(i), col = 'red', lwd = 3)
	abline(h=his(i), col = 'green', lwd = 3)
	title(main=i,xlab='quarter',ylab=ylab(i))
	if (!is.null(his(i)) && !is.null(hid(i)))
	{legend("topright", inset=.05, title="Targets",
			c(paste("Individual =",hid(i)),paste("Industry =",his(i))), fill=c("red","green"), horiz=FALSE)}
	dev.off()
### plotting ###
	boxplot(t(res[5])~t(res[3]),outline = outliers,notch=F,col='royalblue2')
	abline(h=hid(i), col = 'red', lwd = 3)
	abline(h=his(i), col = 'green', lwd = 3)
	title(main=i,xlab='quarter',ylab=ylab(i))
	if (!is.null(his(i)) && !is.null(hid(i)))
	{legend("topright", inset=.05, title="Targets",
                c(paste("Individual =",hid(i)),paste("Industry =",his(i))), fill=c("red","green"), horiz=FALSE)}
	}
}

# ============================================= Main cycle =======================================================

#if (readline('Need you update the Db copy (Y/n)?')=='Y')
#{
#source('fullDBCopy.R')
#print('DB copying...')
#DBCopy()	# Provide the last Db copy
#}

#lastDate <- readline('What is the last Date (in format 201603)?')
########### Insert data list checking here ############

#if (readline('Need you update TISA calculation (Y/n)?')=='Y')
#{
#source('tisa2.r')
#print('TISA2 calculation...')
#tisa2(lastDate)	# Provide the last date for analysis
#}

#pb <- txtProgressBar(min = 1, max = length(unlist(ic)), style = 3)
#no <- 0
#ic <- 'TISA2'
#print(ic)
#for (i in ic)
#	{
	#print(i)
#	no <- no + 1
	#setTxtProgressBar(pb, no)
#	indicatorSummary(i)
#	}
#close(pb)

# TODO: Add outliers as a plan of focus candidate
