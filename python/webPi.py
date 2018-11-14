from bottle import post, request, run, route, view, template
import piAnalysis04, ms2lite

unitlist = []
for i in piAnalysis04.r:
    unitlist.append(i[1])
#print(unitlist)

@route('/select')
#@view('select')
def select():
    return template('select', unitlist=unitlist)

@post('/select') # or @route('/login', method='POST')
def do_login():
    unit = request.forms.get('unit')
    period = request.forms.get('period') or 0
    #print('req:',request.forms.get('upd'))
    if request.forms.get('create') == 'Create' and piAnalysis04.report(unit, period, piAnalysis04.yr):
        return "<p>Report created succesfully</p>"
    elif request.forms.get('upd') == 'Update':
        ms2lite.unitcopy()
        ms2lite.localdbupdateall('201306',piAnalysis04.yr)
        ms2lite.cls()
        return "<p>DB succesfully updated</p>"
    else:
        return "<p>Something went wrong</p>"

run(host='localhost', port=8080, debug=True)