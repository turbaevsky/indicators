#library(tm)
library(wordcloud)
#library(memoise)

events <- readRDS('DBCopy/OE_Event.rds')
eByKey <- readRDS('DBCopy/OE_EventKeyword.rds')
dCause <- readRDS('DBCopy/OE_DirectCause.rds')

eByKey <- unlist(subset(eByKey,KeywordCode %in% c(646,871),EventCode)) # 646 means manual scram, 871 - AS
events <- subset(events,EventCode %in% eByKey & as.Date(EventDate) >= as.Date('2007-01-01'))
#print(length(unlist(events)))
directCause <- unlist(subset(events,select=DirectCauseCode))
directCause <- directCause[!is.na(directCause)]
wordcloud <- c()
for (i in directCause)
    wordcloud <- c(wordcloud,subset(dCause,DirectCauseCode == i,DirectCause))
#word <- as.character(wordcloud)
                                        #hist(directCause)
print(wordcloud)
wordcloud(unlist(wordcloud),random.order=FALSE)
