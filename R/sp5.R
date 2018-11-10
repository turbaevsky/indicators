# to calculate SP5 plot by element
r <- readRDS('PI_IndValues .rds')
h4 <- readRDS('PI_IndEffectiveDatedValues .rds')
ic <- readRDS('PI_ElementCodes .rds')
filtered <- subset(r,r$YrMn>201100 & r$ElementCode %in% c('H1   ','H2   ','H3   ') & RecStatus == ' ' & SourceCode == '  ')

yrs <- c(201100,201200,201300,201400,201500)
lst1 <- list()
lst2 <- list()
lst3 <- list()

for (n in 1:5)
	{
	if (n<=4)	{hoursPerYear <- 8760}	else	{hoursPerYear <- 8760/4*3}
	yr <- yrs[n]
	h1 <-subset(filtered,YrMn>yr & YrMn<=(yr+12) & ElementCode == 'H1   ')
	h2 <-subset(filtered,YrMn>yr & YrMn<=(yr+12) & ElementCode == 'H2   ')
	h3 <-subset(filtered,YrMn>yr & YrMn<=(yr+12) & ElementCode == 'H3   ')
	h4n <- subset(h4,ElementCode=='H4   ' & EndYrMn>yr & StartYrMn<yr, select=c(1,6))
	h14 <- merge(h1,h4n,by.x='SourceId',by.y='SourceID')
	h24 <- merge(h2,h4n,by.x='SourceId',by.y='SourceID')
	h34 <- merge(h3,h4n,by.x='SourceId',by.y='SourceID')	
	val1 <- aggregate(h14['ElementValue.x']/(h14['ElementValue.y']*hoursPerYear), h14['SourceId'],sum)[2]
	val2 <- aggregate(h24['ElementValue.x']/(h24['ElementValue.y']*hoursPerYear), h24['SourceId'],sum)[2]
	val3 <- aggregate(h34['ElementValue.x']/(h34['ElementValue.y']*hoursPerYear), h34['SourceId'],sum)[2]
	lst1[[n]]<-unlist(val1)
	lst2[[n]]<-unlist(val2)
	lst3[[n]]<-unlist(val3)
	}

boxplot(lst1,xlab='Years',ylab='value',main='Planed SP5 unavailability rate (black)',outline=F)	
boxplot(lst2,xlab='Years',ylab='value',outline=F,add=T, col='blue')	
boxplot(lst3,xlab='Years',ylab='value',outline=F,add=T, col='green')	
