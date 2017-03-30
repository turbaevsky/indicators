# Full DB copy
library(RODBC)


DBCopy <- function(session=TRUE)
	{
	print('DB copying...')
	i <- 0
	channel <- odbcConnect('SQL Staging Database',uid='PIDBConnect',pwd='Wan0$PIDB')
	tables <- sqlTables(channel,schema='dbo',tableType='TABLE')
	pb <- txtProgressBar(min = 1, max = length(t(tables[1])), style = 3)
	for (tn in t(tables[3]))
		{
		i <- i+1
		fn = paste('DBCopy/',tn,'.rds',sep='')
		#print(fn)
		#flush.console()
		setTxtProgressBar(pb, i)
                # shiny progressbar
                if (session) incProgress(1/length(t(tables[1])),detail=tn)
                # return(i)

		t<-sqlFetch(channel,tn)
		saveRDS(t,fn)
		}
	close(pb)
	odbcCloseAll()
        #system("zip.exe -r DBCopy.zip DBCopy")
	}

