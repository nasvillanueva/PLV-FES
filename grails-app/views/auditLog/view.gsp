<%--
  Created by IntelliJ IDEA.
  User: NazIsEvil
  Date: 2/23/2015
  Time: 7:21 PM
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main"/>
    <title>Audit Logs | PLV-FES</title>
    <script>
        function setupGrids() {
            initDataTable('auditLog_grid', {},
                    [
                        {data: 'logDate',width:'15%',className:'dt-head-center dt-body-left small'},
                        {data: 'user',width:'10%',className:'dt-center small'},
                        {data: 'event',width:'5%',className:'dt-center small'},
                        {data: 'module',width:'10%',className:'dt-center small'},
                        {data: 'object',width:'15%',className:'dt-center small'},
                        {data: 'property',width:'5%',className:'dt-center small'},
                        {data: 'oldValue',width:'15%',className:'dt-center small'},
                        {data: 'newValue',width:'15%',className:'dt-center small'}
                    ], '${createLink(action:'viewAuditLogList')}','','dummy');
        }
        function printAuditLog(){
            if($('#auditLog_grid_info').text() != 'Showing 0 to 0 of 0 entries'){
                var printLink = '${createLink(action:'viewPrintAuditLog')}' +
                        '?dateFrom=' + $('#dateFrom').val() +
                        '&dateTo=' + $('#dateTo').val() +
                        '&actor=' + $('#actor').val() +
                        '&event=' + $('#event').val() +
                        '&module=' + $('#module').val();
                window.open(printLink);
            }else{
                alert("There are no logs to print based on the filters.")
            }
            return false;
        }
        function init() {
            setupGrids();
            $( "#dateFrom, #dateTo" ).datepicker({
                changeMonth: true,
                changeYear: true
            });

            $("#filters input[type='text'], #filters select, #dummy").on('keyup change',function(){
                var ajaxLink = '${createLink(action:'viewAuditLogList')}' +
                        '?dateFrom=' + $('#dateFrom').val() +
                        '&dateTo=' + $('#dateTo').val() +
                        '&actor=' + $('#actor').val() +
                        '&event=' + $('#event').val() +
                        '&module=' + $('#module').val();
                $('#auditLog_grid').dataTable().api().ajax.url(ajaxLink).load();
            });

            $('#btnPrint').on('click',printAuditLog);
            $('#btnReset').on('click',function(){
                $('#dummy').trigger('change');
            });
        }
    </script>
</head>

<body>
<g:hiddenField name="dummy"/>
<div class="panel panel-material-light-blue">
    <div class="panel-heading">
        <h3 class="panel-title">Audit Logs</h3>
    </div>
    <div class="panel-body">
        <g:if test="${flash.message}">
            <div class="alert alert-dismissable" id="alert">
                <button type="button" class="close" data-dismiss="alert">×</button>
                <strong>${flash.message}</strong>
            </div>
            <script>
                if('${success}' == 'true') $('#alert').addClass('alert-success');
                else if('${success}' == 'false') $('#alert').addClass('alert-danger');
            </script>
        </g:if>
        <div class="panel">
            <div class="panel-body">
                <g:form  role="form" class="form-horizontal" name="filters">
                    <g:hiddenField name="dummy"/>
                    <div class="form-group form-group-material-light-blue col-md-11 col-md-offset-1">
                        <label class="control-label lead">Filters:</label>
                    </div>
                    <div class="form-group form-group-material-light-blue">
                        <label class="control-label col-md-2">Date From:</label>

                        <div class="col-md-10">
                            <div class="input-group">
                                <input id="dateFrom" type="text" class="date-picker form-control" />
                                <label for="dateFrom" class="input-group-addon btn"><i class="mdi-action-event"></i></label>
                            </div>
                        </div>
                    </div>
                    <div class="form-group form-group-material-light-blue">
                        <label class="control-label col-md-2">Date To:</label>

                        <div class="col-md-10">
                            <div class="input-group">
                                <input id="dateTo" type="text" class="date-picker form-control" />
                                <label for="dateTo" class="input-group-addon btn"><i class="mdi-action-event"></i></label>
                            </div>
                        </div>
                    </div>
                    <div class="form-group form-group-material-light-blue">
                        <label for="actor" class="control-label col-md-2">User:</label>

                        <div class="col-md-10">
                            <fesSelect:auditUsers name="actor" class="form-control"/>
                        </div>
                    </div>
                    <div class="form-group form-group-material-light-blue">
                        <label for="actor" class="control-label col-md-2">Event:</label>

                        <div class="col-md-10">
                            <fesSelect:auditEvents name="event" class="form-control"/>
                        </div>
                    </div>
                    <div class="form-group form-group-material-light-blue">
                        <label for="actor" class="control-label col-md-2">Module:</label>

                        <div class="col-md-10">
                            <fesSelect:auditModules name="module" class="form-control"/>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-4 col-md-offset-8">
                            <input type="button" id="btnPrint" value="Print" class="btn btn-material-light-blue"/>
                            <input type="reset" id="btnReset" value="Reset" class="btn btn-default"/>
                        </div>
                    </div>
                </g:form>

            </div>
        </div>

        <div class="panel panel-material-light-blue">
            <div class="panel-body">
                <div class="table-responsive">
                    <table id="auditLog_grid" class="table table-striped table-bordered table-hover table-condensed">
                        <thead>
                        <tr>
                            <th>Log Date</th>
                            <th>User</th>
                            <th>Event</th>
                            <th>Module</th>
                            <th>Entity</th>
                            <th>Property</th>
                            <th>Old Value</th>
                            <th>New Value</th>
                        </tr>
                        </thead>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>
<script src="${resource(file: 'js/jquery-ui.js')}"></script>
<link rel="stylesheet" href="${resource(file: 'css/jquery-ui.structure.css')}"/>
<link rel="stylesheet" href="${resource(file: 'css/jquery-ui.css')}"/>
<link rel="stylesheet" href="${resource(file: 'css/jquery-ui.theme.css')}"/>
</body>
</html>