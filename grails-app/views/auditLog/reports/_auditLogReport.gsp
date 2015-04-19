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
        padding:0 4px;
    }
    .results{
        width:100%;
    }
    table, th, td{
        border:1px solid black;
        border-collapse:collapse;
    }
    th,td{
        text-align:center;
    }
    .leftAlign{
        text-align:left;
        padding:5px;
    }
    .odd{
        background-color: #e5e5e5;
    }
    .withHeight{
        height:25px;
    }
    .noWidth{
        width:30px;
    }
    .nameWidth{
        width:190px;
    }
    .withWidth{
        width:110px;
    }
    td{
        font-size:12px;
    }

    </style>
</head>
<body>
<%
    int counter = 1;
%>
<g:each in="${auditLog}" var="a" status="i">
    <div class="container">
        <div class="row" id="header">
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
                <h3 class="label">Audit Logs</h3>
                <h4 class="label plvname">${message}</h4>
                <p class="syay">${dateFrom} - ${dateTo}</p>
            </div>
        </div>
        <div class="results-container">
            <table class="results">
                <tr>
                    <th class="noWidth">No.</th>
                    <th>Log Date</th>
                    <th>User</th>
                    <th>Event</th>
                    <th>Module</th>
                    <th>Entity</th>
                    <th>Property</th>
                    <th>Old Value</th>
                    <th>New Value</th>
                </tr>
                <g:each in="${a}" var="ac" status="ai">
                    <tr class="<% if((ai+1) % 2 == 0)%> odd <%;%> withHeight">
                        <td class="noWidth">${counter++}</td>
                        <td>${ac.logDate}</td>
                        <td>${ac.user}</td>
                        <td>${ac.event}</td>
                        <td>${ac.module}</td>
                        <td>${ac.object}</td>
                        <td>${ac.property}</td>
                        <td>${ac.oldValue}</td>
                        <td>${ac.newValue}</td>
                    </tr>
                </g:each>
            </table>
        </div>
    </div>
</g:each>
</body>
</html>