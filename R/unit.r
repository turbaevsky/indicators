source('functions.r')
source('shiny/data.r')
source('tisa2.r')
dates <- c(201403,201406,201409,201412,
+ 201503,201506,201509,201512,
+ 201603,201606,201609,201612)
indicators <- c('UCF  ','UCLF ','FLR  ','UA7  ','SP1  ','SP2  ','SP5  ','FRI  ','CY   ','CRE  ', 'ISA2 ','CISA2','GRLF ','US7  ','TISA', 'AS', 'MS')
unit <- 1914
table <- c()
for (d in dates){
   print(d)
   line <- c(d)
   fn <- paste('csv/TISA_',d,'.csv',sep='')
   if (!file.exists(fn)) tisa2(d,FALSE)
   tisa <- read.csv(fn)
   for (i in indicators){
       if (!(i %in% c('TISA','AS','MS'))){
           if (i %in% c('ISA2 ','CISA2','SP5  ')) uNo <- plantID(unit)
           else uNo <- unit
         res <- unlist(subset(r,LocId==uNo & IndicatorCode==i & PeriodEndYrMn==d & NumOfMonths==36 & NonQualCode==' ',ResultsValue))
	 if (!length(res)) res <- NA
	 line <- c(line,res)
	 #print(line)
	 }
      if (i=='TISA'){
         uNo <- plantID(unit)
         res <- unlist(subset(tisa,LocID==uNo,select=X3.Yr.TISA2))
         if (!length(res)) res <- NA
         line <- c(line,res)
	 #print(line)
      }
      if (i=='AS'){
         if (which(dates==d)) last <- dates[which(dates==d)-1]
	 else last <- 201312
         res <- sum(unlist(subset(data,SourceId==unit & YrMn<=d & YrMn >= last & ElementCode=='C1   ',ElementValue)))
	 if (is.nan(res)) res <- NA
	 line <- c(line,res)
	 #print(line)
	 }
      if (i=='MS'){
         if (which(dates==d)) last <- dates[which(dates==d)-1]
	 else last <- 201312
         res <- sum(unlist(subset(data,SourceId==unit & YrMn<=d & YrMn >= last & ElementCode=='C3    ',ElementValue)))
	 if (is.nan(res)) res <- NA
	 line <- c(line,res)
	 #print(line)
	 }
	 }
   table <- rbind(table,t(line))
   }
   colnames(table) <- c('date',indicators)
   print(table)
   write.csv(table,'Novovoronezh3.csv')
