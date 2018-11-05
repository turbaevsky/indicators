<html>
<body>

<form action="/select" method="post">

Unit:

<select name="unit">
    % for unit in unitlist:
        <option value="{{unit}}">{{unit}}</option>
    % end
</select>
<p>


    <input type="submit" value="Create report">
</form>

</body>
</html>