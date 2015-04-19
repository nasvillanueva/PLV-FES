<%--
  Created by IntelliJ IDEA.
  User: Nas Villanueva
  Date: 8/19/2014
  Time: 5:12 PM
--%>

<%@ page import="edu.plv.fes.constants.FESConstants" contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main"/>
    <title>Evaluation Reports | PLV-FES</title>
    <script type="text/javascript">

        function onSelectProf(){
            if($(this).hasClass('selected')){
                $('#selectedProf').append($('<option>', {
                    value: this.id,
                    text: $(this).children('td').eq(0).html()
                }));
            }else{
                $('#selectedProf option[value="' + this.id + '"]').remove();
            }
        }

        function printReport(){
            var ids = '';
            if(this.id == 'printReport'){
                $.each($('#selectedProf option'),function(){
                    if(ids == ''){
                        ids = this.value;
                    }else{
                        ids = this.value + ',' + ids
                    }
                });
            }

            if(ids != '' || this.id == 'printAllReport'){
                if(this.id == 'printAllReport'){ ids = 'ALL'; }
                var printUrl = '${createLink(action:'viewPrintStudentEval')}';
                printUrl += '?ids=' + ids + '&schoolyear=' + $('#schoolyear').val() + '&semester='+$('#semester').val();
                window.open(printUrl);
            }else{
                alert("There are no selected professor(s)!");
            }
        }

        function onChangeSemSY(){
            $('#selectedProf option').remove();
            $('#studentResults_grid').dataTable().api().ajax.url('${createLink(action:'viewEvaluatedProfessorList',params:[usertype: edu.plv.fes.constants.FESConstants.USER_TYPE_STUDENT])}' +  '&schoolyear=' + $('#schoolyear').val() + '&semester=' + $('#semester').val()).load();
        }

        function setupGrid() {
            initDataTable('studentResults_grid',
                    {searching:true,autoWidth:true,rowCallback:
                            function( row, data ) {
                                $.each($('#selectedProf option'),function(){
                                    if(data.DT_RowId == this.value) {
                                        $(row).addClass('selected');
                                    }
                                });
                            }
                    },
                    [
                        {data: 'name',width:'35%',className:'dt-head-center dt-body-left'},
                        {data: 'college',width:'35%',className:'dt-head-center dt-body-left'},
                        {data: 'department',width:'20%',className:'dt-head-center dt-body-left'}
                    ], '${createLink(action:'viewEvaluatedProfessorList',params:[usertype: edu.plv.fes.constants.FESConstants.USER_TYPE_STUDENT])}',onSelectProf,'multiple');
        }
        function init() {
            setupGrid();
            $('#printReport, #printAllReport').on('click',printReport);
            $('#clearSelected').on('click',function(){
                $('#selectedProf option').remove();
                $('tr.selected').removeClass('selected');
            });
            $('#filterCheck').on('change',function(){
                $('#filterType').prop('disabled',!$('#filterCheck').prop('checked'));
                if(!$(this).prop('checked')){
                    $('#collegeFilter,#departmentFilter,#rankingFilter').addClass('collapse');
                    $('#collegeFilter,#departmentFilter,#rankingFilter').prop('disabled',true);
                    $('#filterType,#collegeFilter,#departmentFilter,#rankingFilter').val('');
                }

            });
            $('#cFilterCheck').on('change',function(){
                $('#cFilterType').prop('disabled',!$('#cFilterCheck').prop('checked'));
                if(!$(this).prop('checked')){
                    $('#cCollegeFilter,#cDepartmentFilter,#cRankingFilter').addClass('collapse');
                    $('#cCollegeFilter,#cDepartmentFilter,#cRankingFilter').prop('disabled',true);
                    $('#cFilterType,#cCollegeFilter,#cDepartmentFilter,#cRankingFilter').val('');
                }

            });
            $('#lFilterCheck').on('change',function(){
                $('#lFilterType').prop('disabled',!$('#lFilterCheck').prop('checked'));
                if(!$(this).prop('checked')){
                    $('#lCollegeFilter,#lDepartmentFilter,#lRankingFilter').addClass('collapse');
                    $('#lCollegeFilter,#lDepartmentFilter,#lRankingFilter').prop('disabled',true);
                    $('#lFilterType,#lCollegeFilter,#lDepartmentFilter,#lRankingFilter').val('');
                }

            });
            $('#limitCheck').on('change',function(){
                $('#limit').prop('disabled',!$('#limitCheck').prop('checked'));
                if(!$(this).prop('checked')){
                    $('#limit').val('');
                }

            });
            $('#cLimitCheck').on('change',function(){
                $('#cLimit').prop('disabled',!$('#cLimitCheck').prop('checked'));
                if(!$(this).prop('checked')){
                    $('#cLimit').val('');
                }

            });
            $('#lLimitCheck').on('change',function(){
                $('#lLimit').prop('disabled',!$('#lLimitCheck').prop('checked'));
                if(!$(this).prop('checked')){
                    $('#lLimit').val('');
                }

            });
            $('#rankCheck').on('change',function(){
                $('#rankFilter').prop('disabled',!$('#rankCheck').prop('checked'));
                if(!$(this).prop('checked')){
                    $('#rankFilter').val('');
                }

            });
            $('#cRankCheck').on('change',function(){
                $('#cRankFilter').prop('disabled',!$('#cRankCheck').prop('checked'));
                if(!$(this).prop('checked')){
                    $('#cRankFilter').val('');
                }

            });
            $('#lRankCheck').on('change',function(){
                $('#lRankFilter').prop('disabled',!$('#lRankCheck').prop('checked'));
                if(!$(this).prop('checked')){
                    $('#lRankFilter').val('');
                }

            });
            $('#filterType').on('change',function(){
                if($('#filterType').val() == 'College'){
                    $('#collegeFilter').removeClass('collapse');
                    $('#collegeFilter').prop('disabled',false);
                    $('#departmentFilter').addClass('collapse');
                    $('#departmentFilter').prop('disabled',true);
                }else if($('#filterType').val() == 'Department'){
                    $('#departmentFilter').removeClass('collapse');
                    $('#departmentFilter').prop('disabled',false);
                    $('#collegeFilter').addClass('collapse');
                    $('#collegeFilter').prop('disabled',true);
                }else{
                    $('#collegeFilter,#departmentFilter').addClass('collapse');
                    $('#collegeFilter,#departmentFilter').prop('disabled',true);
                }
                $('#collegeFilter,#departmentFilter').val('');
            });
            $('#cFilterType').on('change',function(){
                if($('#cFilterType').val() == 'College'){
                    $('#cCollegeFilter').removeClass('collapse');
                    $('#cCollegeFilter').prop('disabled',false);
                    $('#cDepartmentFilter').addClass('collapse');
                    $('#cDepartmentFilter').prop('disabled',true);
                }else if($('#cFilterType').val() == 'Department'){
                    $('#cDepartmentFilter').removeClass('collapse');
                    $('#cDepartmentFilter').prop('disabled',false);
                    $('#cCollegeFilter').addClass('collapse');
                    $('#cCollegeFilter').prop('disabled',true);
                }else{
                    $('#cCollegeFilter,#cDepartmentFilter').addClass('collapse');
                    $('#cCollegeFilter,#cDepartmentFilter').prop('disabled',true);
                }
                $('#cCollegeFilter,#cDepartmentFilter').val('');
            });
            $('#lFilterType').on('change',function(){
                if($('#lFilterType').val() == 'College'){
                    $('#lCollegeFilter').removeClass('collapse');
                    $('#lCollegeFilter').prop('disabled',false);
                    $('#lDepartmentFilter').addClass('collapse');
                    $('#lDepartmentFilter').prop('disabled',true);
                }else if($('#lFilterType').val() == 'Department'){
                    $('#lDepartmentFilter').removeClass('collapse');
                    $('#lDepartmentFilter').prop('disabled',false);
                    $('#lCollegeFilter').addClass('collapse');
                    $('#lCollegeFilter').prop('disabled',true);
                }else{
                    $('#lCollegeFilter,#lDepartmentFilter').addClass('collapse');
                    $('#lCollegeFilter,#lDepartmentFilter').prop('disabled',true);
                }
                $('#lCollegeFilter,#lDepartmentFilter').val('');
            });

            $('#lEvalStatCheck').on('change',function(){
                $('#lEvalStat').prop('disabled',!$('#lEvalStatCheck').prop('checked'));
                if(!$(this).prop('checked')){
                    $('#lEvalStat').val('');
                }
            });
            $('#schoolyear, #semester').on('change',onChangeSemSY);
        }
    </script
</head>

<body>
<div class="panel panel-material-light-blue">
    <div class="panel-heading">
        <h3 class="panel-title">Evaluation Reports</h3>
    </div>
    <div class="panel-body">
        <g:if test="${flash.message}">
            <div class="alert alert-dismissable alert-success" id="alert">
                <button type="button" class="close" data-dismiss="alert">×</button>
                <strong>${flash.message}</strong>
            </div>
        </g:if>
        <g:if test="${flash.errors}">
            <div class="alert alert-dismissable alert-danger" id="alert">
                <button type="button" class="close" data-dismiss="alert">×</button>
                <strong>${flash.errors}</strong>
            </div>
        </g:if>
        <div class="bs-component">
            <ul class="nav nav-tabs nav-justified" style="margin-bottom: 15px;">
                <li class="active center-block"><a href="#studentReport" data-toggle="tab">Students' Evaluation</a></li>
                <li class="center-block"><a href="#batchReport" data-toggle="tab">Batch / Ranking</a></li>
                <li class="center-block"><a href="#comparisonReport" data-toggle="tab" >Individual Comparison</a></li>
                <li class="center-block"><a href="#groupComparisonReport" data-toggle="tab" >Group Comparison</a></li>
                <li class="center-block"><a href="#listOfFaculty" data-toggle="tab" >List of Faculties</a></li>
            </ul>
            <div id="myTabContent" class="tab-content">

                <div class="tab-pane fade active in" id="studentReport">
                    <g:render template="studentReport"/>
                </div>
                <div class="tab-pane fade in" id="batchReport">
                    <g:render template="batchReport"/>
                </div>
                <div class="tab-pane fade in" id="comparisonReport">
                    <g:render template="comparisonReport"/>
                </div>
                <div class="tab-pane fade in" id="groupComparisonReport">
                    <g:render template="groupComparisonReport"/>
                </div>
                <div class="tab-pane fade in" id="listOfFaculty">
                    <g:render template="listOfFacultiesView"/>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>