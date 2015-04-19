<%--
  Created by IntelliJ IDEA.
  User: NazIsEvil
  Date: 12/25/2014
  Time: 7:39 PM
--%>

<%@ page import="edu.plv.fes.RoleService" contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main"/>
    <title>Roles | PLV-FES</title>
    <script>
        var viewRole = '${createLink(action:'viewRole')}';
        function onSelectRole() {
            if($(this).hasClass('selected')){
                $.post(viewRole,{id:this.id},function(data){
                    $('form').trigger('reset');
                    if(data.id){
                        $('#role_id').val(data.id);
                        $('#role_name').val(data.name);
                        $('#role_description').val(data.description);
                        $('#role_active').prop('checked',data.active);
                        if(data.rights){
                            $.each(data.rights,function(){
                                $('#'+this).prop('checked',true);
                            });
                        }

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
            initDataTable('role_grid', {},
                    [
                        {data: 'name',width:'35%',className:'dt-head-center dt-body-left'},
                        {data: 'description',width:'55%',className:'dt-head-center dt-body-left'},
                        {data: 'active',width:'10%',className:'dt-center'}
                    ], '${createLink(action:'viewRoleList')}',onSelectRole,'role_id');

        }
        function onCheckAll(){
            if(this.checked){
                $('input[type="checkbox"][id*="X'+ this.id +'X"]').prop('checked',true);
            }else{
                $('input[type="checkbox"][id*="X'+ this.id +'X"]').prop('checked',false);
            }
        }
        function setupForm(){
            <g:each in="${moduleMaps}" var="m">
                $('${'#' + m.key}').on('change',onCheckAll);
            </g:each>
        }
        function init() {
            setupGrids();
            setupForm();

            if($('#role_id').val() != ''){
                $('#btnAdd').attr('disabled',true);
                $('#btnUpdate').attr('disabled',false);
            }
        }
    </script>
</head>

<body>
<div class="panel panel-material-light-blue">
    <div class="panel-heading">
        <h3 class="panel-title">Roles</h3>
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
                    <table id="role_grid" class="table table-striped table-bordered table-hover">
                        <thead>
                        <tr>
                            <th>Name</th>
                            <th>Description</th>
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
                    <g:hiddenField name="role_id" />
                    <div class="form-group form-group-material-light-blue">
                        <label for="role_name" class="control-label col-md-2">Name:</label>

                        <div class="col-md-10">
                            <g:field name="role_name" type="text" class="form-control" placeholder="Name" value="${role?.name}" required="true"/>
                        </div>
                    </div>
                    <div class="form-group form-group-material-light-blue">
                        <label for="role_description" class="control-label col-md-2">Description:</label>

                        <div class="col-md-10">
                            <g:field name="role_description" type="text" class="form-control" placeholder="Description" value="${role?.description}" required="true"/>
                        </div>
                    </div>
                    <div class="form-group form-group-material-light-blue">
                        <label for="role_active" class="control-label col-md-2">Active: </label>

                        <div class="col-md-10">
                            <div class="checkbox checkbox-material-light-blue no-space">
                                <label>
                                    <g:checkBox name="role_active" checked="${role?.active != null ? role?.active:true}"/>
                                </label>
                            </div>
                        </div>
                    </div>
                    <div class="form-group form-group-material-light-blue">
                        <label class="control-label col-md-2">Permissions:</label>
                        <div class="col-md-10">
                            <div class="well">
                                <div class="table-responsive">
                                    <table class="table table-striped table-bordered table-condensed">
                                        <tr>
                                            <th>Module Name</th>
                                            <th class="text-center">✓ All</th>
                                            <g:each in="${permPrefix}" var="p">
                                            <th class="text-center">${p.value}</th>
                                            </g:each>
                                        </tr>
                                        <g:each in="${moduleMaps}" var="m">
                                        <tr>
                                            <g:hiddenField name="moduleNameX${m.key}X" value="${m.key}"/>
                                            <td>${m.value}</td>
                                            <td class="no-space text-center">
                                                <span class="checkbox no-space">
                                                    <label>
                                                        <g:checkBox name="${m.key}" class="checkAll"/>
                                                    </label>
                                                </span>
                                            </td>
                                            <g:each in="${permPrefix}" var="p">
                                            <td class="no-space text-center">
                                                <span class="checkbox checkbox-material-light-blue no-space">
                                                    <label>
                                                        <g:checkBox name="${p.key}RightsX${m.key}X" />
                                                    </label>
                                                </span>
                                            </td>
                                            </g:each>
                                        </tr>
                                        </g:each>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-4 col-md-offset-8">
                            <g:actionSubmit id="btnAdd" value="Add" action='addRole' class="btn  btn-material-light-blue"/>
                            <g:actionSubmit id="btnUpdate" value="Update" action='editRole' class="btn  btn-material-light-blue" disabled="true"/>
                        </div>
                    </div>
                </g:form>
            </div>
        </div>
    </div>
</div>
</body>
</html>