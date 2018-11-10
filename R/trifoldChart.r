library(ggplot2)
library(logging)
basicConfig()
setLevel('DEBUG',getHandler('basic.stdout'))

source('shiny/data.r')
source('functions.r')
source('Qreport.r')

dateRange <- c(200712,200812,200912,201012,201112,201212,201312,201412,201512,201612)
################################################################################
### LTT RCs performance
################################################################################
LTT <- function()
{
ww <- readRDS('LTT/Worldwide_LTT_201612.rds')
rc <- readRDS('LTT/RCs_LTT_201612.rds')

plot3 <- ggplot(rc,aes(unlist(Indicator),unlist(Ind.percentage),group=unlist(Centre),color=unlist(Centre)))+
    coord_polar()+
    geom_point()+
    geom_line()+
    theme(legend.title=element_blank(),axis.title.x=element_blank(),axis.title.y=element_blank())+
    ggtitle('The most recent percentage of units\nmeeting individual targets')
ggsave('plot3.png')

plot4 <- ggplot(rc,aes(unlist(Indicator),unlist(Indust.percentage),group=unlist(Centre),color=unlist(Centre)))+
    coord_polar()+
    geom_point()+
    geom_line()+
    theme(legend.title=element_blank(),axis.title.x=element_blank(),axis.title.y=element_blank())+
    ggtitle('The most recent percentage of units\nmeeting industry targets')
ggsave('plot4.png')
}
################################################################################
### Indicator's performance
################################################################################
### Read RC and WW data
### Uncomment the 4 lines below if you want to see RCs performance
data <- data.frame()
rType <- c('Reactor:AGR','Reactor:BWR','Reactor:LWCGR','Reactor:PHWR','Reactor:PWR','FBR','WANO')
# Creating data table
for (date in dateRange){
    #fn <- paste('LTT/RCs_LTT_',date,'.rds',sep='')
    #generate(date,F)
    wwfn <- paste('LTT/Worldwide_LTT_',date,'.rds',sep='')
    #d <- readRDS(fn)
    #d <- cbind(date=substr(date,1,4),d)
    #data <- rbind(data,d)
    d <- readRDS(wwfn)
    d <- cbind(date=substr(date,1,4),ReactorType='WANO',d[2:4])
    #print(d)
    data <- rbind(data,d)
### create CRE and US7 by type (Qreport.r)
    #print('Creating CRE and US7...')
    #rTypeResults(1:4,'CRE',date,T)
    #rTypeResults(1:4,'US7',date,T)
    cre.idv <- readRDS(paste('LTT/CRE_idv_',date,'.rds',sep=''))
    cre.ids <- readRDS(paste('LTT/CRE_ids_',date,'.rds',sep=''))
    us7.idv <- readRDS(paste('LTT/US7_idv_',date,'.rds',sep=''))
    us7.ids <- readRDS(paste('LTT/US7_ids_',date,'.rds',sep=''))
    for (type in 1:5){
        d <- data.frame(date=substr(date,1,4),ReactorType=rType[type],Indicator='CRE',Ind.percentage=signif(cre.idv[type]*100,3),Indust.percentage=signif(cre.ids[type]*100,3))
        #print(d)
        data <- rbind(data,d)
        #print(data)
        d <- data.frame(date=substr(date,1,4),ReactorType=rType[type],Indicator='US7',Ind.percentage=signif(us7.idv[type]*100,3),Indust.percentage=signif(us7.ids[type]*100,3))
        #print(d)
        data <- rbind(data,d)
    }
    p <- readRDS(paste('LTT/WW_SSPI_',date,'.rds',sep=''))
    d1 <- data.frame(date=substr(date,1,4),ReactorType='SP1',Indicator='SSPI',Ind.percentage=signif(sum(p[1])/sum(p[4])*100,3),Indust.percentage=NA)
    d2 <- data.frame(date=substr(date,1,4),ReactorType='SP2',Indicator='SSPI',Ind.percentage=signif(sum(p[2])/sum(p[5])*100,3),Indust.percentage=NA)
    d5 <- data.frame(date=substr(date,1,4),ReactorType='SP5',Indicator='SSPI',Ind.percentage=signif(sum(p[3])/sum(p[6])*100,3),Indust.percentage=NA)
    data <- rbind(data,d1,d2,d5)
}

loginfo('data')
#print(data)

colnames(data)[4] <- 'IndPerc'
colnames(data)[5] <- 'IndustPerc'
indPerc <- cbind(subset(data,select=c(date,ReactorType,Indicator,IndPerc)),param='Individual')
colnames(indPerc)[4] <- 'percentage'
idsPerc <- cbind(subset(data,select=c(date,ReactorType,Indicator,IndustPerc)),param='Industry')
colnames(idsPerc)[4] <- 'percentage'
dd <- rbind(indPerc,idsPerc)
loginfo('dd table')
#print(dd)
################################ Charting ##############################
ind <- c('FLR','CRE','TISA','US7','SSPI')

############################## Plot function #############################
#plt <- function(i,safety=FALSE,us7=FALSE,group='ReactorType'){
#    if (us7 & i=='US7'){
#        f <- subset(dd,Indicator==i & as.numeric(as.character(date))>=2013)
#        loginfo('us7')}
#    else
#        f <- subset(dd,Indicator==i)
#    fn <- paste(i,'_',group,'.png',sep='')
#    plt <- ggplot(f)
#    if (group=='ReactorType')
#        plt <- plt + geom_line(aes(x=date,y=unlist(percentage),group=unlist(ReactorType),color=unlist(ReactorType)))
#    else if (group=='Centre')
#        plt <- plt + geom_line(aes(x=date,y=unlist(percentage),group=unlist(Centre),color=unlist(Centre)))
#
#    if (!safety){
#        plt <- plt +
#            #geom_line(aes(x=date,y=unlist(percentage),group=unlist(ReactorType),color=unlist(ReactorType)))+
#            theme(legend.title=element_blank())+
#            geom_hline(data=idsPerc,aes(yintercept=75,color='Industry objective'))+
#            geom_hline(data=indPerc,aes(yintercept=100,color='Individual objective'))+
#            facet_grid(param~.)+
#            ggtitle(paste(i,'performance'))+
#            scale_y_continuous(name="Percentage of units that met target")+
#            scale_x_discrete(name="Year")
#        if (i=='FLR' || i=='TISA') plt <- plt+scale_color_manual(values=c("#FF0033","#FFCC00","#CC33CC"))
#        else  plt <- plt+scale_color_manual(values=c("#FF0033","#FFCC00","#FF9900","#FF3300","#33FF00","#330099","#996633","#CC33CC"))
#        ggsave(fn)
#}
#    else if (safety){
#        plt <- plt +
#            theme(legend.title=element_blank())+
#            geom_hline(data=idsPerc,aes(yintercept=100,color='Industry objective'))+
#            geom_hline(data=indPerc,aes(yintercept=100,color='Individual objective'))+
#            facet_grid(param~.)+
#            ggtitle(paste(i,'performance'))+
#            scale_y_continuous(name="Percentage of units that met target")+
#            scale_x_discrete(name="Year")
#        plt <- plt+scale_color_manual(values=c("#FF0033","#FFCC00","#FF9900","#FF3300","#996633","#CC33CC"))
#        ggsave(fn)
#    }
#    return(plt)
#}


############################## Plotting #############################
for (i in ind){
    if (i=='SSPI') plt(i,T,F)
    else if (i=='US7') plt(i,F,T)
    else plt(i,F,F)
    }

################################################################################
### Metrics info
################################################################################
plotMetrics <- function()
{
print('Calculate and plot metrics...')
M <- data.frame()
cByCode <- c('AC','MC','PC','TC')
mByCode <- c('PI1','LTP2','PI2andLTP1')
dR <- dateRange

for (d in dR){
    metrics(d,1:4,F)
    fn <- paste('metrics/metrics_',d,'.rds',sep='')
    file <- readRDS(fn)
    #print(d)
    #print(file)
    #print(paste('file',fn,'has been read'))
    for (metric in c(1:3)){
        for (centre in c(1:4)){
            M <- rbind(M,cbind(d,mByCode[metric],cByCode[centre],file[metric,centre]))
        }}}
colnames(M) <- c('date','metrics','centre','value')
#print(M)
plt2 <- ggplot(M)+
    geom_path(aes(x=factor(date),y=as.numeric(as.character(value)),group=factor(centre),color=factor(centre)))+
    theme(legend.title=element_blank(),axis.title.y=element_blank(),axis.text.x = element_text(angle = 30, hjust = 1))+
    facet_grid(metrics~.,scales="free_y")+
    ylab('Number')+
    xlab('Quarter')+
    ggtitle('PI programme metrics')
ggsave('metrics.png')
}

#- PI-1 metric: unit(s) sent data to RC out of 45 days period, number
#  (target is 0);
#- LTP-2 metric: time RC promoted data, days (target is 60);
#- PI-2 metric: unit(s) did not report 100% source data (based on
#  calculated results), number (target is 0 units);
