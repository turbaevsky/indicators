import pyodbc
from sqlalchemy import create_engine
import pandas as pd
from tqdm import tqdm, tgrange
import re
import subprocess


def db_copy():
    #import sys
    sql_conn = pyodbc.connect("Driver={SQL Server};Server=sqllon03\\it;Database=WANO_Staging;uid=PIDBConnect;pwd=Wan0$PIDB;Trusted_Connection=No")
    query = "SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_TYPE='BASE TABLE'"
    df = pd.read_sql(query, sql_conn)
    #df.TABLE_NAME.to_csv('tables.csv')
    #sys.exit()
    engine = create_engine('sqlite:///../PI.sqlite')
    for table in tqdm(df.TABLE_NAME):
        if re.search("PI_|OE_|CORE_|SITS_",table):
            #print(table)
            q = 'SELECT * FROM '+table
            pd.read_sql(q,sql_conn).to_sql(table, con=engine, if_exists='replace', index=False)
    # remove spaces into units name
    req = 'UPDATE [PI_Place] SET [AbbrevLocName] = REPLACE([AbbrevLocName], ' ', '')'
    #for i in range(10):
    #    pd.read_sql(req,engine)
    #print(subprocess.check_output(['ls', '-l']))

    # indexing source and results
    try:
        import pandasql as ps
        req = "CREATE INDEX `val_idx` ON `PI_IndValues` (`SourceId`, `YrMn`, `ElementCode`);"
        ps.sqldf(req, locals())
        req = "CREATE INDEX `res_idx` ON `PI_Results` (`LocId`,`IndicatorCode`,`PeriodEndYrMn`,`NumOfMonths`);"
        ps.sqldf(req, locals())
    except:
        pass

    return 0

if __name__ == "__main__":
    db_copy()