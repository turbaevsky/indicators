# Full DB copy
library(RODBC)


DBCopy <- function(session=TRUE)
	{
	print('DB copying...')
	i <- 0
        #memory.size(256000)
	#channel <- odbcConnect('WANO_Staging',uid='PIDBConnect',pwd='Wan0$PIDB')
        channel <- odbcDriverConnect("Driver={SQL Server};Server=sqllon03\\it;Database=WANO_Staging;uid=PIDBConnect;pwd=Wan0$PIDB;Trusted_Connection=No")
	tables <- sqlTables(channel,schema='dbo',tableType='TABLE')
        tables <- unlist(tables[3])
        tbl <- c()
        for (pi in grep('PI_',tables))
            tbl <- c(tbl,tables[pi])
	pb <- txtProgressBar(min = 1, max = length(tbl), style = 3)
	for (tn in tbl)
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

