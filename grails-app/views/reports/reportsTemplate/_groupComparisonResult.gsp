<%@ page import="java.text.DecimalFormat" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
 "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html>
<head>
    <title>Evaluation Results</title>
    <style  type="text/css">
    @page {
        size: 215.9mm 330.2mm;
    }
    .container{
        page-break-after: always;
    }
    .plv-header{
        width:550px;
        margin:0 auto;
    }

    .plv-header #plvlogo{
        height:0.89in;
        width:0.89in;

    }
    .plvlogowrapper,.plvdesc{
        float:left;
    }
    .plvdesc{
        margin-top:25px;
        margin-left:10px;
    }
    .plv-header #plvname{
        margin:0;
    }
    .plv-header hr{
        margin:0;
        width:428px;
        border:1px solid black;
    }
    .plv-header p{
        text-align: left;
        font-style: italic;
        margin:0;
    }
    .header{
        text-align:center;
        margin-bottom:0;
    }
    .office,.label{
        margin-top:0;
        margin-bottom:0;
    }
    .label{
        text-transform: uppercase;
        text-decoration: underline;
    }
    .results-container{
        width:700px;
        padding:0 25px;
    }
    table.results{
        width:650px;
        margin-left:auto;
        margin-right:auto;
    }
    table, th, td{
        border:1px solid black;
        border-collapse:collapse;
    }
    th,td{
        text-align:center;
    }
    .leftAlign{
        padding-left: 15px;
        text-align:left;
    }
    .odd{
        background-color: #e5e5e5;
    }
    .nameWidth{
        width: 500px;
    }
    .withHeight{
        height:25px;
    }
    td{
        font-size:14px;
    }
    .noWidth{
        width:30px;
    }

    </style>
</head>
<body>
<% int counter = 1; %>
<g:each in="${evaluation}" var="e">
<div class="container">
    <div class="row">
        <div class="header">
            <div class="plv-header">
                <div class="plvlogowrapper">
                    <rendering:inlineJpeg bytes="${plvlogo}" id="plvlogo"/>
                </div>
                <div class="plvdesc">
                    <h3 id="plvname">PAMANTASAN NG LUNGSOD NG VALENZUELA</h3>
                    <hr/>
                    <p>Poblacion II, Malinta, Valenzuela City</p>
                </div>
                <div style="clear:both"></div>
            </div>
            <h3 class="office">OFFICE OF THE DEAN</h3>
            <h3 class="label">Group Comparison Report</h3>
            <h4 class="label plvname">${message}</h4>
            <p class="syay">${semester}<sup>${(semester == 1)?'st':'nd'}</sup> Semester, S.Y ${schoolYear} - ${schoolYear + 1}</p>
        </div>
    </div>
    <div class="results-container">
        <table class="results">
            <tr>
                <th class="noWidth">No.</th>
                <th class="nameWidth">Name</th>
                <g:each in="${evalType}" var="evaluator">
                    <th>${evaluator}</th>
                </g:each>
            </tr>
            <g:each in="${e}" var="ee" status="i">
                <tr class="<% if((i+1) % 2 == 0)%> odd <%;%> withHeight">
                    <td class="noWidth">${counter++}</td>
                    <td class="leftAlign nameWidth">${ee.name}</td>
                    <g:each in="${evalType}" var="evaluator">
                        <td>${ee.getAt(evaluator)}</td>
                    </g:each>
                </tr>
            </g:each>
        </table>
    </div>
</div>
</g:each>
</body>
</html>