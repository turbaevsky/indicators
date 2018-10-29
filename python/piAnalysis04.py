# -*- coding: utf-8 -*-
"""
TODO:
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

"""
Correct data for Almaraz 1 201503 should be:
UA7: 378/392; 244/250 PWR; 95/98 in PC
"""

import os
import time
##import math
#import sys
##import xlwt
import sqlite3
import numpy as np
from matplotlib.backends.backend_agg import FigureCanvasAgg as FigureCanvas
from matplotlib.figure import Figure
# PDF generation
from reportlab.lib.pagesizes import landscape,letter
from reportlab.pdfgen import canvas
from reportlab.lib.units import mm

import wx

#Constantes
# for pfd-generator
left = 20*mm
down = 20*mm
width = 100*mm
height = 60*mm
border = 10*mm

# Global variables
pr = 0

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
        
##        self.Bind(wx.EVT_COMBOBOX, self.EvtComboBox, self.edithear)

##    def EvtComboBox(self, event):
##        #self.logger.AppendText('EvtComboBox: %s\n' % event.GetCurrentSelection())
##        print 'EvtComboBox: %s\n' % self.edithear.GetCurrentSelection()
        
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

##    def OnAbout(self, event):
##        dlg = AboutBox()
##        dlg.ShowModal()
##        dlg.Destroy()

# Data for plotting -------------------------------------------
def data_processing(r):
# Array normalisation
    rn = []
    for i in r:
        #if i[0]<>'':
        rn.append(i[0])
    #print len(rn)
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
    
    tx = (uvalue-min(bins))*(len(bins)-1)/maxval

    ax.annotate('Unit %s\nvalue = %1.4f\nindividual target = %s,\
        \nindustry target = %s,\ndata status: %s\nBest Quantile:%1.4f\nMedian:%1.4f\nWorst Quantile:%1.4f' \
        % (name,uvalue,indiv_limit,indust_limit,ustat,quantiles[0],quantiles[1],quantiles[2]),\
        xy=(tx,0),xytext=(max(x)/2,max(hist)/2),\
        arrowprops=dict(facecolor='black'))

    ax.set_xlabel(xl)
    ax.set_ylabel('Number of units')
    ax.set_title('%s %s among %d units' % (ccode,distr,sum(hist)))
    fn = name+'-'+ccode+'-'+distr+'.png'
    canvas.print_figure(fn)
    
# Plot the trend ----------------------------------------------
def trend(utrend,ccode,name,period):
    fig = Figure()
    #w=0.35
    canvas = FigureCanvas(fig)
    ax = fig.add_subplot(111)
    x = np.arange(len(utrend))
    hist=[]
    bins=[]
    for i in range(len(utrend)):
        hist.append(utrend[i][1])
        bins.append(utrend[i][0])
        
    #ax.bar(x,hist,alpha=0.5)

    ax.plot(x,hist,'bo-',linewidth=2)
    
    #ax.text(1,max(hist)-max(hist)/8,\
    #         'Best Quantile:%1.4f\nMedian:%1.4f\nWorst Quantile:%1.4f'\
    #         %(quantiles[0],quantiles[1],quantiles[2]))
    ax.grid()
    ax.set_xticklabels(bins, rotation=30, size=10)
    ax.set_xticks(x)
    #ax.annotate('Unit %s\nvalue = %1.4f\ndata status: %s' % (name,uvalue,ustat),\
    #    xy=(uvalue*len(hist)/max(bins),0),xytext=(max(x)/2,max(hist)/2),\
    #    arrowprops=dict(facecolor='black'))
    ax.set_xlabel('Year')
    ax.set_ylabel('%s value' % ccode)
    ax.set_title('%s trend (%d months data period)' % (ccode,period))
    fn = name+'-'+ccode+'-trend'+'.png'
    canvas.print_figure(fn)
    
def report(uname,periodIndex,yr):    # Picture generation ------------------------------------------
    print(uname,periodIndex,yr)
    if periodIndex in [-1,0]:
        period = 36
    else:
        period = 3
        
    top.status.SetRange(len(iList))
    unumber = cursor.execute('select UnitLocID from Units where UnitName = ?',(uname,)).fetchone()[0]
    print(unumber)
    top.St(str(unumber))
    r = cursor.execute('select UnitName,Centre,Reactor,RUP from Units where UnitLocID=?',(unumber,)).fetchall()[0]
    meta = cursor.execute('select * from metadata').fetchall()
    name = r[0]
    centre = r[1]
    reactor = r[2]
    RUP = r[3]
    print(name, centre, reactor)
    # Number of units
    n = []
    n.append(cursor.execute('select count(*) from Units where IsActive=1').fetchone()[0])
    n.append(cursor.execute('select count(*) from Units where IsActive=1 and Reactor = ?', (reactor,)).fetchone()[0])
    n.append(cursor.execute('select count(*) from Units where IsActive=1 and Reactor = ? and Centre = ?',\
                            (reactor,centre,)).fetchone()[0])

    fname = name+'-'+str(yr)+'.pdf'
    top.St('Title page producing...')
    c = canvas.Canvas(fname, pagesize=landscape(letter))
    title = True
    if title:
        
        # The title page -----------------------------------
        c.drawString(left,down+height*2+border*5,'Unit %s data. Data is actual (last DB copy) by %s, \
last unit`s data for %s' % (name,meta[1][1],meta[0][1]))
        c.drawString(left,down+height*2+border*5-10*mm,'Unit related to %s regional centre, reactor type is %s' % (centre,reactor))
        c.drawString(20*mm,70*mm,'Three-year values are presented for indicators (except FRI: most recent operating quarter)')
        c.drawString(20*mm,60*mm,'The most recent worldwide results are used for distribution charts. The period of chart data is %d months' % period)
        c.drawString(20*mm,50*mm,'The most recent station results available are used for trends and comparison to \
WANO Long-term Performance Targets values')
        c.drawString(20*mm,40*mm,'Individual Long-Term Targets is marked by red line, and industry ones - by yellow line')
        c.drawString(20*mm,30*mm,'Report generated on %s' % time.strftime("%a, %d %b %Y at %H:%M"))
        c.drawString(20*mm,20*mm,'Unit vs. WANO Worldwide, WANO Worldwide %s and WANO %s Centre for %s type. Charts included qualified data only.' \
                     % (reactor,centre,reactor))
        c.drawString(20*mm,10*mm,'The total number of units in the DB is %d, %d have the same reactor type, and %d of them belong the same RC' %\
                     (n[0],n[1],n[2]))
        c.drawImage('wano.png',220*mm,180*mm,51*mm,13*mm)
        c.drawImage('almaraz1.jpg',20*mm,90*mm,220*mm-40*mm,113*mm-40*mm)

        c.showPage()
    top.St('Title page produced')
    # --------------
    cnt = 0
    for ccode in iList:
        print(ccode)
        cnt += 1
        top.Sv(cnt)
        top.St(ccode)
        # Distributions -----------------------------------------------
        ww = cursor.execute('select Value from Results where Indicator=? and EndDate=? \
            and Value is not null and Code = "None" order by Value asc',(ccode,yr)).fetchall() # Worldwide distr

        # Is it plant-based data?
        #print('ccode=',ccode)
        if ccode in plants:
            unumber = cursor.execute('select StLocId from Units where UnitLocID = ?',(unumber,)).fetchone()[0]
            print(unumber,centre,ccode,yr,reactor)
            wr = cursor.execute('select Results.Value from Results,Units where Results.Indicator=? and Results.EndDate=? \
                and Units.Reactor=? and Units.StLocId = Results.UnitID \
                and Results.Value is not null and Results.Code = "None" group by Units.StLocId'\
                ,(ccode,yr,reactor,)).fetchall() # Worldwide distr by reactor type
            rcr = cursor.execute('select Results.Value from Results,Units where Units.Centre = ? and Results.Indicator=? and Results.EndDate=? \
                and Results.Value is not null and Units.Reactor=? and Units.StLocId = Results.UnitID \
                and Results.Code = "None" group by Units.StLocId, Units.Centre'\
                ,(centre,ccode,yr,reactor,)).fetchall() # RC distr by reactor type
            if period == 36:
                utrend = cursor.execute('select EndDate,Value from Results where Indicator=? and UnitID=? \
                and Value is not null and Code = "None" order by EndDate asc',\
                (ccode,unumber)).fetchall() # trend for current unit
            else:
                utrend = cursor.execute('select EndDate,Value from Results3 where Indicator=? and UnitID=? \
                and Value is not null and Code = "None" order by EndDate asc',\
                (ccode,unumber)).fetchall() # trend for current unit

        else:
            unumber = cursor.execute('select UnitLocID from Units where UnitName = ?',(uname,)).fetchone()[0]
            print(unumber,centre,ccode,yr,reactor)
            wr = cursor.execute('select Results.Value from Results,Units where Results.Indicator=? and Results.EndDate=? \
                and Results.Value is not null and Units.Reactor=? and Units.UnitLocID = Results.UnitID \
                and Results.Code = "None" order by Results.Value asc'\
                ,(ccode,yr,reactor,)).fetchall() # Worldwide distr by reactor type
            rcr = cursor.execute('select Results.Value from Results,Units where Units.Centre = ? and Results.Indicator=? and Results.EndDate=? \
                and Results.Value is not null and Units.Reactor=? and Units.UnitLocID = Results.UnitID \
                and Results.Code = "None" order by Results.Value asc'\
                ,(centre,ccode,yr,reactor,)).fetchall() # RC distr by reactor type
            if period == 36:
                utrend = cursor.execute('select EndDate,Value from Results where Indicator=? and UnitID=? \
                and Value is not null and Code = "None" order by EndDate asc',\
                (ccode,unumber)).fetchall() # trend for current unit
            else:
                utrend = cursor.execute('select EndDate,Value from Results3 where Indicator=? and UnitID=? \
                and Value is not null and Code = "None" order by EndDate asc',\
                (ccode,unumber)).fetchall() # trend for current unit

        # Lengths
        print(len(ww),len(wr),len(rcr))
        # Unit details ------------------------------------------------
        try:
            uvalue = cursor.execute('select Value from Results where Indicator=? and EndDate=? \
            and UnitID=?',(ccode,yr,unumber)).fetchone()[0] # Unit value
        except:
            uvalue = 'N/A'
        ustat = cursor.execute('select Code from Results where Indicator=? and EndDate=? \
            and UnitID=?',(ccode,yr,unumber)).fetchone()[0] # Unit value status (missed data?)
        ustat = statuses[ustat]
        # Draw the picture
        c.drawString(left,down+height*2+border*5,'Unit %s (station for SP5 and ISA) data for %s. ' % (name,ccode))
        # Check the selection availability
        
        # Processing
        if ccode not in ['FRI']:
            out = data_processing(ww)
            plot(ranges,out['hist'],out['bins'],out['quant'],name,uvalue,ustat,ccode,distrs[0],reactor)
            fn = name+'-'+ccode+'-'+distrs[0]+'.png'
            c.drawImage(fn,left,down+height+border*2,left+width,down+height)
            os.remove(fn)

        out = data_processing(wr)
        plot(ranges,out['hist'],out['bins'],out['quant'],name,uvalue,ustat,ccode,distrs[1],reactor)
        fn = name+'-'+ccode+'-'+distrs[1]+'.png'
        c.drawImage(fn,left+width+border,down+height+border*2,left+width,\
                down+height)
        os.remove(fn)
        
        out = data_processing(rcr)
        plot(ranges,out['hist'],out['bins'],out['quant'],name,uvalue,ustat,ccode,distrs[2],reactor)
        fn = name+'-'+ccode+'-'+distrs[2]+'.png'
        c.drawImage(fn,left,down,left+width,down+height)
        os.remove(fn)

        trend(utrend,ccode,name,period)
        fn = name+'-'+ccode+'-trend'+'.png'
        c.drawImage(fn,left+width+border,down,left+width,down+height)
        os.remove(fn)
        
        c.showPage()
        # Here add code for the next page
    c.save()
        
# =============================================================

# DB connection -----------------------------------------------

# missdata(yr)
# pris_num_comp()
# rup()
# wanoToPris()
# priscompar()
# report()
# sspi(2014)

app = wx.App(redirect=  False)   # Error messages go to popup window
top = Frame("Unit Report Generator v.0.3")
top.Show()
app.MainLoop()

##print('Finished')    
connection.commit()
connection.close()
