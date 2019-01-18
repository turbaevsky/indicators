<html>
<head>
    <link rel="stylesheet" type="text/css" href="/static/move.css">
    <link rel="stylesheet" type="text/css" href="/static/main.css">
    <script type="text/javascript" src="/static/move.js"></script>
    <script type="text/javascript" src="/static/msg.js"></script>

    <style>
* {
  box-sizing: border-box;
}

/* Create two equal columns that floats next to each other */
.column {
  float: left;
  width: 30%;
  padding: 10px;
}

/* Clear floats after the columns */
.row:after {
  content: "";
  display: table;
  clear: both;
}
</style>
</head>

<body>

<h1>Performance Indicators</h1>
<div class="row">
  <div class="column">
<h2>Performance Indicators Reporter</h2>

<form method="post">
    <h3>Get report for Peer Review Team</h3>
Unit:
<select name="unit">
    % for unit in unitlist:
        <option value="{{unit}}">{{unit}}</option>
    % end
</select><br>
<br><button type="submit" value="Create" name="create" id="create" onclick="document.getElementById('create').innerHTML = 'Creating report...'">Create Station report</button>
    <hr>
    <h3>Get DB copies</h3>
<button value="Update" type="submit" name="upd" id = "upd" onclick="document.getElementById('upd').innerHTML = 'Updating local DB...'">Update local DB for Station Report</button>
<button value="DBCopy" type="submit" name="sql" id = "sql" onclick="document.getElementById('sql').innerHTML = 'Copying MS DB...'">Copy whole the DB from server</button>

<hr>
    <h3>Generate quarter report</h3>
    Quarter (YYYYMM): <input type="text" name="rdate" value="201812"><br>
    <button name="rep" value="generate" type="submit" id = "rep" onclick="this.innerHTML = 'Working...'">Generate pictures for quarter report</button>
<hr>
    <h3>Put IndValues diff table into 'new' DB</h3>
  Old DB file (w/o extention): <input type="text" name="old">
  <br>
  New DB file (w/o extention): <input type="text" name="new">
  <br>
  <button value="compare" type="submit" id="comp" name="comp" onclick="document.getElementById('comp').innerHTML = 'Working...'">Get diff</button>


<hr>
    <h3> Generate Excel spreadsheet(s)</h3>
    Dates (divided by comma): <input type="text" name="dates" value="201812"><br>
    <button value="gen" type="submit" id="xls" name="xls" onclick="document.getElementById('xls').innerHTML = 'Working...'">Generate spreadsheet only</button>
    <button value="gen" type="submit" id="xlsf" name="xlsf" onclick="document.getElementById('xlsf').innerHTML = 'Working...'">Generate comprehensive spreadsheet for Tokyo</button>
<hr>

    <h3>Metrics</h3>
    Quarter (YYYYMM): <input type="text" name="mdate" value="201812"><br>
    <button value="gen" type="submit" id="metrics" name="metrics" onclick="document.getElementById('metrics').innerHTML = 'Working...'">Generate metrics in md format</button>

<hr>

    <h3>Igor's table</h3>
    Quarter (YYYYMM): <input type="text" name="idate" value="201809"><br>
    Centre (one letter): <input type="text" name="c" value = "all"><br>
    Start date for WER: <input type="text" name="startdate" value = "2018-01-01"><br>
    <button value="gen" type="submit" id="itable" name="itable" onclick="this.innerHTML = 'Working...'">Generate table</button>

</form>
  </div>

      <div class="column">
    <h2>Column 2</h2>
    <p>Some text..</p>
  </div>
</div>

</body>
</html>