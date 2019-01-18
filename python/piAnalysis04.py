# -*- coding: utf-8 -*-
"""
History
- [07/05/15] Indicator trend generation – currently I can generate annual-based (not a quarter-based) trend for each indicator because I use annual result spreadsheets;
- Index method definition – current index 4 method is not quite appropriate because it was developed for all indicators but not for small group;
- SOER data using (if need);
- [29/6/15] User-friendly interface developing (PyQt/PyGTK);
- [29/6/15] Converting programme from python to EXE-file to sharing among RCs
- Unit name/quantity PRIS-WANO comparison; put number of WANO unit in the PRIS table
- [29/6/15] Check/change 2014 year as a basis for calculation
- [29/6/15] Add comparison with LTT

DC:
- [22/6/15] First, can you please make the trend graphs a line graph and not a bar graph?
- [22/6/15] Second, for the indicators that have a goal or reference value, can you please show that
on the graph as well?
- Third, for the x-axis, can we spread those out more?  Prehaps at the right most bucket
of stations, make it like the number of stations over some high value?

Name differences request:
SELECT pris.Unit,units.name FROM pris,units where pris.auto_wano_id='False' and pris.wano_id=units.id
"""

'''
# TODO:
- [ ] 	Header Page
  - [ ] Change “The most recent worldwide results are used” to display the actual quarter value that is used
    - [ ] Users of the report are not intimately familiar enough with when data is released to know what that value is based on the report generated date
    - [ ] There have also been times when data was held and not released as expected which would make the assumption off of the report generated date inaccurate
  - [ ] Update “Unit vs WANO Worldwide…” to be “Station/Unit vs WANO Worldwide…”
  - [ ] Display what systems are represented in the SSPI indicators based on reactor type
  - [ ] Revise the last statement “The total number of units in the DB is 432, 294 have the same reactor type, and 108 of them belong the same RC”
    - [ ] Replace generic statements with specific
      - [ ] “same reactor type” with “PWR”
      - [ ] “same RC” with “WANO-PC”
    - [ ] Fix typo “…belong to the same…”
    - [ ] Clarify that 108 is the same RC and reactor type, not just same RC
- [ ] 	Page setup
  - [ ] Display full indicator name in header
  - [ ]	Make the font larger and centered
  - [ ]	Ensure table headers do not get cut off. This may be achieved by:
    - [ ] removing indicator name (since it will be in page header)
    - [ ] replacing “Distribution among current RC” with “WANO-AC”/”WANO-PC”/”WANO-TC”/”WANO-MC”
    - [ ] replacing “same reactors” with the abbreviation for the reactor type, for example PWR, BWR, PHWR, etc.
  - [ ] Remove reactor comparison distribution charts from station level indicators (SP5 and ISA2)
    - [ ] This display indicates there may be a relationship between the type of reactor and the indicator when there is not.  
    - [ ] Also, some stations have units of different reactor types and make this chart display even more misleading.
- [ ]	Chart setup
  - [ ] Identify LTT and display LTT values on chart
  - [ ] Identify Industry targets and display values on chart
  - [ ] Display count of stations/units represented by each bar on or above the bar
  - [ ] Keep bins identical for each of the distribution charts for a particular indicator to improve the ability to quickly compare the distribution charts.
    - [ ] For example, see Doel UA7 charts the WW and WW PWR use the same bin sizes but the WANO-PC PWR uses much smaller bin sizes.  For Doel SP2 all three charts have different bin sizes.
  - [ ] Correct x-axis labels to display what the value is
    - [ ]For example, see Doel UA7 instead of “Value distribution coeff” use “Scram Rate”
  - [ ] Display quarter labels in the x-axis of the trend charts instead of just the label “Quarters”
  - [ ] Remove “value” from the unit labels
    - [ ] For example, display “Doel 1 = 1.0000” instead of “Doel 1 value = 1.0000”
  - [ ] Make value lines (black arrows) thinner
- [ ] Data
  - [ ] Review how missing data is handled and keep consistent
    - [ ] For example, see Doel CPI Unit 3 is displayed as 0 in one distribution chart but missing from the others and the trend line stops
    - [ ] I recommend not changing how the trend chart is displaying and keeping the Doel 3 label but display the reason it is missing instead of the value.  For example, display “Doel 3 = insufficient data”

'''

import os
import time
import sqlite3
import numpy as np
from matplotlib.backends.backend_agg import FigureCanvasAgg as FigureCanvas
from matplotlib.figure import Figure
# PDF generation
from reportlab.lib.pagesizes import landscape,letter
from reportlab.pdfgen import canvas
from reportlab.lib.units import mm

import wx

from sqlalchemy import create_engine
import pandas as pd
import sys

sys.path.append('../python')
import functions as f
import xlsGenerator as x

import logging
logging.basicConfig(level=logging.INFO)

#Constantes
# for pfd-generator
left = 20*mm
down = 20*mm
width = 100*mm
height = 60*mm
border = 10*mm

# Global variables
pr = 0
sname = ''
rcs = {'A':'Atlanta', 'P':'Paris', 'M':'Moscow', 'T':'Tokyo'}

iList = ['UA7','US7','SP1','SP2','SP5','CPI','CRE','FRI','FLR','ISA2']
#iList = ['ISA2']
plants = ['SP5','ISA2']
#iList = ['FRI']
# 3-YR values
val = {'UA7':'coeff.','US7':'coeff.','SP1':'coeff.','SP2':'coeff.','CPI':'coeff.','CRE':'man*Rem',\
       'FRI':'microcuries per gram','UCF':'%','UCLF':'%','FLR':'%','GRLF':'%','ISA1':'coeff.',\
       'ISA2':'coeff. by 200,000 w-h','CISA1':'coeff.','CISA2':'coeff.','SP5':'coeff.'}
indiv = {'UA7':'None','SP1':0.020,'SP2':0.020,'SP5':0.025,'FRI':'None','CPI':'None',\
         'CRE':{'AGR':0.05,'BWR':1.8,'LWCGR':3.2,'PHWR':2.0,'PWR':0.9,'VVER':0.9},\
         'US7':{'BWR':1.0,'PWR':1.0,'VVER':1.0,'LWCGR':1.0,'PHWR':1.5,'AGR':2.0},'FLR':5.0,\
         'ISA2':0.5}
indust = {'UA7':'None','SP1':'100 percent of worldwide\nunits archieve individual targets',\
          'SP2':'100 percent of worldwide\nunits archieve individual targets',\
          'SP5':'100 percent of worldwide\nunits archieve individual targets','FRI':'None','CPI':'None',\
         'CRE':{'AGR':0.02,'BWR':1.25,'LWCGR':2.4,'PHWR':1.15,'PWR':0.7,'VVER':0.7},\
         'US7':{'BWR':0.5,'PWR':0.5,'VVER':0.5,'LWCGR':0.5,'PHWR':1.0,'AGR':1.0},'FLR':2.0,'ISA2':0.2}
distrs = ['Worldwide distribution','Worldwide distribution among the same reactors',\
          'Distribution among current RC for the same reactors']
# error status
statuses = {'None':'OK',' ':'OK','NULL':'OK',
            'A':'Commercial Date disqualification\n(see PI Questions and Answers at the wano.org)',\
            'B':'Commercial Date disqualification\n(see PI Questions and Answers at the wano.org)',\
            'C':'Commercial Date disqualification\n(see PI Questions and Answers at the wano.org)',\
            'D':'Value not qualified due to \nerrors in the data provided',\
            'H':'Value not qualified due to \ninsufficient critical hours',\
            'L':'Value not qualified because \nunit is in long-term shutdown',\
            'M':'Value not qualified due to \ninsufficient or invalid data',\
            'P':'Value not qualified because \nreactor power was below required level'}

ranges = 10 # Number of ranges for data distribution

class Frame(wx.Frame):
    def __init__(self, title):
        wx.Frame.__init__(self, None, title=title, pos=(150,150), size=(420,200))
        panel = wx.Panel(self)

        # A button
        self.button =wx.Button(panel, label="Generate Report", pos=(150, 65))
        self.Bind(wx.EVT_BUTTON, self.OnClick,self.button)

        global connection
        connection=sqlite3.connect('pr.sqlite')
        connection.text_factory = str
        global cursor
        cursor=connection.cursor()
        try:
            r = cursor.execute('select UnitLocID,UnitName from Units where IsActive=1 order by UnitName').fetchall()
            global yr
            yr = cursor.execute('select max(EndDate) from Results').fetchone()[0]
            print(yr)
        except:
            wx.MessageDialog(self,"There is not database file","Error",wx.ICON_ERROR).ShowModal()
            quit()
    
        self.statusbar = self.CreateStatusBar() # A Statusbar in the bottom of the window
        un = len(iList)
        self.status = wx.Gauge(panel, pos=(0,100), size=(400,-1), range=un)

        menuBar = wx.MenuBar()
        
        menu = wx.Menu()
        m_exit = menu.Append(wx.ID_EXIT, "E&xit\tAlt-X", "Close window and exit program.")
        self.Bind(wx.EVT_MENU, self.OnClose, m_exit)
        menuBar.Append(menu, "&File")
        self.SetMenuBar(menuBar)

        ulist = []
        for i in r:
            ulist.append(i[1])
        
        self.sampleList = ulist
        self.lblhear = wx.StaticText(panel, label="Select the unit:", pos=(10, 10))
        self.edithear = wx.ComboBox(panel, pos=(150, 10), size=(200, -1), \
                                    choices=self.sampleList, style=wx.CB_DROPDOWN)
        self.periodList = ['Chart`s data period is 3 YEARS (standard)',\
                      'Chart`s data period is 3 months']
        self.edithear2 = wx.ComboBox(panel, pos=(150, 40), size=(200, -1), \
                                    choices=self.periodList, style=wx.CB_DROPDOWN)
        
    def OnClick(self,event):
        report(self.edithear.GetValue(),self.edithear2.GetSelection(),yr)
        wx.Bell()
        wx.MessageDialog(self,"Report created","Result",wx.OK).ShowModal()

    def Sv(self,progress):
        self.status.SetValue(progress)
        wx.Yield()

    def St(self,text):
        self.statusbar.SetStatusText(text,0)

    def OnClose(self, event):
        dlg = wx.MessageDialog(self, 
            "Do you really want to close this application?",
            "Confirm Exit", wx.OK|wx.CANCEL|wx.ICON_QUESTION)
        result = dlg.ShowModal()
        dlg.Destroy()
        if result == wx.ID_OK:
            self.Destroy()

# Data for plotting -------------------------------------------
def data_processing(r):
# Array normalisation
    rn = []
    for i in r:
        #if i[0]<>'':
        rn.append(i[0])
    # Distribution by ranges
    data = np.array(rn)
    mn = min(rn)
    mx = max(rn)
    hist,bins=np.histogram(data,bins=np.linspace(mn,mx,ranges+1))
    # Quartile definition
    from scipy.stats import mstats
    quantiles = mstats.mquantiles(rn, axis=0)

    out = {'hist':hist,'quant':quantiles,'bins':bins,'m':(mn,mx)}
    return out

#Plotting -----------------------------------------------------
def plot(ranges,hist,bins,quantiles,name,uvalue,ustat,ccode,distr,reactor):
    global sname
    fig = Figure()
    #w=0.35
    canvas = FigureCanvas(fig)
    ax = fig.add_subplot(111)
    x = np.arange(len(hist))
    ax.bar(x,hist,alpha=0.5)
##    ax.text(1,max(hist)-max(hist)/8,\
##             'Best Quantile:%1.4f\nMedian:%1.4f\nWorst Quantile:%1.4f'\
##             %(quantiles[0],quantiles[1],quantiles[2]))
    
    mult = ['SP1','SP2','SP5','FRI']

    xticks = []
    for i in bins:
        if ccode in mult and max(bins)<1:
            i*=1E3
        xticks.append(str(i)[:4])
    # Change the scale if needed    
    xl = 'Value distribution'
    if ccode in mult and max(bins)<1:
        xl+=', *1000'
    xl+=', %s' % val[ccode]

    ax.grid()
    ax.set_xticklabels(xticks, rotation=30, size=10)
    ax.set_xticks(x)
    # Define the LTT
    if ccode in ['CRE','US7']:
        indiv_limit = indiv[ccode]
        indiv_limit = indiv_limit[reactor]
        indust_limit = indust[ccode]
        indust_limit = indust_limit[reactor]
    else:
        indiv_limit = indiv[ccode]
        indust_limit = indust[ccode]
        
    # Plot the targets
    maxval = max(bins)-min(bins)
    
    if indiv_limit != 'None' and indiv_limit>0:
        if ccode == 'CRE':
            indiv_limit*=100
        il = (indiv_limit-min(bins))*(len(bins)-1)/maxval
        xt = [il,il]
        yt = [0,max(hist)]
        if il<=len(hist):
            ax.plot(xt,yt,label = 'indiv.target',c = 'red')
    if indust_limit != 'None' and len(str(indust_limit))<10:
        if ccode == 'CRE':
            indust_limit*=100
        it = (indust_limit-min(bins))*(len(bins)-1)/maxval
        xt = [it,it]
        yt = [0,max(hist)]
        if it<=len(hist):
            ax.plot(xt,yt,label = 'indusry target',c = 'orange')
    
    if ccode not in plants:
        for uv, i in zip(uvalue, range(len(uvalue))):
            tx = (uv - min(bins)) * (len(bins) - 1) / maxval
            ax.annotate('%s value = %1.4f' %
                        (name[i], uv), xy=(tx, 0), xytext=(max(x)*0.5, max(hist)*(0.85-0.05*i)),
                        arrowprops=dict(facecolor='black'))
    else:
        tx = (uvalue - min(bins)) * (len(bins) - 1) / maxval
        ax.annotate('%s value = %1.4f' % (sname, uvalue),
                    xy=(tx, 0), xytext=(max(x) / 2, max(hist) / 2),
                    arrowprops=dict(facecolor='black'))

    #ax.annotate('Unit %s\nvalue = %1.4f\nindividual target = %s,\
    #    \nindustry target = %s,\ndata status: %s\nBest Quantile:%1.4f\nMedian:%1.4f\nWorst Quantile:%1.4f' \
    #    % (name,uvalue,indiv_limit,indust_limit,ustat,quantiles[0],quantiles[1],quantiles[2]),\
    #    xy=(tx,0),xytext=(max(x)/2,max(hist)/2),\
    #    arrowprops=dict(facecolor='black'))

    ax.set_xlabel(xl)
    ax.set_ylabel('Number of units')
    ax.set_title('%s %s among %d units' % (ccode,distr,sum(hist)))
    fn = name[0]+'-'+ccode+'-'+distr+'.png'
    canvas.print_figure(fn)


def trend(utrend,ccode,name,period):
    '''
    Plot the trend
    '''
    global sname
    fig = Figure()
    #w=0.35
    canvas = FigureCanvas(fig)
    ax = fig.add_subplot(111)
    #x = np.arange(len(utrend[0]))
    hist=[]
    #bins=[u[0] for u in utrend[0]] # dates
    mx, mn = 0, 1e3

    for i in range(len(utrend)):
        hist.append([u[1] for u in utrend[i]])
        ax.plot(hist[i],'o-',linewidth=2)
        if mx < max(hist[i]):
            mx = max(hist[i])
        if mn > min(hist[i]):
            mn = min(hist[i])

    if ccode not in plants:
        ax.legend(name)
    else:
        #print(sname)
        ax.legend([sname])

    ax.grid()
    ### TODO: check x axis for multiunit plants
    #ax.set_xticklabels(bins, rotation=40, size=10)
    #ax.set_xticks(range(len(bins)))
    ax.set_xlabel('Quarters')
    ax.set_xticklabels([])
    ax.set_ylim(mn, mx)
    ax.set_ylabel('%s value' % ccode)
    ax.set_title('%s trend (%d months data period)' % (ccode,period))
    fn = name[0]+'-'+ccode+'-trend'+'.png'
    canvas.print_figure(fn)
    
def report(uname,periodIndex,yr):    # Picture generation ------------------------------------------
    global sname
    sname = uname
    if periodIndex in [-1,0]:
        period = 36

    station = cursor.execute('select UnitLocID from Units where UnitName = ?',(uname,)).fetchone()[0]
    units = cursor.execute('select UnitLocID from Units where StLocId = ? AND IsStation = 0',(station,)).fetchall()

    fname = uname + '-' + str(yr) + '.pdf'
    c = canvas.Canvas(fname, pagesize=landscape(letter))

    r = cursor.execute('select UnitName,Centre,Reactor,RUP from Units where StLocID=? AND UnitLocId <> StLocId', (station,)).fetchall()
    #print(r)
    meta = cursor.execute('select * from metadata').fetchall()
    name = [a[0] for a in r]
    centre = [a[1] for a in r]
    reactor = [a[2] for a in r]
    RUP = [a[3] for a in r]
    #print(name, centre, reactor, RUP)

    if centre[0] != centre[1] or reactor[0] != reactor[1]:
        print('There are different reactor types and/or Regional centre, the separated reports should be requested')
        exit(1)

    # Number of units
    n = []
    n.append(cursor.execute('select count(*) from Units where IsStation=0').fetchone()[0])
    n.append(cursor.execute('select count(*) from Units where IsStation=0 and Reactor = ?', (reactor[0],)).fetchone()[0])
    n.append(cursor.execute('select count(*) from Units where IsStation=0 and Reactor = ? and Centre = ?', \
                            (reactor[0], centre[0],)).fetchone()[0])

    # The title page -----------------------------------
    c.drawString(left, down + height * 2 + border * 5, 'Plant %s data.' % (uname))
    c.drawString(left, down + height * 2 + border * 5 - 10 * mm,
                 'Belongs to %s regional centre, reactor type is %s' % (rcs[centre[0]], reactor[0]))
    c.drawString(20 * mm, 70 * mm,
                 'Three-year values are presented for indicators (except FRI: most recent operating quarter)')
    c.drawString(20 * mm, 60 * mm,
                 'The most recent worldwide results are used for distribution charts. The period of chart data is %d months' % period)
    c.drawString(20 * mm, 50 * mm, 'The most recent station results available are used for trends and comparison to '
                                   'WANO Long-term Performance Targets values')
    c.drawString(20 * mm, 40 * mm,
                 'Individual Long-Term Targets is marked by red line, and industry ones - by yellow one')
    c.drawString(20 * mm, 30 * mm, 'Report generated on %s' % time.strftime("%a, %d %b %Y at %H:%M"))
    c.drawString(20 * mm, 20 * mm,
                 'Unit vs. WANO Worldwide, WANO Worldwide %s and WANO %s Centre for %s type. Charts included qualified data only.' \
                 % (reactor[0], centre[0], reactor[0]))
    c.drawString(20 * mm, 10 * mm,
                 'The total number of units in the DB is %d, %d have the same reactor type, and %d of them belong the same RC' % \
                 (n[0], n[1], n[2]))
    c.drawImage('wano.png', 220 * mm, 180 * mm, 51 * mm, 13 * mm)
    c.drawImage('almaraz1.jpg', 20 * mm, 90 * mm, 220 * mm - 40 * mm, 113 * mm - 40 * mm)
    c.showPage()

    unumber = [u[0] for u in units]
    cnt = 0

    for ccode in iList:
        print(ccode)
        sn = cursor.execute('select StLocId from Units where UnitLocID = ?', (unumber[0],)).fetchone()[0]
        cnt += 1

        # Distributions -----------------------------------------------
        ww = cursor.execute('select Value from Results where Indicator=? and EndDate=? \
            and Value is not null and Code = "None" order by Value asc',(ccode,yr)).fetchall() # Worldwide distr

        # Is it plant-based data?
        ut = []
        if ccode in plants:
            wr = cursor.execute('select Results.Value from Results,Units where Results.Indicator=? and Results.EndDate=? \
                and Units.Reactor=? and Units.StLocId = Results.UnitID \
                and Results.Value is not null and Results.Code = "None" group by Units.StLocId'\
                ,(ccode,yr,reactor[0],)).fetchall() # Worldwide distr by reactor type
            rcr = cursor.execute('select Results.Value from Results,Units where Units.Centre = ? and Results.Indicator=? and Results.EndDate=? \
                and Results.Value is not null and Units.Reactor=? and Units.StLocId = Results.UnitID \
                and Results.Code = "None" group by Units.StLocId, Units.Centre'\
                ,(centre[0],ccode,yr,reactor[0],)).fetchall() # RC distr by reactor type
            utrend = cursor.execute('select EndDate,Value from Results where Indicator=? and UnitID=? \
            and Value is not null and Code = "None" order by EndDate asc',\
            (ccode,sn,)).fetchall() # trend for current unit
            #print(utrend)
            ut.append(utrend)
            #print('Trend:',ut)
        else:
            #unumber = cursor.execute('select UnitLocID from Units where UnitName = ?',(uname,)).fetchone()[0]
            wr = cursor.execute('select Results.Value from Results,Units where Results.Indicator=? and Results.EndDate=? \
                and Results.Value is not null and Units.Reactor=? and Units.UnitLocID = Results.UnitID \
                and Results.Code = "None" order by Results.Value asc'\
                ,(ccode,yr,reactor[0],)).fetchall() # Worldwide distr by reactor type
            rcr = cursor.execute('select Results.Value from Results,Units where Units.Centre = ? and Results.Indicator=? and Results.EndDate=? \
                and Results.Value is not null and Units.Reactor=? and Units.UnitLocID = Results.UnitID \
                and Results.Code = "None" order by Results.Value asc'\
                ,(centre[0],ccode,yr,reactor[0],)).fetchall() # RC distr by reactor type
            ustr = ','.join(str(u) for u in unumber)
            for u in unumber:
                req = 'select EndDate,Value from Results where Indicator="%s" and UnitID = %s \
                and Value is not null and Code = "None" order by EndDate asc' % (ccode, u)
                utrend = cursor.execute(req).fetchall() # trend for current unit
                ut.append(utrend)
            #print('Trend:', ut)
        # Lengths
        print(len(ww),len(wr),len(rcr))
        # Unit details ------------------------------------------------
        if ccode in plants:
            uvalue = cursor.execute('select Value from Results where Indicator=? and EndDate=? \
                and UnitID=?',(ccode,yr,sn,)).fetchone()[0] # Unit value
            ustat = cursor.execute('select Code from Results where Indicator=? and EndDate=? \
                and UnitID=?', (ccode, yr, sn,)).fetchone()[0]  # Unit value status (missed data?)
            ustat = statuses[ustat]
            print('Uvalues:', uvalue)
        else:
            ustr = ','.join(str(u) for u in unumber)
            req = 'select Value from Results where Indicator="%s" and EndDate=%d \
                and UnitID IN (%s)' % (ccode,yr,ustr)
            uvalue = cursor.execute(req).fetchall() # Unit value
            uvalue = [u[0] for u in uvalue]
            req = 'select Code from Results where Indicator="%s" and EndDate=%d \
                and UnitID IN (%s)' % (ccode,yr,ustr)
            ustat = cursor.execute(req).fetchall()  # Unit value status (missed data?)
            ustat = [u[0] for u in ustat]
            ustat = [statuses[u] for u in ustat]
            print('Uvalues:',uvalue)

        # Draw the picture
        c.drawString(left,down+height*2+border*5,'Station %s data for %s. ' % (uname,ccode))
        # Check the selection availability

        # Processing
        if ccode not in ['FRI']:
            out = data_processing(ww)
            plot(ranges,out['hist'],out['bins'],out['quant'],name,uvalue,ustat,ccode,distrs[0],reactor[0])
            fn = name[0]+'-'+ccode+'-'+distrs[0]+'.png'
            c.drawImage(fn,left,down+height+border*2,left+width,down+height)
            os.remove(fn)

        out = data_processing(wr)
        plot(ranges,out['hist'],out['bins'],out['quant'],name,uvalue,ustat,ccode,distrs[1],reactor[0])
        fn = name[0]+'-'+ccode+'-'+distrs[1]+'.png'
        c.drawImage(fn,left+width+border,down+height+border*2,left+width,\
                down+height)
        os.remove(fn)

        out = data_processing(rcr)
        plot(ranges,out['hist'],out['bins'],out['quant'],name,uvalue,ustat,ccode,distrs[2],reactor[0])
        fn = name[0]+'-'+ccode+'-'+distrs[2]+'.png'
        c.drawImage(fn,left,down,left+width,down+height)
        os.remove(fn)

        trend(ut,ccode,name,period)
        fn = name[0]+'-'+ccode+'-trend'+'.png'
        c.drawImage(fn,left+width+border,down,left+width,down+height)
        os.remove(fn)

        c.showPage()
        # Here add code for the next page
    c.save()
    return 'Report created'
        
# =============================================================
def tend(x18,x36,indicator=''):
    """ return tendency sign(s) depending from 18 and 36-mns comparison"""
    s = ['--','-','0','+','++']  # sign of trend
    v = [x36*0.7, x36, x36*1.3] if indicator != 'UCF  ' else [x36*1.3, x36, x36*0.7]
    return s[0] if x18<v[0] else s[1] if x18>=v[0] and x18<v[1] else s[2] \
        if x18==v[1] else s[3] if x18>v[1] and x18<=v[2] else s[4] if x18>v[2] else 'NA'


def quartile(res, Id, indicator, distribution):
    """ in which quartile is units value """
    #logging.debug((len(res), Id, indicator, len(distribution)))
    d = res[(res.LocId.isin(distribution)) & (res.IndicatorCode==indicator) & (res.NumOfMonths==36)].ResultsValue
    r = d.quantile([0.0,0.25,0.5,0.75,0.9,1.0]).tolist() if indicator != 'UCF  ' \
        else d.quantile([1.0, 0.75, 0.5, 0.25, 0.1, 0.0]).tolist()
    uRes = res[(res.LocId==Id) & (res.IndicatorCode==indicator) & (res.NumOfMonths==36)].ResultsValue.values[0]
    uRes18 = res[(res.LocId == Id) & (res.IndicatorCode == indicator) & (res.NumOfMonths == 18)].ResultsValue.values[0]
    ln = ['X' if uRes >= r[i] and uRes <= r[i+1] else '' for i in range(5)]
    r = ['%.2f'%(i) for i in r[1:4]]
    dict = {'Indicator': indicator.strip(), 'Top Quartile': r[0],  'Median': r[1], 'Bottom Quartile': r[2],
            'Unit': f.name(Id), 'PI-36 Result': uRes.round(3), 'Performance Tendency': tend(uRes18, uRes),
            'Units reporting': len(d), 'Top Quart.': ln[0], '2nd Quart.': ln[1],
            '3rd Quart.': ln[2], 'Bott. Quart.': ln[3], 'Bott. 10 perc.': ln[4]}
    return pd.DataFrame(dict, index=[0])


def paris_df(res, units, date, distribution='Worldwide'):
    engine = create_engine('sqlite:///../PI.sqlite')
    plants = ('SP5  ', 'ISA1 ', 'ISA2 ', 'CISA1', 'CISA2', 'TISA2')
    df = pd.DataFrame()
    for indicator in ('CISA2', 'ISA2 ', 'CRE  ', 'CY   ', 'FLR  ', 'GRLF ', 'SP1  ', 'SP2  ', 'SP5  ', 'UA7  ', 'UCF  ',
                      'UCLF ', 'US7  '):
        print('.',end='')
        for u in units:
            active = x.active_unit(date).LocId.tolist()  # all active units and plants
            centre = f.centre(x.cnt(u), date, False)  # list of units in the same centre
            reactor = pd.read_sql('select D.LocId from PI_NsssTypeLookup T inner join PI_UnitData D \
            on T.NsssTypeId=D.NsssTypeId where T.NsssType="{}"'.format(x.reactor(u, False)), engine).LocId
            ar = set(reactor) & set(active)
            r = set([f.station(u, date) for u in ar])
            r = set(reactor) | set(r)
            # TODO: to be checked
            RandC = set(centre) & set(r)
            distr = active if distribution=='Worldwide' else r if distribution=='Same reactor type' \
                else RandC if distribution=='Same reactor type and RC' else None
            Id = f.station(u,date) if indicator in plants else u
            if distr is not None:
                df = df.append(quartile(res, Id, indicator, distr), ignore_index=False)
            else:
                sys.exit(3)
            if Id != u:
                break
    return df


def paris(units, date):
    """
    table in WANO PC style
    :param units: list of units to be analysed
    :return: df in WANO PC style
    """

    engine = create_engine('sqlite:///../PI.sqlite')


    req = 'select LocId, IndicatorCode, NumOfMonths, ResultsValue from PI_Results where PeriodEndYrMn={} ' \
          'and NumOfMonths in (36,18) and NonQualCode=" "'.format(date)
    res = pd.read_sql(req, engine)
    repType = ['Worldwide', 'Same reactor type', 'Same reactor type and RC']

    for d in repType:
        report = paris_df(res, units, date, d)
        report.to_excel(str(units[0])+d+str(date)+'.xls', index=False)
        if d==repType[0]:
            dfw = report
        elif d==repType[1]:
            dfr = report
        else:
            dfrc = report



    return dfw, dfr, dfrc
# =============================================================
import sys
# DB connection -----------------------------------------------

if __name__ == '__main__':
    #app = wx.App(redirect=False)   # Error messages go to popup window
    #top = Frame("Unit Report Generator v.0.3")
    #top.Show()
    #app.MainLoop()

    #connection.commit()
    #connection.close()
    print(paris([1936],201809))
else:
    connection = sqlite3.connect('pr.sqlite')
    connection.text_factory = str
    cursor = connection.cursor()
    try:
        r = cursor.execute('select UnitLocID,UnitName from Units where IsStation=1 order by UnitName').fetchall()
        yr = cursor.execute('select max(EndDate) from Results').fetchone()[0]
        print(yr)
    except:
        print("There is not database file")
        sys.exit()