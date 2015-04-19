<%--
  Created by IntelliJ IDEA.
  User: NazIsEvil
  Date: 12/25/2014
  Time: 9:08 PM
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main"/>
    <title>Department | PLV-FES</title>
    <script>
        var viewDepartment = '${createLink(action:'viewDepartment')}';
        function onSelectDepartment() {
            if($(this).hasClass('selected')){
                $.post(viewDepartment,{id:this.id},function(data){
                    if(data.id){
                        $('#dept_id').val(data.id);
                        $('#dept_name').val(data.name);
                        $('#dept_college').val(data.college);
                        $('#dept_active').prop('checked',data.active);

                        $('#btnAdd').attr('disabled',true);
                        $('#btnUpdate').attr('disabled',false);
                    }
                });
            }else{
                $('form').trigger('reset');
                $('#btnAdd').attr('disabled',false);
                $('#btnUpdate').attr('disabled',true);
            }
        }
        function setupGrids() {
            initDataTable('department_grid', {},
                    [
                        {data: 'name',width:'80%',className:'dt-head-center dt-body-left'},
                        {data: 'active',width:'20%',className:'dt-center'}
                    ], '${createLink(action:'viewDepartmentList')}',onSelectDepartment,'dept_id');

        }
        function init() {
            setupGrids();

            if($('#dept_id').val() != ''){
                $('#btnAdd').attr('disabled',true);
                $('#btnUpdate').attr('disabled',false);
            }
        }
    </script>
</head>

<body>
<div class="panel panel-material-light-blue">
    <div class="panel-heading">
        <h3 class="panel-title">Departments</h3>
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
                    <table id="department_grid" class="table table-striped table-bordered table-hover">
                        <thead>
                        <tr>
                            <th>Name</th>
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
                    <g:hiddenField name="dept_id"/>
                    <div class="form-group form-group-material-light-blue">
                        <label for="dept_name" class="control-label col-md-2">Name:</label>

                        <div class="col-md-10">
                            <g:field name="dept_name" type="text" class="form-control" placeholder="Name" value="${department?.departmentName}" required="true"/>
                        </div>
                    </div>
                    <div class="form-group form-group-material-light-blue">
                        <label for="dept_active" class="control-label col-md-2">Active: </label>

                        <div class="col-md-10">
                            <div class="checkbox checkbox-material-light-blue no-space">
                                <label>
                                    <g:checkBox name="dept_active" checked="${department?.active != null ? department?.active:true}"/>
                                </label>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-4 col-md-offset-8">
                            <g:actionSubmit id="btnAdd" value="Add" action='addDepartment' class="btn btn-material-light-blue"/>
                            <g:actionSubmit id="btnUpdate" value="Update" action='editDepartment' class="btn btn-material-light-blue" disabled="true"/>
                        </div>
                    </div>
                </g:form>

            </div>
        </div>
    </div>
</div>
</body>
</html>