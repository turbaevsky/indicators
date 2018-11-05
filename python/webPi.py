from bottle import post, request, run, route, view, template
import piAnalysis04

unitlist = []
for i in piAnalysis04.r:
    unitlist.append(i[1])
print(unitlist)

@route('/select')
#@view('select')
def select():
    return template('select', unitlist=unitlist)

@post('/select') # or @route('/login', method='POST')
def do_login():
    unit = request.forms.get('unit')
    period = request.forms.get('period') or 0
    if piAnalysis04.report(unit, period, 201806):
        return "<p>Report created succesfully</p>"
    else:
        return "<p>Something went wrong</p>"

run(host='localhost', port=8080, debug=True)