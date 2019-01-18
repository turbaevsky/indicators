from sqlalchemy import create_engine
engine = create_engine('sqlite:///../PI.sqlite')


import matplotlib.pyplot as plt
from datetime import datetime
plt.style.use('ggplot')
import pandas as pd
from tqdm import tqdm
import os
import logging
logging.basicConfig(level=logging.DEBUG)
### https://realpython.com/python-logging/
#logging.basicConfig(filename='app.log', filemode='w', format='%(name)s - %(levelname)s - %(message)s')
#logging.basicConfig(format='%(asctime)s - %(message)s', level=logging.INFO)
#logging.basicConfig(format='%(asctime)s - %(message)s', datefmt='%d-%b-%y %H:%M:%S')
#except Exception as e:
#  logging.error("Exception occurred", exc_info=True)
# or
#  logging.exception("Exception occurred")


def whichCentre(u):
    """
    :param u: unitId
    :return: name of centre
    """
    code = pd.read_sql('select ParentLocId from PI_PlaceRelationship where LocId={} and EndDate>="2018-12-01" and RelationId=1'\
                          .format(u),engine).values[0][0]
    return pd.read_sql('select AbbrevLocName from PI_Place where LocId={}'.format(code),engine).values[0][0].strip()


def iTable(date=201809, c='all', startdate='2018-01-01', r=False):
    PC = centre(c, date, False)
    #print(PC)
    df = pd.DataFrame()
    ev = ','.join(pd.read_sql('select EventCode from OE_Event where \
    SignificanceCode in ("S","N","T") and EventDate >= "{}"'.format(startdate), engine).EventCode.values.astype(str))
    #print(ev)
    for u in tqdm(PC):
        try:
            oeNum = int(pd.read_sql('select OEDBID from CORE_Unit where INPORef={}'.format(u), engine).values[0][0])
            #logging.debug(oeNum)
            evCount = pd.read_sql('select Count(EventCode) from OE_EventUnit where UnitCode={} and EventCode in ({})' \
                                  .format(oeNum, ev), engine).values[0][0]
            #logging.debug(evCount)
            uName = name(u)
            #logging.debug(name)
            idx = \
            pd.read_sql('select IndexValue from PI_ResultsIndex where LocId={} and PeriodEndYrMn="201809" and IndexId=4' \
                        .format(u), engine).values[0][0]
            #logging.debug(idx)
            cnt = whichCentre(u)
            #logging.debug(cnt)
            if idx > 40:
                df = df.append({'Unit': uName, 'Events': evCount, 'Index': idx, 'Centre': cnt}, ignore_index=True)
            #logging.debug(u + 'added')
        except:
            #logging.debug(u + 'ignored')
            pass
    rDrive = 'R:/Power BI/PACT/'
    locDrive = '../xls/'
    path = rDrive + 'EventsVsIndex_' + c + '.csv' if r else locDrive + 'EventsVsIndex_' + c + '.csv'
    df.to_csv(path , index=False)
    logging.info('table for Igor is saved to' + path)


def tisa(date, period=36):
    """ calculate TISA for all the units """
    m = ['M1   ', 'M2   ', 'M3   ', 'M4   ', 'M5   ', 'M6   ', 'M7   ', 'M8   ']
    d = [t.strftime("%Y%m") for t in pd.date_range(start=date, periods=period / 3, freq='-3M')]
    req = "select SourceId, YrMn, ElementCode, ElementValue from PI_IndValues \
    where ElementCode in ({}) and YrMn in ({}) and SourceCode=='  '" \
        .format(','.join(["'" + j + "'" for j in m]), ','.join([str(dd) for dd in d]))
    t = pd.read_sql(req, engine)
    tisa2 = pd.DataFrame()

    for u in t.SourceId.unique():
        try:
            M = [t.ElementValue[(t.ElementCode == el) & (t.SourceId == u)].values.sum() for el in m]
            tisa = (M[0] + M[1] + M[2] + M[4] + M[5] + M[7]) / (M[3] + M[6]) * 2E5
            tisa2 = tisa2.append(pd.DataFrame(data={'LocId': [u], 'PeriodEndYrMn': [d[0]], 'ResultsValue': [tisa]}))
        except:
            pass
    return tisa2


def station(unit, date):
    """ return station unit belongs to """
    req = 'select ParentLocId from PI_PlaceRelationship where RelationId = 4 and LocId = "{}" and EndDate > "{}"'.format(unit,d2d(date))
    try:
        station = pd.read_sql(req, engine).values[0][0]
        return station if unit != station else 0
    except:
        logging.warning('error in getting station ID for {} ({})'.format(name(unit), unit))
        return 0


def d2d(date, string=True):  # convert from 201806 into date string YYYY-MM-DD
    date = str(date)
    return date[:4]+'-'+date[4:6]+'-01' if string else datetime(int(date[:4]), int(date[4:6]), 1)


def centre(code, date, text=True, excludeStation=False):
    """ return list of units (in text) by RC to be included into SQL """

    cnt = {'A': 1155, 'M': 1158, 'P': 1156, 'T': 1159}
    if code in cnt and not excludeStation:
        request = 'SELECT DISTINCT LocId  FROM PI_PlaceRelationship WHERE ParentLocId = {} \
        AND RelationId = 1 AND EndDate >= "{}"'.format(cnt[code], d2d(date))
    elif code not in cnt and not excludeStation:
        request = 'SELECT DISTINCT LocId FROM PI_PlaceRelationship WHERE ParentLocId in (1155,1158,1156,1159) \
        AND RelationId = 1 AND EndDate >= "{}"'.format(d2d(date))
    elif code in cnt and excludeStation:
        request = 'select LocId from PI_PlaceRelationship where RelationId = 12 and LocId in ' \
                  '(SELECT DISTINCT LocId FROM PI_PlaceRelationship WHERE ParentLocId = {} ' \
                  'AND RelationId = 1 AND EndDate >= "{}")'.format(cnt[code], d2d(date))
    elif code not in cnt and excludeStation:
        request = 'select LocId from PI_PlaceRelationship where RelationId = 12 and LocId in ' \
                  '(SELECT DISTINCT LocId FROM PI_PlaceRelationship WHERE ParentLocId in (1155,1158,1156,1159) ' \
                  'AND RelationId = 1 AND EndDate >= "{}")'.format(d2d(date))

    PC = pd.read_sql(request, engine).LocId.tolist()
    s = []
    for p in PC:
        s.append(str(p))
    PC = ','.join(s) if text else s
    return PC

limit = {'FLR  ':[5,2], 'SP1  ':0.02, 'SP2  ':0.02, 'SP5  ':0.025, 'TISA':[0.5,0.2],  # old values
        'CRE  ':{'1':[10,5], '3':[180,125], '12':[320,240], '13':[200,115], '14':[90,70]},
        'US7  ':{'1':[2,1], '3':[1,0.5], '12':[1,0.5], '13':[1.5,1], '14':[1,0.5]}}

limit2025 = {'FLR  ':[3.5,1.6], 'SP1  ':0.02, 'SP2  ':0.02, 'SP5  ':0.025, 'TISA':[0.5,0.2], #proposed values
        'CRE  ':{'1':[10,5], '3':[180,125], '12':[320,240], '13':[200,115], '14':[90,70]},
        'US7  ':{'1':[2,1], '3':[1,0.5], '12':[1,0.5], '13':[1.5,1], '14':[1,0.5]}}

# target for plotting indicator trend in trending()
target = {'TISA2':[0.5,0.2], 'FLR  ':[5,2], 'SP1  ':[0.02,0.02], 'SP2  ':[0.02,0.02], 'SP5  ':[0.025,0.025],
         'ISA2 ':[0.5,0.2], 'CRE':{'AGR':[10,5], 'BWR':[180,125], 'LWCGR':[320,240],'PHWR':[200,115],'PWR':[90,70]},
         'US7':{'AGR':[2,1], 'BWR':[1,0.5], 'LWCGR':[1,0.5],'PHWR':[1.5,1],'PWR':[1,0.5]}}

centres = {'A':'WANO AC','M':'WANO MC','P':'WANO PC','T':'WANO TC','all':'all WANO'}


def name(uid):
    """ :return: name of unit/station by LocID """
    try:
        return pd.read_sql('select AbbrevLocName from PI_Place where LocId={}'.format(uid),engine).AbbrevLocName[0].strip()
    except:
        return 'N/A'


def met(indicator, date, cent='all', lim=2020):
    """
    :param indicator: with whitespaces
    :param cent: centre
    :param lim: which targets to be used
    :param date: in format YYYYMM
    :return: number of units met [individual, industry] targets
    """
    if indicator in ['CRE  ', 'US7  ']:
        res = [0, 0, 0]
        for nsss in [1, 3, 12, 13, 14]:  # by reactor type
            for l in [0, 1]:  # limits
                lmt = limit[indicator][str(nsss)][l] if lim == 2020 else limit2025[indicator][str(nsss)][l]
                # print(limit[indicator][str(nsss)][l])
                req = 'select count(R.LocId) from PI_Results as R inner join PI_UnitData as D on R.LocId = D.LocId \
where R.PeriodEndYrMn = {} AND R.IndicatorCode = "{}" \
AND R.NumOfMonths = 36 AND R.NonQualCode = " " AND D.NsssTypeId = {} AND R.ResultsValue <= {} AND R.LocId IN ({})' \
                    .format(date, indicator, nsss, lmt, centre(cent, date))
                res[l] += int(pd.read_sql(req, engine).values[0][0])
            req = 'select count(R.LocId) from PI_Results as R inner join PI_UnitData as D on R.LocId = D.LocId \
where R.PeriodEndYrMn = {} AND R.IndicatorCode = "{}" \
AND R.NumOfMonths = 36 AND R.NonQualCode = " " AND D.NsssTypeId = {} AND R.LocId IN ({})' \
                .format(date, indicator, nsss, centre(cent, date))
            res[2] += int(pd.read_sql(req, engine).values[0][0])
            # print('NSSS = {}, limits = {}, results = {}'.format(nsss,limit[indicator][str(nsss)],res))
        return pd.DataFrame({'Centre': [cent], 'date': [date], 'Indiv': res[0], 'Indust': res[1], 'Qualified': res[2], \
                             'Perc.idv': int(res[0] / 0.01 / res[2]), 'Perc.ids': int(res[1] / 0.01 / res[2])})


    elif indicator == 'SSPI':
        res, qual = [], []
        for i in ['SP1  ', 'SP2  ', 'SP5  ']:
            lmt = limit[i] if lim==2020 else limit2025[i]
            req = 'SELECT COUNT(LocId) FROM PI_Results WHERE PeriodEndYrMn = {} AND IndicatorCode = "{}" AND NumOfMonths = 36 \
            AND NonQualCode = " " AND ResultsValue <= {} AND LocId IN ({})'.format(date, i, lmt,
                                                                                   centre(cent, date))
            res.append(int(pd.read_sql(req, engine).values[0][0]))
            req = 'SELECT COUNT(LocId) FROM PI_Results WHERE PeriodEndYrMn = {} AND IndicatorCode = "{}" AND NumOfMonths = 36 \
            AND NonQualCode = " " AND LocId IN ({})'.format(date, i, centre(cent, date))
            qual.append(int(pd.read_sql(req, engine).values[0][0]))
        met = [int(r / 0.01 / q) for r, q in zip(res, qual)]
        # Industry target - all units met three targets simulateously
        req = 'select LocId, IndicatorCode, ResultsValue from PI_Results where PeriodEndYrMn = {} \
        AND IndicatorCode in ("SP1  ","SP2  ","SP5  ") AND NumOfMonths = 36 AND NonQualCode = " " AND LocId IN ({})' \
            .format(date, centre(cent, date))
        df = pd.read_sql(req, engine)
        req = 'select distinct LocId from PI_Results where PeriodEndYrMn = {} \
        AND IndicatorCode in ("SP1  ","SP2  ") AND NumOfMonths = 36 AND NonQualCode = " " AND LocId IN ({})' \
            .format(date, centre(cent, date))
        units = pd.read_sql(req, engine).values
        sspi = 0
        for u in units:
            u = u[0]
            # print(u)
            count = 0
            # print(df.ResultsValue[(df.LocId==u) & (df.IndicatorCode=="SP1  ")])
            try:
                lmt1 = limit['SP1  '] if lim == 2020 else limit2025['SP1  ']
                lmt2 = limit['SP2  '] if lim == 2020 else limit2025['SP2  ']
                lmt5 = limit['SP5  '] if lim == 2020 else limit2025['SP5  ']
                if df.ResultsValue[(df.LocId == u) & (df.IndicatorCode == "SP1  ")].values[0] <= lmt1 and \
                    df.ResultsValue[(df.LocId == u) & (df.IndicatorCode == "SP2  ")].values[0] <= lmt2 and \
                    df.ResultsValue[(df.LocId == station(u, date)) & (df.IndicatorCode == "SP5  ")].values[0] <= lmt5:
                    sspi += 1
            except:
                logging.warning('error for {} for {} for station {} (unit {})'.format(i, date, name(station(u, date)),name(u)))
        return pd.DataFrame({'Centre': [cent], 'date': [date], 'Indiv': [res], 'Qualified': [qual], 'SP1': [met[0]], \
                             'SP2': [met[1]], 'SP5': [met[2]], \
                             'Indust.': [sspi], 'Qual': [len(units)], 'SSPI': [int(sspi / 0.01 / len(units))]})


    elif indicator == 'TISA':
        m = ['M1   ', 'M2   ', 'M3   ', 'M4   ', 'M5   ', 'M6   ', 'M7   ', 'M8   ']
        req = "select SourceId, ElementCode, ElementValue from PI_IndValues \
        where ElementCode in ({}) and YrMn={} and SourceCode=='  ' AND SourceId IN ({})" \
            .format(','.join(["'" + j + "'" for j in m]), date, centre(cent, date))
        t = pd.read_sql(req, engine)
        whole = len(t.SourceId.unique())
        res = [0, 0]
        for u in t.SourceId.unique():
            if all(len(t[(t.ElementCode == a) & (t.SourceId == station(u, date))])
                   == len(t[(t.ElementCode == m[0]) & (t.SourceId == station(u, date))])
                   for a in m):
                M = [t.ElementValue[(t.ElementCode == el) & (t.SourceId == u)].values.sum() for el in m]
                tisa = (M[0] + M[1] + M[2] + M[4] + M[5] + M[7]) / (M[3] + M[6]) * 2E5
                #logging.debug(f'{name(station(u, date))} has TISA = {tisa}')
                for i in [0, 1]:
                    lmt = limit['TISA'][i] if lim==2020 else limit2025['TISA'][i]
                    if tisa <= lmt:
                        res[i] += 1
            else:
                logging.warning(f'Error in getting all TISA source data for {name(station(u))} for {date}')
        return pd.DataFrame({'Centre': [cent], 'date': [date], 'Indiv': res[0], 'Indust': res[1], 'Qualified': whole,
                             'Perc.idv': int(res[0] / 0.01 / whole), 'Perc.ids': int(res[1] / 0.01 / whole)})


    else:
        res = []
        req = 'SELECT COUNT(LocId) FROM PI_Results WHERE PeriodEndYrMn = {} AND IndicatorCode = "{}" AND NumOfMonths = 36 \
        AND NonQualCode = " " AND LocId IN ({})'.format(date, indicator, centre(cent, date))
        whole = pd.read_sql(req, engine).values[0][0]
        lmt = limit[indicator] if lim==2020 else limit2025[indicator]
        for li in lmt:
            req = 'SELECT COUNT(LocId) FROM PI_Results WHERE PeriodEndYrMn = {} AND IndicatorCode = "{}" AND NumOfMonths = 36 \
            AND NonQualCode = " " AND ResultsValue <= {} AND LocId IN ({})'.format(date, indicator, li,
                                                                                   centre(cent, date))
            # print(req)
            res.append(int(pd.read_sql(req, engine).values[0][0]))
        return pd.DataFrame({'Centre': [cent], 'date': [date], 'Indiv': res[0], 'Indust': res[1], 'Qualified': whole,
                             'Perc.idv': int(res[0] / 0.01 / whole), 'Perc.ids': int(res[1] / 0.01 / whole)})


def chart_data(indicator, start, period, centre='all', lim=2020):
    """
    create a dataframe for selected period and centre to reflect the percentage of units met the targets
    :param lim: which target will be used
    :param indicator: with whitespaces
    :param start: date in format YYYY-MM-DD
    :param period: number of quarters
    :param centre: 'all' or 'A',...
    :return: dataframe
    """
    x = pd.DataFrame()
    logging.info((indicator, centre))
    d = [t.strftime("%Y%m") for t in pd.date_range(start=start, periods=period/3, freq='-3M')]
    for date in d:
        x = x.append(met(indicator, date, cent=centre, lim=lim))
        print('.', end='')
    return x


def charting(lim=2020):
    """ chart dataframe created in chart_data() to reflect the percentage of units met the targets """
    for indic in ['FLR  ', 'CRE  ', 'TISA', 'SSPI', 'US7  ']:
        for c in ['A', 'M', 'P', 'T', 'all']:
            # TODO: fix charting for SSPI - it returns three values
            data = chart_data(indic, '2018-09-01', 12*5, c, lim=lim).set_index('date').sort_index()
            y = ['SP1', 'SP2', 'SP5', 'SSPI'] if indic == 'SSPI' else ['Perc.idv', 'Perc.ids']
            data.plot(kind='line', y=y)
            plt.xticks(range(len(data)), data.index.tolist(), rotation=30)
            plt.xlabel(None)
            plt.axhline(y=100, color='r', linestyle='-', label='Individual target')
            plt.axhline(y=75, color='b', linestyle='-', label='Industry target')
            plt.title(centres[c] + ' ' + indic)
            plt.savefig('pic/' + str(lim) + c + indic.strip() + '.png')
            logging.info('pic/' + str(lim) + c + indic.strip() + '.png saved')


def scattered():
    """ chart dataframe (as scatter) created in chart_data() """
    c = 'A'
    i = 'FLR  '
    data = chart_data(i, '2018-09-01', 12*5, c).set_index('date').sort_index()
    # print(data)
    data.plot(kind='scatter', x='Perc.idv', y='Perc.ids')  # ,c='Centre')
    # plt.xticks(range(len(data)),data.index.tolist(),rotation=20)
    # plt.axhline(y=100, color='r', linestyle='-', label='Individual target')
    # plt.axhline(y=75, color='b', linestyle='-', label='Industry target')
    plt.title(centres[c] + ' ' + indic)
    plt.savefig('pic/' + c + indic + '.jpg')


def plot(res,code,reactor=None,groupby='PeriodEndYrMn', hline=None):
    """
    plot the boxplot chart for indicator trending
    :param res: results dataframe
    :param code: indicator code
    :param reactor: reactor type
    :param groupby: grouping
    :param hline: key indicator limit(s)
    :return: boxplot
    """
    box = res.boxplot(column='ResultsValue', showfliers=False, return_type=None, by=groupby, patch_artist=False)
    #box['boxes'].set_facecolor('green')
    ind = code.strip()
    lab = ind if reactor is None else ind + ' ' +reactor.strip()
    plt.ylabel(lab)
    plt.xticks(rotation=60)
    plt.title('')
    if hline is not None:
        plt.axhline(y=hline[0], color='r', linestyle='-', label='Individual target')
        plt.axhline(y=hline[1], color='b', linestyle='-', label='Industry target')
    plt.legend()
    plt.tight_layout()
    #plt.show()
    fn = 'pic/'+ind+'_trend.png' if reactor is None else 'pic/'+ind+'_'+reactor.strip()+'_trend.png'
    plt.savefig(fn)
    print(fn+' is saved')


def code():
    """ list of indicator codes including TISA """
    req = 'SELECT DISTINCT IndicatorCode FROM PI_Results where PeriodEndYrMn>=201306 AND NumOfMonths = 36'
    icode = pd.read_sql(req, engine)
    icode = icode.append(pd.DataFrame.from_dict({'IndicatorCode': ['TISA2']})).IndicatorCode
    return icode


def trending():
    icode = code()
    for i in range(len(icode)):
        code = icode.iloc[i]
        # code = 'TISA2'
        #print('"' + code + '"')
        if code in ['FLR  ', 'ISA2 ', 'SP1  ', 'SP2  ', 'SP5  ']:
            req = 'Select PeriodEndYrMn, ResultsValue from PI_Results where PeriodEndYrMn>=201306 \
        AND NumOfMonths = 36 AND IndicatorCode = "{}" AND NonQualCode = " "'.format(code)
            res = pd.read_sql(req, engine)
            # print(res.tail())
            qt = res.ResultsValue.quantile([0.0, 0.25, 0.5, 0.75, 1.0])
            # print(qt)
            out = qt.values[3] + 1.5 * (qt.values[3] - qt.values[1])
            # print(out)
            plot(res, code, hline=target[code])
            # numbers of outliers
            req = 'SELECT COUNT(DISTINCT LocId) FROM PI_Results WHERE PeriodEndYrMn=201806 \
        AND NumOfMonths = 36 AND IndicatorCode = "{}" AND NonQualCode = " " AND ResultsValue > {}'.format(code, out)
            print(req)
            res3 = pd.read_sql(req, engine)
            # print('There are {} outliers for {}'.format(res3.values[0][0],icode.iloc[i]))
            print('{}: Individual target is {:.3g}, '
                  'industry - {:.3g}, there are {} outliers out of {:.3g}'.format(code, qt.values[3], qt.values[2],
                                                                                  res3.values[0][0], out))
        elif code in ['CRE  ', 'US7  ']:
            for reactor in ['AGR  ', 'BWR  ', 'LWCGR', 'PHWR ', 'PWR  ']:
                r = pd.read_sql('SELECT NsssTypeId FROM PI_NsssTypeLookup WHERE NsssType = "{}"'.format(reactor),
                                engine).values[0][0]

                ulist = pd.read_sql('SELECT DISTINCT LocId FROM PI_UnitData WHERE NsssTypeId = {}'.format(r),
                                    engine).values
                ulist = ','.join([str(u[0]) for u in ulist])
                # print(ulist)

                req = 'Select PeriodEndYrMn, ResultsValue from PI_Results where PeriodEndYrMn>=201306 \
            AND NumOfMonths = 36 AND IndicatorCode = "{}" AND NonQualCode = " " AND LocId IN ({})'.format(code, ulist)
                # print(req)
                res = pd.read_sql(req, engine)
                qt = res.ResultsValue.quantile([0.0, 0.25, 0.5, 0.75, 1.0])
                out = qt.values[3] + 1.5 * (qt.values[3] - qt.values[1])
                plot(res, code, reactor, hline=target[code.strip()][reactor.strip()])
                # numbers of outliers
                req = 'SELECT COUNT(DISTINCT LocId) FROM PI_Results WHERE PeriodEndYrMn=201806 \
            AND NumOfMonths = 36 AND IndicatorCode = "{}" AND NonQualCode = " " ' \
                      'AND ResultsValue > {}  AND LocId IN ({})'.format(code, out, ulist)
                # print(req)
                res3 = pd.read_sql(req, engine)
                # print('There are {} outliers for {} {}'.format(res3.values[0][0],icode.iloc[i], reactor))
                print(
                    '{} {}: Individual target is {:.3g}, industry - {:.3g}, there are {} outliers out of {:.3g}'.format(
                        code, reactor, qt.values[3], qt.values[2], res3.values[0][0], out))
        elif code == 'TISA2':
            print('working with TISA')
            d = pd.date_range(start='2018-06-30', periods=20, freq='-3M')  # 3-yrs value for the recent 5 years
            tisa2 = pd.DataFrame()
            for date in tqdm(d):
                tisa2 = tisa2.append(tisa(date))

            qt = tisa2.ResultsValue.quantile([0.0, 0.25, 0.5, 0.75, 1.0])
            # print(qt)
            out = qt.values[3] + 1.5 * (qt.values[3] - qt.values[1])
            print(tisa2.tail())
            plot(tisa2, code, hline=target[code])

            tisa2 = tisa('2018-06-30')
            num_out = len(tisa2.ResultsValue[tisa2.ResultsValue >= out])

            print('{}: Individual target is {:.3g}, industry - {:.3g}, '
                  'there are {} outliers out of {:.3g}'.format(code, qt.values[3], qt.values[2], num_out, out))
        else:
            # print('no data for {}'.format(icode.iloc[i]))
            pass


def dbdiff(old, new):
    # TODO: check the comparison and add the previous value(s) into the diff table
    """
    compare two sqlite PI_IndValues DB and write diffs into diff table;
    :param old: name of 'old' DB file
    :param new: name of 'new' DB file
    :return: add 'diff' table into 'new' DB
    """
    dir = "C:/Users/Volodymyr.Turbayevsk/Desktop/Docs/programming/R/indicators/zipDBCopy/"
    logging.info(old + '->' + new)
    engine = create_engine('sqlite:///' + dir + old + '.sqlite')
    next_en = create_engine('sqlite:///' + dir + new + '.sqlite')
    req = 'select * from "PI_IndValues" where RecStatus=" "'
    df1 = pd.read_sql(req, engine).set_index(['SourceId', 'YrMn', 'ElementCode'])
    df2 = pd.read_sql(req, next_en).set_index(['SourceId', 'YrMn', 'ElementCode'])
    df = pd.concat([df1, df2])
    df = df.drop_duplicates(keep=False)
    d1 = df1.index.levels[1].unique().values.tolist()
    d2 = df2.index.levels[1].unique().values.tolist()
    lst = list(set(d2) - set(d1))
    logging.debug(lst)
    for idx in lst:
        try:
            df = df.drop(index=str(idx), level=1)
        except:
            pass
    # print(df.tail())
    if len(df):
        old = pd.read_sql('select * from diff', engine).set_index(['SourceId', 'YrMn', 'ElementCode'])
        # print(old.tail())
        old = old.append(df)
        old = old.drop_duplicates(keep=False)
        # print(old.tail())
    else:
        old = pd.read_sql('select * from diff', engine).set_index(['SourceId', 'YrMn', 'ElementCode'])

    logging.debug(len(df), len(old))
    old.to_sql('diff', next_en, if_exists='replace')


def index_distr(date, cnt):
    if cnt == 'all':
        req = 'SELECT AbbrevLocName, IndexValue FROM PI_ResultsIndex I INNER JOIN PI_Place P ON I.LocId=P.LocId \
        WHERE PeriodEndYrMn = {} AND IndexId = 4 AND NonQualCode = " "'.format(date)
    else:
        req = 'SELECT AbbrevLocName, IndexValue FROM PI_ResultsIndex I INNER JOIN PI_Place P ON I.LocId=P.LocId \
        WHERE PeriodEndYrMn = {} AND IndexId = 4 AND NonQualCode = " " AND I.LocId IN({})'.format(date, centre(cnt,date))
    df = pd.read_sql(req, engine)
    df.AbbrevLocName = df.AbbrevLocName.str.strip()
    df = df.set_index('AbbrevLocName').sort_values(by='IndexValue', ascending=False)
    return df


def index_chart(date, cnt):
    index_distr(date, cnt).plot(kind='bar',figsize=(20,8))
    plt.axhline(y=70, color='b', linestyle='-', label='Limit')
    plt.subplots_adjust(bottom=0.3)
    plt.xlabel('Units')
    plt.savefig('pic/' + str(date)+cnt+'.png')
    logging.info('pic/' + str(date)+cnt+'.png saved')

if __name__=="__main__":
    charting()
    #charting(2025)
    #for c in ['A', 'M', 'P', 'T', 'all']:
    #    index_chart(201809, c)
    #old = input("Old DB filename (without ext.)")+'.sqlite'
    #new = input("New DB filename (without ext.)") + '.sqlite'
    #dbdiff(old,new)
    #os.remove(old)