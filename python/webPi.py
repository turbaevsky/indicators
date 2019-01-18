from bottle import post, request, run, route, view, template, static_file, debug, Bottle, redirect
import piAnalysis04, ms2lite, dbCopy, functions as f, xlsGenerator as x, metrics as m
import os, sys

dirname = os.path.dirname(sys.argv[0])

app = Bottle()

unitlist = []
for i in piAnalysis04.r:
    unitlist.append(i[1])


@app.route('/comp')
def comp():
    return 'Operation successfully completed'


@app.route('/static/<filename:re:.*\.js>')
def send_js(filename):
    return static_file(filename, root=dirname+'/static')


@app.route('/static/<filename:re:.*\.css>')
def send_css(filename):
    return static_file(filename, root=dirname+'/static')


@app.route('/')
def index():
    return template('select', unitlist=unitlist, period='period')


@app.post('/') # or @route('/login', method='POST')
def do_login():
    #static_file('static/test.html')
    unit = request.forms.get('unit')
    period = request.forms.get('period') or 0
    #print('req:',request.forms.get('upd'))
    if request.forms.get('create') == 'Create' and piAnalysis04.report(unit, period, piAnalysis04.yr):
        redirect('/')
        return "<script> alert('Report created successfully'); </script>"

    elif request.forms.get('upd') == 'Update':
        ms2lite.unitcopy()
        ms2lite.localdbupdateall('201309', piAnalysis04.yr)
        ms2lite.cls()
        redirect('/')
        return "<script> alert('DB successfully updated'); </script>"

    elif request.forms.get('sql') == 'DBCopy':
        dbCopy.db_copy()
        redirect('/')
        return "<script> alert('MS DB successfully copied'); </script>"

    elif request.forms.get('comp') == 'compare':
        f.dbdiff(request.forms.get('old'), request.forms.get('new'))
        redirect('/')

    elif request.forms.get('xls') == 'gen':
        for d in (int(i) for i in request.forms.get('dates').split(',')):
            x.xls(d)
        redirect('/')

    elif request.forms.get('xlsf') == 'gen':
        for d in (int(i) for i in request.forms.get('dates').split(',')):
            fn = 'reports/xls/' + str(d)[:4] + '_WANO_PIData_Rev.xls'
            writer = pd.ExcelWriter(fn)
            xls(d).to_excel(writer, sheet_name='PI Spreadsheet', index=False)
            logging.info(f'Spreadsheet successfully written into {fn}')
            DES(d, 'T').to_excel(writer, sheet_name='PI-DES', index=False)
            logging.info(f'DES successfully written into {fn}')
            WER(int(str(d)[:4])).to_excel(writer, sheet_name='WER', index=False)
            logging.info(f'WER successfully written into {fn}')
            SOER(d, 'T').to_excel(writer, sheet_name='SOER', index=False)
            logging.info(f'SOER successfully written into {fn}')
            writer.save()
            logging.info(f'All successfully written into {fn}')
        redirect('/')

    elif request.forms.get('metrics') == 'gen':
        m.metricMdTable(request.forms.get('mdate'))
        redirect('/')

    elif request.forms.get('itable') == 'gen':
        f.iTable(request.forms.get('idate'),request.forms.get('c'), request.forms.get('startdate'), True)
        redirect('/')

    elif request.forms.get('rep') == 'generate':
        f.charting()
        for c in ['A', 'M', 'P', 'T', 'all']:
            f.index_chart(request.forms.get('rdate'), c)
        redirect('/')

    else:
        #return template('Something went wrong')
        redirect('/')
        return "Something went wrong. <script> alert('Something went wrong on'); </script>"
        pass


@app.route('/my_ip')
def show_ip():
    ip = request.environ.get('REMOTE_ADDR')
    # or ip = request.get('REMOTE_ADDR')
    # or ip = request['REMOTE_ADDR']
    return template("Your IP is: {{ip}}", ip=ip)


run(app, host='localhost', port=8080, debug=True, reloader=True)