#import _mssql
import sys
import sqlite3
from datetime import datetime
from tqdm import tqdm

import pandas as pd
from sqlalchemy import create_engine

engine = create_engine('sqlite:///../PI.sqlite')
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
    #connection.commit()
            
def unitcopy():

    CentreByName = {'WANA      ':'A'\
                ,'WANP      ':'P'\
                ,'WANM      ':'M'\
                ,'WANT      ':'T'}

    print('Request Station data')
    # TODO: select active units only
    dbaa = pd.read_sql('SELECT P.LocId FROM PI_Place P INNER JOIN PI_PlaceAttribute PA ON P.LocId = PA.LocId \
        WHERE AttributeTypeId = 7 AND PLaceTypeId = 19', engine)
    ##  AND P.LocId NOT IN (10117,10118,10119,10120,10121,10122,10123,10213,1871,1872)
    #print(dbaa.head(), len(dbaa))
    ulist = dbaa
    #factories = [10117,10118,10119,10120,10121,10122,10123,10213,1871,1872]  #Sellafield, La Hague and Kozloduy 3,4
    #for i in tqdm(range(len(dbaa))):
    #    #print i
    #    if not dbaa['LocId'].iloc[i].values[0][0] in factories:
    #        ulist.append(dbaa['LocId'].iloc[i].values[0][0])
    print('Done, there are %d active stations in the DB' % len(ulist))

    cursor.execute('DELETE FROM Units')
    #print('({})'.format(list(ulist.LocId)).replace('[','').replace(']',''))
    #station = pd.read_sql('Select DISTINCT ParentLocId FROM PI_PlaceRelationship WHERE LocId IN ({}) \
    #            AND RelationId = 4'.format(list(ulist.LocId)).replace('[','').replace(']',''), engine)
    #print(station)

    for u in tqdm(list(ulist.LocId)):
        un = pd.read_sql('Select AbbrevLocName FROM PI_Place WHERE LocId = {}'.format(u), engine).values[0][0]
        cursor.execute('INSERT INTO Units (UnitName,StLocId,Centre,Reactor,RUP,UnitLocId,IsStation) \
                        VALUES (?,?,?,?,?,?,?)', (un.strip(), u, '', '', '', u, 1))
        try:
            units = pd.read_sql('Select DISTINCT P.LocId FROM PI_PlaceRelationship P '
                                'INNER JOIN PI_PlaceAttribute PA ON P.LocId = PA.LocId ' 
                                'WHERE P.ParentLocId = {} AND P.RelationId = 4 '
                                'AND P.LocId <> P.ParentLocId AND PA.AttributeTypeId = 7'.format(u), engine).values
            #print(units)
            for i in units:
                cnt = pd.read_sql('Select P.LocAcronym FROM PI_Place as P INNER JOIN PI_PlaceRelationship as R '
                                           'ON P.LocId = R.ParentLocId WHERE R.LocId = {} AND RelationId = 1'.format(i[0]),
                                           engine).values[0][0]
                cnt = CentreByName[cnt]
                reactor = pd.read_sql('Select NSSSType FROM PI_UnitData D '
                                  'INNER JOIN PI_NsssTypeLookup N ON N.NsssTypeId = D.NsssTypeId'
                                  ' WHERE LocId = {}'.format(i[0]), engine).values[0][0]
                mwrate = pd.read_sql('Select MweRating FROM PI_UnitData WHERE LocId = {}'.format(i[0]), engine).values[0][0]
                uname = pd.read_sql('Select AbbrevLocName FROM PI_Place WHERE LocId = {}'.format(i[0]), engine).values[0][0]
                #print(uname,station,cnt,reactor,'',mwrate,1,u)
                cursor.execute('INSERT INTO Units (UnitName,StLocId,Centre,Reactor,RUP,UnitLocId,IsStation) \
                VALUES (?,?,?,?,?,?,?)', (uname.strip(), u, cnt, reactor.strip(), mwrate, str(i[0]), 0))
        except:
            print('Error in getting data for station {}'.format(un))
         
#===========================================================================

if __name__ == '__main__':
    unitcopy()
    #localdbupdateall('201306','201806')    # Last available data

def cls():
    connection.commit()
    connection.close()
    print('Finished')
