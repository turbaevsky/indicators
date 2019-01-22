from sqlalchemy import create_engine
import pandas as pd
from tqdm import tqdm
import logging
logging.basicConfig(level=logging.DEBUG)

import sys
sys.path.append('../python')
import functions as f

engine = create_engine('sqlite:///../PI.sqlite')

fields = ['CENTRE','MEMBER','UNIT NAME','REACTOR TYPE','Chemistry Group Code',
              'NSSS VENDOR','MWe RATING','Commercial Operation DATE',
              'Nominal Operating Cycle Months','1-Yr UCF','1-Yr UCF Data Code',
              '18-Mo UCF','18-Mo UCF Data Code','2-Yr UCF','2-Yr UCF Data Code',
              '3-Yr UCF','3-Yr UCF Data Code','1-Yr UCL','1-Yr UCL Data Code',
              '18-Mo UCL','18-Mo UCL Data Code','2-Yr UCL','2-Yr UCL Data Code',
              '3-Yr UCL','3-Yr UCL Data Code','1-Yr FLR','1-Yr FLR Data Code',
              '18-Mo FLR','18-Mo FLR Data Code','2-Yr FLR','2-Yr FLR Data Code',
              '3-Yr FLR','3-Yr FLR Data Code','1-Yr UA7','1-Yr UA7 Data Code',
              '18-Mo UA7','18-Mo UA7 Data Code','2-Yr UA7','2-Yr UA7 Data Code',
              '3-Yr UA7','3-Yr UA7 Data Code','1-Yr SP1','1-Yr SP1 Data Code',
              '18-Mo SP1','18-Mo SP1 Data Code','2-Yr SP1','2-Yr SP1 Data Code',
              '3-Yr SP1','3-Yr SP1 Data Code','1-Yr SP2','1-Yr SP2 Data Code',
              '18-Mo SP2','18-Mo SP2 Data Code','2-Yr SP2','2-Yr SP2 Data Code',
              '3-Yr SP2','3-Yr SP2 Data Code','1-Yr SP5','1-Yr SP5 Data Code',
              '18-Mo SP5','18-Mo SP5 Data Code','2-Yr SP5','2-Yr SP5 Data Code',
              '3-Yr SP5','3-Yr SP5 Data Code','Most Recent Operating Quarter FRI (Microcuries)',
              'Most Recent Operating Quarter FRI (Becquerels)','*FRI (No Units of Measure)',
              'FRI Data Code','1-Yr CPI','1-Yr CPI Data Code','18-Mo CPI','18-Mo CPI Data Code',
              '2-Yr CPI','2-Yr CPI Data Code','3-Yr CPI','3-Yr CPI Data Code','1-Yr CRE (Man-Rem)',
              '1-Yr CRE (Man-Sieverts)','1-Yr CRE Data Code','18-Mo CRE (Man-Rem)',
              '18-Mo CRE (Man-Sieverts)','18-Mo CRE Data Code','2-Yr CRE (Man-Rem)',
              '2-Yr CRE (Man-Sieverts)','2-Yr CRE Data Code','3-Yr CRE (Man-Rem)',
              '3-Yr CRE (Man-Sieverts)','3-Yr CRE Data Code',
              '1-Yr ISA1 (per 1,000,000 man-hours worked)',
              '1-Yr ISA2 (per 200,000 man-hours worked)','1-Yr ISA Data Code',
              '18-Mo ISA1 (per 1,000,000 man-hours worked)',
              '18-Mo ISA2 (per 200,000 man-hours worked)',
              '18-Mo ISA Data Code','2-Yr ISA1 (per 1,000,000 man-hours worked)',
              '2-Yr ISA2 (per 200,000 man-hours worked)',
              '2-Yr ISA Data Code','3-Yr ISA1 (per 1,000,000 man-hours worked)',
              '3-Yr ISA2 (per 200,000 man-hours worked)','3-Yr ISA Data Code',
              '1-Yr CISA1 (per 1,000,000 man-hours worked)',
              '1-Yr CISA2 (per 200,000 man-hours worked)',
              '1-Yr CISA Data Code','18-Mo CISA1 (per 1,000,000 man-hours worked)',
              '18-Mo CISA2 (per 200,000 man-hours worked)','18-Mo CISA Data Code',
              '2-Yr CISA1 (per 1,000,000 man-hours worked)',
              '2-Yr CISA2 (per 200,000 man-hours worked)',
              '2-Yr CISA Data Code','3-Yr CISA1 (per 1,000,000 man-hours worked)',
              '3-Yr CISA2 (per 200,000 man-hours worked)','3-Yr CISA Data Code',
              '1-Yr GRLF','1-Yr GRLF Data Code','18-Mo GRLF','18-Mo GRLF Data Code',
              '2-Yr GRLF','2-Yr GRLF Data Code','3-Yr GRLF','3-Yr GRLF Data Code',
              '1-Yr US7','1-Yr US7 Data Code','18-Mo US7','18-Mo US7 Data Code','2-Yr US7',
              '2-Yr US7 Data Code','3-Yr US7','3-Yr US7 Data Code', "1-Yr TISA1","1-Yr TISA2",
          "18-Mo TISA1","18-Mo TISA2","2-Yr TISA1","2-Yr TISA2","3-Yr TISA1","3-Yr TISA2", "Index"]
periods = (12,18,24,36)
indicators = ('UCF  ','UCLF ','FLR  ','UA7  ','SP1  ','SP2  ','SP5  ','FRI  ','CY   ','CRE  ',
                'ISA1 ','CISA1','GRLF ','US7  ','TISA')


def active_unit(date):
    """ select active station by available results (new approach) """
    req = 'select distinct LocId from PI_Results where PeriodEndYrMn = "{}" and NonQualCode = " "'.format(date)
    return pd.read_sql(req,engine)


def station(unit):  # return station unit belongs to
    try:
        req = 'select ParentLocId from PI_PlaceRelationship where RelationId = 4 and LocId = "{}" and EndDate > "{}"'.format(unit,'2099-01-01')
        station = pd.read_sql(req, engine).values[0][0]
        return station if unit != station else 0
    except:
        return 0


def name(uid):
    return pd.read_sql('select AbbrevLocName from PI_Place where LocId={}'.format(uid),engine).AbbrevLocName[0].strip()


def cnt(uid):
    return pd.read_sql('select LocAcronym from PI_Place P inner join PI_PlaceRelationship R on P.LocId=R.ParentLocId \
    where R.LocId={} and RelationId=1'.format(uid),engine).LocAcronym[0][3]


def mem(uid):
    return pd.read_sql('select LocAcronym from PI_Place P inner join PI_PlaceRelationship R on P.LocId=R.ParentLocId \
    where R.LocId={} and RelationId=3'.format(uid),engine).LocAcronym[0].strip()


def reactor(uid, strip=True):
    r = pd.read_sql('select NsssType from PI_NsssTypeLookup T inner join PI_UnitData D on T.NsssTypeId=D.NsssTypeId \
    where D.LocId={}'.format(uid),engine).NsssType[0]
    return r.strip() if strip else r


def cy(uid):
    try:
        cy = pd.read_sql('select GroupCode from PI_CategoryGroupUnits where LocId={}'.format(uid), engine).GroupCode[0].strip()
    except:
        cy = 'N/A'
    return cy


def vendor(uid):
    try:
        return pd.read_sql('select LocAcronym from PI_Place P inner join PI_PlaceRelationship R on P.LocId=R.ParentLocId \
        where R.LocId={} and RelationId=9'.format(uid),engine).LocAcronym[0].strip()
    except:
        return 'N/A'


def rating(uid):
    try:
        return int(pd.read_sql('select MweRating from PI_UnitData where LocId={}'.format(uid),engine).MweRating[0])
    except:
        return 'N/A'


def CO(uid): #commercial service date
    d = pd.read_sql('select UnitDate from PI_UnitDate where LocId={} and DateTypeId=4 order by UnitDate ASC'.format(uid),engine).UnitDate[0][:10]
    d = d[5:7]+'/'+d[8:10]+'/'+d[0:4]
    #print(d)
    return d


def fuel(uid):
    try:
        return int(pd.read_sql('select NumOfMonths from PI_ResultsIndexCycleMns where LocId={} and EndYrMn>=210000'.format(uid),engine).NumOfMonths[0])
    except:
        return 'N/A'


def idx(uid,date):
    try:
        return int(pd.read_sql('select IndexValue from PI_ResultsIndex where LocId={} and PeriodEndYrMn={} and IndexId=4'\
                           .format(uid,date),engine).IndexValue[0].round(3))
    except:
        return 'N/A'


def only(units):
    # remobe stations from the list
    un = []
    for u in units.LocId:
        #print(u, station(u))
        if station(u)>0:
            un.append(u)
    logging.info('There are %d active units', len(un))
    return un


def result(date):  # copy all available results
    req = 'select * from PI_Results where PeriodEndYrMn = "{}"'.format(date)
    return pd.read_sql(req,engine)


def source(date):  # copy all necessary source data for TISA
    req = "select * from PI_IndValues where YrMn >= '{}' and ElementCode in \
    ('M1   ','M2   ','M3   ','M4   ','M5   ','M6   ','M7   ','M8   ') and SourceCode = '  ' and RecStatus = ' '"\
        .format(date-300)
    return pd.read_sql(req,engine)


def d2d(date):  # convert from 201806 into date
    date = str(date)
    return str(date[:4])+'-'+str(date[4:6])+'-01'


def tisa(IV, uid, date, period=36, nom=2E5):
    #logging.debug('station ID = {}'.format(station(uid)))
    m = ['M1   ','M2   ','M3   ','M4   ','M5   ','M6   ','M7   ','M8   ']
    d = [t.strftime("%Y%m") for t in pd.date_range(start=d2d(date), periods=period/3, freq='-3M')]
    t = IV[(IV.SourceId == station(uid)) & (IV.YrMn.isin(d)) & (IV.SourceCode == '  ')]
    #logging.debug('Matrics len is {}'.format([[len(t[t.ElementCode==a]),len(t[t.ElementCode==m[0]]),a] for a in m]))
    if all(len(t[t.ElementCode==a]) == len(t[t.ElementCode==m[0]]) for a in m):
        M = [t.ElementValue[t.ElementCode == el].values.sum() for el in m]
        tisa = (M[0]+M[1]+M[2]+M[4]+M[5]+M[7])/(M[3]+M[6])*nom
        return tisa.round(3)
    else:
        logging.warning('No valid TISA results for {}'.format(name(uid)))
        return 'N/A'


def na(line, num, msg='N/A'):
    for i in range(num):
        line.append(msg)


def ind(res, u, indicator, months, round=3, factor=1.0):
    locId = station(u) if indicator in ['SP5  ', 'ISA1 ', 'ISA2 ', 'CISA1', 'CISA2'] else u
    stat = res[(res.LocId == locId) & (res.IndicatorCode == indicator) & (res.NumOfMonths == months)].NonQualCode.values
    #print('stat=',stat,'of type',type(stat))
    if stat is not None and len(stat) and stat[0] == ' ':
        val = (res[(res.LocId == locId) & (res.IndicatorCode == indicator) & (res.NumOfMonths == months) &
                   (res.NonQualCode == ' ')].ResultsValue.values[0])*factor
        val = val.round(3) if round == 3 else val
        return (val,'')
    elif stat is not None and len(stat) and stat[0] != ' ':
        return (0, stat[0].strip())
    else:
        return(0,'No stat')


def xls(date):
    logging.info(f'Copying data for {date}...')
    un = only(active_unit(date))
    #un = [1612]  # debugging
    df = pd.DataFrame()
    res = result(date)
    IV = source(date)
    logging.info('Copied')
    for u in tqdm(un):
        #print(u)
        #print('.',end='')
        line = [cnt(u),mem(u),name(u),reactor(u),cy(u),vendor(u),rating(u),CO(u),fuel(u)]
        for i in indicators:
            #print(i)
            for p in periods:
                #print(p)
                if i not in ['FRI  ', 'TISA', 'ISA1 ', 'CISA1', 'CRE  ']:
                    line.append(ind(res, u, i, p)[0])
                    line.append(ind(res, u, i, p)[1])
                elif i == 'ISA1 ':
                    line.append(ind(res, u, i, p)[0])
                    line.append(ind(res, u, 'ISA2 ', p)[0])
                    line.append(ind(res, u, i, p)[1])
                elif i == 'CISA1':
                    line.append(ind(res, u, i, p)[0])
                    line.append(ind(res, u, 'CISA2', p)[0])
                    line.append(ind(res, u, i, p)[1])
                elif i == 'FRI  ' and p==12:  # ResultsValue*3.7E4 for Bq
                    # must be last OPERATIONAL quarter
                    if reactor(u) not in ['AGR','CGR','LWCGR','FBR']:
                        line.append(ind(res, u, i, 3,round=8)[0])
                        line.append(ind(res, u, i, 3,factor=3.7E4)[0])
                        na(line,2,'')
                    else:
                        na(line, 2, '')
                        line.append(ind(res, u, i, 3, round=8)[0])
                        na(line, 1, '')
                elif i == 'CRE  ':
                    # DB saves CRE in man*Rem
                    line.append(ind(res, u, i, p)[0])  # man-rem
                    line.append(ind(res, u, i, p, factor=0.01)[0])  # man-Sv
                    line.append(ind(res, u, i, p)[1])
                elif i == 'TISA':
                    line.append(tisa(IV, u, date, p, 1E6))
                    line.append(tisa(IV, u, date, p))
        line.append(idx(u,date))
        if len(line) != 138:
            logging.warning(f'Error in line len={len(line)} for unit {u} {name(u)}: {line}')
        else:
            df = df.append(pd.DataFrame([line]),ignore_index=True)
    df.columns = fields
    df = df.sort_values('UNIT NAME')
    #df.T
    return df

def eName(eCode):
    return pd.read_sql('select ElementName from PI_ElementCodes where ElementCode = "{}"'.format(eCode), engine).values[0][0]


def DES(date,uList=None):
    units = f.centre(uList, date) if uList is not None else 0
    req = 'select SourceId, ElementCode, ElementValue from PI_IndValues where SourceId in ({}) and SourceCode = "  " ' \
          'and YrMn = {}'.format(units,date)
    res = pd.read_sql(req,engine)
    res.SourceId, res.ElementCode = res.SourceId.apply(name),  res.ElementCode.apply(eName)
    res['Date'] = date
    return  res


def uName(eCode):
    """ return unit name by EventCode using CORE_Unit """
    try:
        uByECode = pd.read_sql('select UnitCode from OE_EventUnit where EventCode={}'
                               .format(eCode), engine).UnitCode.values[0]
        uName = pd.read_sql('select UnitName from CORE_Unit where OEDBID={}'
                            .format(uByECode),engine).UnitName.values[0]
    except:
        uName = None
    return uName


def WER(year, rc=5):
    """ all OE reports for selected RC and year
    :param year: in format YYYY
    :param rc: as a number, Paris = 2, Tokyo = 5
    :return: dataFrame
    """
    tqdm.pandas()
    rep = pd.read_sql('select * from OE_Report where ReportYear = {} and CentreCode = {}'.format(year,rc),engine)
    repCode = pd.read_sql('select * from OE_EventReport', engine)  # all report and event codes
    rep['EventCode'] = rep.ReportCode.apply(
        lambda r: repCode[repCode.ReportCode == r].EventCode.values[0])  # add OE code to report page
    events = pd.read_sql('select * from OE_Event', engine)  # all events
    rep = rep.merge(events, on='EventCode', copy=False)  # all data together
    rep['link'] = rep.ReportNumber.apply(
        lambda id: 'http://www.wano.org/OperatingExperience/OE_Database_2012/Pages/EventReportDetail.aspx?ids='+str(id))
    rep.SignificanceCode = rep.SignificanceCode.progress_apply(lambda code: pd.read_sql(
        'select Significance from OE_Significance where SignificanceCode="{}"'.format(code), engine).Significance.values)
    rep['unit'] = rep.EventCode.progress_apply(lambda eCode: uName(eCode))
    rep['Category'] = rep.EventCode.progress_apply(lambda eCode: pd.read_sql(
        'select CategoryCode from OE_EventCategory where EventCode={}'.format(eCode), engine).CategoryCode.values[0])
    rep['System'] = rep.EventCode.progress_apply(lambda eCode: pd.read_sql(
        'select SystemCode from OE_EventSystem where EventCode={}'.format(eCode), engine).SystemCode.values)
    rep['Component'] = rep.EventCode.progress_apply(lambda eCode: pd.read_sql(
        'select ComponentCode from OE_EventComponent where EventCode={}'.format(eCode), engine).ComponentCode.values)
    rep['Group'] = rep.EventCode.progress_apply(lambda eCode: pd.read_sql(
        'select GroupCode from OE_EventGroup where EventCode={}'.format(eCode), engine).GroupCode.values)
    rep['RootCause'] = rep.EventCode.progress_apply(lambda eCode: pd.read_sql(
        'select RootCauseCode from OE_EventRootCause where EventCode={}'.format(eCode), engine).RootCauseCode.values)
    rep['CausalFactor'] = rep.EventCode.progress_apply(lambda eCode: pd.read_sql(
        'select CausalFactorCode from OE_EventCausalFactor where EventCode={}'.format(eCode), engine).CausalFactorCode.values)
    rep['KeywordCode'] = rep.EventCode.progress_apply(lambda eCode: pd.read_sql(
        'select KeywordCode from OE_EventKeyword where EventCode={}'.format(eCode), engine).KeywordCode.values)
    rep['Keyword'] = rep.KeywordCode.progress_apply(lambda eCode: pd.read_sql(
        'select Keyword from OE_Keyword where KeywordCode in ({})'.format(','.join([str(e) for e in eCode])), engine).Keyword.values)
    rep['POC'] = rep.EventCode.progress_apply(lambda eCode: pd.read_sql(
        'select POCCode from OE_EventPOAndC where EventCode={}'.format(eCode), engine).POCCode.values)
    #logging.debug('dropping tables from: {}'.format(list(rep)))
    rep = rep.drop(columns=['ReportTypeCode', 'CentreCode', 'ReportYear', 'ReportRevisionNumber', 'ReportDateReceived',
                            'ReportSummary', 'ReportReference', 'ReportCode', 'ReportNumber',
                            'ReportAnalysisComments', 'ReportCorrectiveActions', 'ReportPreventEvents', 'MemberCode',
                            'ReportStatusCode', 'UserID', 'ReportGrade', 'ReportNote', 'IsPreliminaryReport',
                            'ReportDateSubmission'])
    return rep


def SOER(date, uList='T'):
    tqdm.pandas()
    units = f.centre(uList, date) if uList is not None else 0

    uid = pd.read_sql('select UnitID ,UnitName from CORE_Unit where INPORef in ({})'.format(units), engine)
    visit = pd.read_sql('select UnitID, VisitID, VisitUnitID from CORE_VisitUnit', engine)
    visit = visit[visit.UnitID.isin(uid.UnitID)]
    v = pd.read_sql('select VisitID, VisitTypeID, StartDate, EndDate, YearFilter from CORE_Visit', engine)
    visit = visit.merge(v, on='VisitID')
    visit = visit[visit.YearFilter==int(str(date)[:4])].drop_duplicates(subset='VisitID')
    soer = pd.read_sql('select VisitSOERID, VisitID from SITS_VisitSOER', engine)
    visit = visit.merge(soer, on='VisitID')
    visit['VisitSOERRecID'] = visit.VisitSOERID.progress_apply(lambda recID: pd.read_sql(
        'select VisitSOERRecID from SITS_VisitSOERRec where VisitSOERID={}'.format(recID),
        engine).VisitSOERRecID.values[0])
    #visit['SOERSubRecID'] = visit.VisitSOERID.progress_apply(lambda recID: pd.read_sql(
    #    'select SOERSubRecID from SITS_VisitSOERSubRec where VisitSOERID={}'.format(recID),
    #    engine).SOERSubRecID.values[0])
    #visit['SOERSubRecCode'] = visit.SOERSubRecID.progress_apply(lambda recID: pd.read_sql(
    #    'select SOERSubRecCode from CORE_SOERSubRec where SOERRecID={}'.format(recID),
    #    engine).SOERSubRecCode.values[0])
    #visit['HasClassification'] = visit.SOERSubRecID.progress_apply(lambda recID: pd.read_sql(
    #    'select HasClassification from CORE_SOERSubRec where SOERRecID={}'.format(recID),
    #    engine).HasClassification.values[0])
    #visit['SOERID'] = visit.SOERID.progress_apply(lambda recID: pd.read_sql(
    #    'select SOERCode from CORE_SOER where SOERID={}'.format(recID),
    #    engine).SOERCode.values[0])
    #visit['SOERCode'] = visit.SOERID.progress_apply(lambda recID: pd.read_sql(
    #    'select SOERCode from CORE_SOER where SOERID={}'.format(recID),
    #    engine).SOERCode.values[0])
    visit['Notes'] = visit.VisitSOERRecID.progress_apply(lambda visitID: pd.read_sql(
        'select Notes from SITS_VisitSOERSubRec where VisitSOERRecID={}'.format(visitID), engine).Notes.values[0])
    visit['OECTNotes'] = visit.VisitSOERRecID.progress_apply(lambda visitID: pd.read_sql(
        'select OECTNotes from SITS_VisitSOERSubRec where VisitSOERRecID={}'.format(visitID), engine).OECTNotes.values[0])
    # replace UID with name
    visit.UnitID = visit.UnitID.progress_apply(lambda id: uid[uid.UnitID == id].UnitName.values[0])
    visit.VisitTypeID = visit.VisitTypeID.progress_apply(lambda id: pd.read_sql(
        'select VisitTypeCode from CORE_VisitType where VisitTypeID={}'.format(id), engine).VisitTypeCode.values[0])
    visit = visit.drop(columns=['VisitID', 'VisitUnitID','YearFilter', 'VisitSOERID', 'VisitSOERRecID'])
    print(list(visit))
    '''
    
    print(visit.tail(), '\nlen=', len(visit))

    soer = pd.read_sql('select VisitSOERRecID, SOERRecID, CreateDate from SITS_VisitSOERRec', engine).drop_duplicates()
    soer = soer[soer.SOERRecID.isin(visit.SOERRecID)].drop_duplicates()
    visit = visit.merge(soer, on='SOERRecID').drop_duplicates()
    print(visit.tail(), '\nlen=', len(visit))
    soer = pd.read_sql('select VisitSOERRecID, Notes, OECTNotes from SITS_VisitSOERSubRec', engine).drop_duplicates()
    visit = visit.merge(soer, on='VisitSOERRecID').drop_duplicates()
    visit.UnitID = visit.UnitID.progress_apply(lambda id: uid[uid.UnitID == id].UnitName.values[0])
    visit['VisitSOERID'] = visit.VisitID.progress_apply(lambda visitID: pd.read_sql(
        'select VisitSOERID from SITS_VisitSOER where VisitID={} and VisitSOERID is not null'.format(visitID), engine).VisitSOERID.values)
    visit['VisitSOERID'] = visit.VisitID.progress_apply(lambda visitID: pd.read_sql(
        'select VisitSOERID from SITS_VisitSOER where VisitID={} and VisitSOERID is not null'.format(visitID),
        engine).VisitSOERID.values)
    visit['Notes'] = visit.VisitSOERRecID.progress_apply(lambda visitID: pd.read_sql(
        'select Notes from SITS_VisitSOERSubRec where VisitSOERRecID={}'.format(visitID), engine).Notes.values[0])
    visit['OECTNotes'] = visit.VisitSOERRecID.progress_apply(lambda visitID: pd.read_sql(
        'select OECTNotes from SITS_VisitSOERSubRec where VisitSOERRecID={}'.format(visitID), engine).OECTNotes.values[0])
    
    visit['VisitType'] = visit.VisitID.progress_apply(lambda visitID: pd.read_sql(
        'select VisitTypeID from CORE_Visit where VisitID={}'.format(visitID), engine).VisitTypeID.values[0])
    visit.VisitType = visit.VisitType.progress_apply(lambda visitTypeID: pd.read_sql(
        'select VisitType from CORE_VisitType where VisitTypeID={}'.format(visitTypeID), engine).VisitType.values[0])
    visit['YearFilter'] = visit.VisitID.progress_apply(lambda visitID: pd.read_sql(
        'select YearFilter from CORE_Visit where VisitID={}'.format(visitID), engine).YearFilter.values[0])
    year = int(str(date)[:4])
    visit = visit[visit.YearFilter==year]
    visit['StartDate'] = visit.VisitID.progress_apply(lambda visitID: pd.read_sql(
        'select StartDate from CORE_Visit where VisitID={}'.format(visitID), engine).StartDate.values[0])
    visit['EndDate'] = visit.VisitID.progress_apply(lambda visitID: pd.read_sql(
        'select EndDate from CORE_Visit where VisitID={}'.format(visitID), engine).EndDate.values[0])
    print(visit.tail())
    '''
    print(visit.head())
    return visit

if __name__ == '__main__':
    #for d in [201512, 201612, 201712,201812]:
    #    xls(d)
    logging.info('Starting...')
    date = 201809
    fn = 'reports/xls/' + str(date)[:4] + '_WANO_PIData_Rev.xls'
    writer = pd.ExcelWriter(fn)
    xls(date).to_excel(writer,sheet_name='PI Spreadsheet', index=False)
    logging.info(f'Spreadsheet successfully written into {fn}')
    #DES(date,'T').to_excel(writer, sheet_name='PI-DES', index=False)
    #ogging.info(f'DES successfully written into {fn}')
    #WER(int(str(date)[:4])).to_excel(writer, sheet_name='WER', index=False)
    #logging.info(f'WER successfully written into {fn}')
    #SOER(date,'T').to_excel(writer, sheet_name='SOER', index=False)
    #logging.info(f'SOER successfully written into {fn}')
    writer.save()
    logging.info(f'All successfully written into {fn}')
