#import _mssql
import sys
import sqlite3
from datetime import datetime
from tqdm import tqdm

import pandas as pd
from sqlalchemy import create_engine
engine = create_engine('sqlite:///PI.sqlite')

#pwd = ['205.152.199.21','London_PIDB','Wan0$PIDB']
#pwd = ['SQLLON03\IT','PIDBConnect','Wan0$PIDB']
#print('Connecting...')
#dbaa = _mssql.connect(server=pwd[0], user=pwd[1], \
#                      password=pwd[2], database='DBAA')
#dbwn = _mssql.connect(server=pwd[0], user=pwd[1], \
#                      password=pwd[2], database='DBWN')
#dbwp = _mssql.connect(server=pwd[0], user=pwd[1], \
#                      password=pwd[2], database='DBWP')
#print('Connected')
connection=sqlite3.connect('pr.sqlite')
connection.text_factory = str
cursor=connection.cursor()
#---------------------------------------------------------------------------------------------
def dot():
    sys.stdout.write(".")
    sys.stdout.flush()   
#---------------------------------------------------------------------------------------------
# Check unit data

def localdbupdateall(startdate,enddate):

    cursor.execute('DELETE FROM Results')
    cursor.execute('DELETE FROM Results3')
    req = 'Select * from PI_Results where PeriodEndYrMn>={} AND (NumOfMonths = 3 OR NumOfMonths = 36)'.format(startdate)
    dbwp = pd.read_sql(req, engine)
    #print(dbwp.head())
    #counter = 0
    for i in tqdm(range(len(dbwp))):
        #counter+=1
        # Check Non-qual code
        if dbwp['NonQualCode'].iloc[i].strip() == '':
                code = None
        else:
            code = dbwp['NonQualCode'].iloc[i].strip()
        # Check period
        if dbwp['NumOfMonths'].iloc[i]==36:
            cursor.execute('INSERT INTO Results (UnitID,Indicator,EndDate,Value,Code) VALUES (?,?,?,?,?)',\
                           (str(dbwp['LocId'].iloc[i]),
                            dbwp['IndicatorCode'].iloc[i].strip(),
                            str(dbwp['PeriodEndYrMn'].iloc[i]),
                            dbwp['ResultsValue'].iloc[i],
                            str(code)))
        else:
            cursor.execute('INSERT INTO Results3 (UnitID,Indicator,EndDate,Value,Code) VALUES (?,?,?,?,?)',\
                           (str(dbwp['LocId'].iloc[i]),
                            dbwp['IndicatorCode'].iloc[i],
                            str(dbwp['PeriodEndYrMn'].iloc[i]),
                            dbwp['ResultsValue'].iloc[i],
                            str(code)))
        #if counter/1.0e3 == int(counter/1.0e3):
        #    dot()
    print('Adjusting data...')
    cursor.execute('DELETE FROM Results WHERE EndDate>?',(enddate,))
    cursor.execute('UPDATE Results SET Indicator = ? WHERE Indicator = ?',('CPI','CY'))
    cursor.execute('DELETE FROM Results3 WHERE EndDate>?',(enddate,))
    cursor.execute('UPDATE Results3 SET Indicator = ? WHERE Indicator = ?',('CPI','CY'))
    print('Done')
    print('Set the updatind and DB date...')
    lastResult = pd.read_sql('Select DataEffectiveDate from PI_DataStatus',engine).values[0][0]
    lastResult = datetime.today()
    cursor.execute('UPDATE metadata SET value = ? WHERE name = ?',(lastResult.strftime('%Y-%m-%d'),'LastResult'))
    cursor.execute('UPDATE metadata SET value = ? WHERE name = ?',(datetime.now().strftime('%Y-%m-%d'),'LastDBUpdate'))
    print('Done')
    connection.commit()
            
def unitcopy():

    CentreByName = {'WANA      ':'A'\
                ,'WANP      ':'P'\
                ,'WANM      ':'M'\
                ,'WANT      ':'T'}

    print('Request Unit data')
    # TODO: select active units only
    dbaa = pd.read_sql('Select P.LocId, P.AbbrevLocName from PI_Place as P, PI_PlaceAttribute as PA \
    WHERE PA.LocId = P.LocId \
    AND PA.AttributeTypeId = 7 \
    AND PA.PlaceAttributeId = 22 \
    ORDER BY P.AbbrevLocName', engine)
    print(dbaa.head())
    ulist = []
    factories = [10117,10118,10119,10120,10121,10122,10123,10213,1871,1872] #Sellafield and La Hague and Kozloduy 3,4
    for i in tqdm(range(len(dbaa))):
        #print i
        if not dbaa['LocId'].iloc[i].values[0][0] in factories:
            ulist.append(dbaa['LocId'].iloc[i].values[0][0])
    print('Done, there are %d active units in the DB' % len(ulist))

    cursor.execute('DELETE FROM Units')

    for u in ulist:
        dot()
        station = dbaa.execute_scalar('Select ParentLocId FROM PI_PlaceRelationships WHERE LocId = %d \
            AND RelationId = 4',u)
        cnt = CentreByName[dbaa.execute_scalar('Select P.LocAcronym FROM PI_Place as P,\
            PI_PlaceRelationships as R \
            WHERE R.LocId = %d AND R.RelationId = 1 AND P.LocId = R.ParentLocId \
            AND R.EndDate >= %f',(u,datetime.today()))]
        reactor = dbaa.execute_scalar('Select NSSSType FROM dbo.UnitData WHERE LocId = %d',u)
        mwrate = dbaa.execute_scalar('Select MweRating FROM dbo.UnitData WHERE LocId = %d',u)
        uname = dbaa.execute_scalar('Select AbbrevLocName FROM dbo.Place WHERE LocId = %d',u)
        cursor.execute('INSERT INTO Units (UnitName,StLocId,Centre,Reactor,SubType,RUP,IsActive,UnitLocId) \
            VALUES (?,?,?,?,?,?,?,?)', (uname.strip(),station,cnt,reactor.strip(),'',mwrate,1,u))
         
#===========================================================================
unitcopy()
localdbupdateall('201306','201806')    # Last available data

connection.commit()
connection.close() 
#dbaa.close()
#dbwn.close()
#dbwp.close()
print('Finished')
