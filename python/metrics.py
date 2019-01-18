from sqlalchemy import create_engine
import pandas as pd
from datetime import datetime

import sys
sys.path.append('../python')
import functions as f
import xlsGenerator as x

engine = create_engine('sqlite:///../PI.sqlite')


def endOfQtr(qtr):
    """ returns the end of previous quarter in date format """
    d = int(str(qtr)[4:6])  # if qtr != 'now' else datetime.now().month
    mn = 4 if d <= 4 else 7 if d <= 7 else 10 if d <= 10 else 12
    yr = int(str(qtr)[:4]) if d >= 4 else int(str(qtr)[:4]) - 1
    return datetime.strftime(datetime(yr, mn, 1),'%Y-%m-%d')


def pi1(qtr, centreCode, plt=False):
    req = 'select max(julianday(SubmittalDate)-julianday("{}")) from PI_DataSubmittal where LocId in ({}) and YrMn = {}'\
        .format(endOfQtr(qtr), f.centre(centreCode, qtr), qtr)
    maxUnit = pd.read_sql(req, engine).values[0][0]

    req = 'select avg(julianday(SubmittalDate)-julianday("{}")) from PI_DataSubmittal where LocId in ({}) and YrMn = {}'\
        .format(endOfQtr(qtr), f.centre(centreCode, qtr), qtr)
    avg = pd.read_sql(req, engine).values[0][0]

    req = 'select julianday(SubmittalDate)-julianday("{}") from PI_DataSubmittal where LocId in ({}) and YrMn = {}'\
        .format(endOfQtr(qtr), f.centre(centreCode, qtr), qtr)
    d = pd.read_sql(req, engine)
    med = d.median()[0]

    req = 'select sum((julianday(SubmittalDate)-julianday("{}"))>45) from PI_DataSubmittal where LocId in ({}) and YrMn = {}'\
        .format(endOfQtr(qtr), f.centre(centreCode, qtr, True, True), qtr)
    numOfOut = pd.read_sql(req, engine).values[0][0]

    if plt:
        return d.hist(label='PI-1 for '+centreCode)

    return maxUnit, avg, med, numOfOut


def pi2(qtr, centreCode, plt=False):
    req = 'select max(julianday(ProductionDate)-julianday("{}")) from PI_DataSubmittal where LocId in ({}) and YrMn = {}'\
        .format(endOfQtr(qtr), f.centre(centreCode, qtr), qtr)
    maxUnit = pd.read_sql(req, engine).values[0][0]

    req = 'select avg(julianday(ProductionDate)-julianday("{}")) from PI_DataSubmittal where LocId in ({}) and YrMn = {}'\
        .format(endOfQtr(qtr), f.centre(centreCode, qtr), qtr)
    avg = pd.read_sql(req, engine).values[0][0]

    req = 'select julianday(ProductionDate)-julianday("{}") from PI_DataSubmittal where LocId in ({}) and YrMn = {}'\
        .format(endOfQtr(qtr), f.centre(centreCode, qtr), qtr)
    d = pd.read_sql(req, engine)
    med = d.median()[0]

    req = 'select sum((julianday(ProductionDate)-julianday("{}"))>60) from PI_DataSubmittal where LocId in ({}) and YrMn = {}'\
        .format(endOfQtr(qtr), f.centre(centreCode, qtr, True, True), qtr)
    numOfOut = pd.read_sql(req, engine).values[0][0]

    if plt:
        return d.hist(label='PI-2 for '+centreCode)

    return maxUnit, avg, med, numOfOut


def analyseTime(qtr ,centreCode):
    """
    :param qtr: YYYYMM
    :param centreCode: a letter of centre
    :return: median and mean time were spending for analysis
    """
    req = 'select julianday(ProductionDate)-julianday(SubmittalDate) from PI_DataSubmittal where LocId in ({}) and YrMn = {}'\
        .format(f.centre(centreCode, qtr), qtr)
    return pd.read_sql(req, engine).median(), pd.read_sql(req, engine).mean()


def metricMdTable(qtr):
    """ print metric table for md """
    print('| Centre | Max. submittal | Avg. submittal | Med. submittal | Units out | Max. production | \
    Avg. Production | Med. production | Units out | Med Analysis time | Avg. Analysis time |')
    print('|---|---|---|---|---|---|---|---|---|---|---|')
    qtr = int(qtr)
    for centre in ('A', 'M', 'P', 'T'):
        print('{}|{:.3}|{:.3}|{:.3}|{}|{:.3}|{:.3}|{:.3}|{}|{:.3}|{:.3}|'
              .format(centre,
                      pi1(qtr, centre)[0], pi1(qtr, centre)[1], pi1(qtr, centre)[2], pi1(qtr, centre)[3],
                      pi2(qtr, centre)[0], pi2(qtr, centre)[1], pi2(qtr, centre)[2], pi2(qtr, centre)[3],
                      analyseTime(qtr, centre)[0][0], analyseTime(qtr, centre)[1][0]))


if __name__ == '__main__':
    qtr = 201809
    pi1(qtr, 'A', True)