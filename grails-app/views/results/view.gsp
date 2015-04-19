<%--
  Created by IntelliJ IDEA.
  User: Nas Villanueva
  Date: 8/19/2014
  Time: 5:12 PM
--%>

<%@ page import="edu.plv.fes.SystemConfiguration; edu.plv.fes.constants.FESConstants" contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main"/>
    <title>Evaluation Results | PLV-FES</title>
    <script type="text/javascript">

        var viewProfScore = '${createLink(action:'viewProfScoreList')}';
        var viewOverallScore = '${createLink(action:'viewOverallScore')}';
        var viewTallyCounter = '${createLink(action:'viewTallyCounter')}';
        function onSelectProf(){
            var parentId = $(this).closest('table').attr('id');
            var usertype = '';
            if(parentId == 'studentResults_grid') usertype = '${FESConstants.USER_TYPE_STUDENT}';
            else if(parentId == 'peerResults_grid') usertype = '${FESConstants.USER_TYPE_CHAIR}';
            else if(parentId == 'supervisorResults_grid') usertype = '${FESConstants.USER_TYPE_SUPER}';
            if($(this).hasClass('selected')){
                $('#evalresult_grid').dataTable().api().ajax.url(viewProfScore + '?usertype='+usertype+'&id='+this.id).load();

                $.post(viewOverallScore,{id:this.id,usertype:usertype},function(data){
                    $('#profScore').text(data.score);
                });
                if(usertype == '${FESConstants.USER_TYPE_STUDENT}'){
                    $.post(viewTallyCounter,{id:this.id},function(data){
                        $('#tallyCounter').text(data.count);
                    });
                }else{
                    $('#tallyCounter').text('1');
                }
                $('#profName').text($(this).children('td').eq(0).html());
                $('#schoolyear, #semester').prop('disabled',false);
                $('#profscore_id').val(this.id);
            }else{
                resetView();
            }
        }

        function onChangeSemSY(){
            var activeLink = $('#resultNav li.active a').attr('href');
            var usertype = '';
            if(activeLink == '#studentResult') usertype = '${FESConstants.USER_TYPE_STUDENT}';
            else if(activeLink == '#peerResult') usertype = '${FESConstants.USER_TYPE_CHAIR}';
            else if(activeLink == '#supervisorResult') usertype = '${FESConstants.USER_TYPE_SUPER}';

            $('#evalresult_grid').dataTable().api().ajax.url(viewProfScore + '?usertype='+usertype+'&id='+$('#profscore_id').val() + '&schoolyear=' + $('#schoolyear').val() + '&semester=' + $('#semester').val()).load();
            $.post(viewOverallScore,{id:$('#profscore_id').val(),usertype:usertype,schoolyear:$('#schoolyear').val(),semester:$('#semester').val()},function(data){
                $('#profScore').text(data.score);
            });
            if(usertype == '${FESConstants.USER_TYPE_STUDENT}'){
                $.post(viewTallyCounter,{id:$('#profscore_id').val(),schoolyear:$('#schoolyear').val(),semester:$('#semester').val()},function(data){
                    $('#tallyCounter').text(data.count);
                });
            }else{
                $('#tallyCounter').text('1');
            }
        }

        function resetView(){
            $('#prof_id').val('');
            $('#profName').text('');
            $('#profScore').text('');
            $('#tallyCounter').text('');
            $('tr.selected').removeClass('selected');
            $('#evalresult_grid').dataTable().api().ajax.url('${createLink(action:'viewJSON')}').load();
            $('#schoolyear').val('${SystemConfiguration.findByConfigName('schoolyear').configValue}');
            $('#semester').val('${SystemConfiguration.findByConfigName('semester').configValue}');
            $('#schoolyear, #semester').prop('disabled',true);
        }

        function setupGrid() {
            initDataTable('studentResults_grid',
                    {searching:true,autoWidth:true},
                    [
                        {data: 'name',width:'35%',className:'dt-head-center dt-body-left'},
                        {data: 'college',width:'35%',className:'dt-head-center dt-body-left'},
                        {data: 'department',width:'20%',className:'dt-head-center dt-body-left'}
                    ], '${createLink(action:'viewEvaluatedProfessorList',params:[usertype: edu.plv.fes.constants.FESConstants.USER_TYPE_STUDENT])}',onSelectProf,'prof_id');
            initDataTable('peerResults_grid',
                    {searching:true,autoWidth:true},
                    [
                        {data: 'name',width:'30%',className:'dt-head-center dt-body-left'},
                        {data: 'college',width:'40%',className:'dt-head-center dt-body-left'},
                        {data: 'department',width:'20%',className:'dt-head-center dt-body-left'}
                    ], '${createLink(action:'viewEvaluatedProfessorList',params:[usertype: edu.plv.fes.constants.FESConstants.USER_TYPE_CHAIR])}',onSelectProf,'prof_id');
            initDataTable('supervisorResults_grid',
                    {searching:true,autoWidth:true},
                    [
                        {data: 'name',width:'30%',className:'dt-head-center dt-body-left'},
                        {data: 'college',width:'40%',className:'dt-head-center dt-body-left'},
                        {data: 'department',width:'20%',className:'dt-head-center dt-body-left'}
                    ], '${createLink(action:'viewEvaluatedProfessorList',params:[usertype: edu.plv.fes.constants.FESConstants.USER_TYPE_SUPER])}',onSelectProf,'prof_id');

            initDataTable('evalresult_grid',
                    {paging:false,info:false,pageLength:5},
                    [
                        {data: 'category',width:'50%',className:'dt-head-center dt-body-left'},
                        {data: 'score',width:'50%',className:'dt-center'}
                    ], '${createLink(action:'viewJSON')}','','');
        }
        function init() {
            setupGrid();
            $('a[data-toggle="tab"]').on('shown.bs.tab', function () {
                var hrefProp = $(this).attr('href');
                var id = '';
                if(hrefProp == '#studentResult') id = '#studentResults_grid';
                else if(hrefProp == '#peerResult') id = '#peerResults_grid';
                else if(hrefProp == '#supervisorResult') id = '#supervisorResults_grid';
                $(id).dataTable().api().columns.adjust().draw();
                resetView();
            });
            $('#schoolyear,#semester').on('change',onChangeSemSY);
        }
    </script
</head>

<body>
<div class="panel panel-material-light-blue">
    <div class="panel-heading">
        <h3 class="panel-title">Evaluation Results</h3>
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
        <div class="bs-component">
            <ul id="resultNav" class="nav nav-tabs nav-justified" style="margin-bottom: 15px;">
                <li class="active center-block destroyTable"><a href="#studentResult" data-toggle="tab">Students' Evaluation</a></li>
                <li class="center-block destroyTable"><a href="#peerResult" data-toggle="tab">Peer Evaluation</a></li>
                <li class="center-block destroyTable"><a href="#supervisorResult" data-toggle="tab" >Supervisor Evaluation</a></li>
            </ul>
            <div id="myTabContent" class="tab-content">
                <g:hiddenField name="prof_id"/>
                <div class="tab-pane fade active in" id="studentResult">
                    <g:render template="studentResult"/>
                </div>
                <div class="tab-pane fade in" id="peerResult">
                    <g:render template="peerResults"/>
                </div>
                <div class="tab-pane fade in" id="supervisorResult">
                    <g:render template="supervisorResults"/>
                </div>
            </div>
        </div>

        <div class="panel">
            <div class="panel-body">
                <div class="col-md-12">
                    <div class="form-group form-group-material-light-blue">
                        <div class="col-md-6">
                            <label for="schoolyear" class="control-label col-md-4">School Year:</label>
                            <div class="col-md-8">
                                <g:select from="${evalYear}" noSelection='["${SystemConfiguration.findByConfigName('schoolyear').configValue}":"${SystemConfiguration.findByConfigName('schoolyear').configValue}"]' name="schoolyear" class="form-control" disabled="disabled"/>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <label for="semester" class="control-label col-md-4">Semester:</label>
                            <div class="col-md-8">
                                <g:select from="${[[key:'1',value:'1st Semester'],[key:'2',value:'2nd Semester']]}" value="${SystemConfiguration.findByConfigName('semester').configValue}" optionKey="key" optionValue="value" name="semester" class="form-control" disabled="disabled"/>
                            </div>
                        </div>
                    </div>
                    <br/>
                    <div class="form-group form-group-material-light-blue">
                        <h3><label class="control-label">Professor: <span id="profName"></span></label><br/><label class="control-label">Overall: <span id="profScore"></span></label><br/><label class="control-label">Tally: <span id="tallyCounter"></span></label></h3>
                        <g:hiddenField name="profscore_id"/>
                    </div>
                    <div class="table-responsive">
                        <table id="evalresult_grid" class="table table-striped table-bordered table-hover" style="height:300px !important;">
                            <thead>
                            <tr>
                                <th>Category</th>
                                <th>Score</th>
                            </tr>
                            </thead>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>