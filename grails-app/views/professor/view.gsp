<%--
  Created by IntelliJ IDEA.
  User: NazIsEvil
  Date: 1/6/2015
  Time: 4:05 PM
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main"/>
    <title>Professors | PLV-FES</title>
    <script>
        var viewProfessor = '${createLink(action:'viewProfessor')}';
        function onSelectProfessor() {
            if($(this).hasClass('selected')){
                $.post(viewProfessor,{id:this.id},function(data){
                    if(data.id){
                        $('#prof_id').val(data.id);
                        $('#title').val(data.title);
                        $('#firstname').val(data.firstname);
                        $('#middlename').val(data.middlename);
                        $('#surname').val(data.surname);
                        $('#ranking').val(data.ranking);
                        $('#college').val(data.college);
                        $('#department').val(data.department);
                        $('#prof_active').prop('checked',data.active);

                        $('#btnAdd').attr('disabled',true);
                        $('#btnUpdate').attr('disabled',false);
                    }
                });
            }else{
                $('form').trigger('reset');
                $('#btnAdd').attr('disabled',false);
                $('#btnUpdate').attr('disabled',true);
                $('tr.selected').removeClass('selected');
            }
        }
        function setupGrids() {
            initDataTable('prof_grid', {searching:true},
                    [
                        {data: 'name',width:'25%',className:'dt-head-center dt-body-left'},
                        {data: 'ranking',width:'20%',className:'dt-head-center dt-body-left'},
                        {data: 'college',width:'25%',className:'dt-head-center dt-body-left'},
                        {data: 'department',width:'25%',className:'dt-head-center dt-body-left'},
                        {data: 'active',width:'5%',className:'dt-center'}
                    ], '${createLink(action:'viewProfessorList')}',onSelectProfessor,'prof_id');

        }
        function init() {
            setupGrids();
            $('#prof_active').on('change',function(){
                if($('#prof_id').val() != '' && !this.checked){
                    $('#title, #ranking, #college, #department').removeAttr('required');
                }else{
                    $('#title, #ranking, #college, #department').prop('required','required');
                }
            });
        }
    </script>
</head>

<body>
<div class="panel panel-material-light-blue">
    <div class="panel-heading">
        <h3 class="panel-title">Professors</h3>
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
        <div class="panel panel-material-light-blue">
            <div class="panel-body">
                <div class="table-responsive">
                    <table id="prof_grid" class="table table-striped table-bordered table-hover">
                        <thead>
                        <tr>
                            <th>Name</th>
                            <th>Ranking</th>
                            <th>College</th>
                            <th>Department</th>
                            <th>Active</th>
                        </tr>
                        </thead>
                    </table>
                </div>
            </div>
        </div>

        <div class="panel">
            <div class="panel-body">
                <g:form useToken="true" role="form" class="form-horizontal">
                    <g:hiddenField name="prof_id"/>
                    <div class="form-group form-group-material-light-blue">
                        <label for="title" class="control-label col-md-2">Title:</label>

                        <div class="col-md-10">
                            <fesSelect:title name="title" class="form-control" value="${prof?.salutation}" required="true"/>
                        </div>
                    </div>
                    <div class="form-group form-group-material-light-blue">
                        <label for="firstname" class="control-label col-md-2">First Name:</label>

                        <div class="col-md-10">
                            <g:field name="firstname" type="text" class="form-control" placeholder="First Name" value="${prof?.firstname}" required="true"/>
                        </div>
                    </div>
                    <div class="form-group form-group-material-light-blue">
                        <label for="middlename" class="control-label col-md-2">Middle Name:</label>

                        <div class="col-md-10">
                            <g:field name="middlename" type="text" class="form-control" placeholder="Middle Name" value="${prof?.middlename}" required="true"/>
                        </div>
                    </div>
                    <div class="form-group form-group-material-light-blue">
                        <label for="surname" class="control-label col-md-2">Surname:</label>

                        <div class="col-md-10">
                            <g:field name="surname" type="text" class="form-control" placeholder="Surname" value="${prof?.surname}" required="true"/>
                        </div>
                    </div>
                    <div class="form-group form-group-material-light-blue">
                        <label for="college" class="control-label col-md-2">Ranking:</label>

                        <div class="col-md-10">
                            <fesSelect:ranking name="ranking" class="form-control" required="true" value="${prof?.ranking?.id}"/>
                        </div>
                    </div>
                    <div class="form-group form-group-material-light-blue">
                        <label for="college" class="control-label col-md-2">College:</label>

                        <div class="col-md-10">
                            <fesSelect:college name="college" class="form-control" required="true" value="${prof?.college?.id}"/>
                        </div>
                    </div>
                    <div class="form-group form-group-material-light-blue">
                        <label for="department" class="control-label col-md-2">Department:</label>

                        <div class="col-md-10">
                            <fesSelect:department name="department" class="form-control" required="true" value="${prof?.department?.id}"/>
                        </div>
                    </div>
                    <div class="form-group form-group-material-light-blue">
                        <label for="prof_active" class="control-label col-md-2">Active: </label>

                        <div class="col-md-10">
                            <div class="checkbox checkbox-material-light-blue no-space">
                                <label>
                                    <g:checkBox name="prof_active" checked="${prof?.active != null ? prof?.active:true}"/>
                                </label>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-5 col-md-offset-8">
                            <g:actionSubmit id="btnUpdate" value="Update" action='editProfessor' class="btn  btn-material-light-blue" disabled="true"/>
                            <input type="reset" id="btnCancel" value="Cancel" onclick="onSelectProfessor()" class="btn btn-default"/>
                        </div>
                    </div>
                </g:form>

            </div>
        </div>
    </div>
</div>
</body>
</html>