<%--
  Created by IntelliJ IDEA.
  User: NazIsEvil
  Date: 12/25/2014
  Time: 7:39 PM
--%>

<%@ page import="org.apache.shiro.SecurityUtils; edu.plv.fes.constants.FESConstants" contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main"/>
    <title>Users | PLV-FES</title>
    <script>
        var viewUser = '${createLink(action:'viewUser')}';
        function onSelectUser() {
            if($(this).hasClass('selected')){
                $.post(viewUser,{id:this.id},function(data){
                    $('form').trigger('reset');
                    if(data.id){
                        $('#user_id').val(data.id);
                        $('#user_username').val(data.username);
                        $('#user_type').val(data.usertype);
                        $('#user_firstname').val(data.firstname);
                        $('#user_surname').val(data.surname);
                        $('#user_active').prop('checked',data.active);
                        if(data.usertype == '${FESConstants.USER_TYPE_CHAIR}'){
                            $('#user_department').prop('disabled',false);
                            $('#user_role').prop('disabled',true);
                            $('#user_department').val(data.department);
                        }else if(data.usertype == '${FESConstants.USER_TYPE_ADMIN}'){
                            $('#user_department').prop('disabled',true);
                            $('#user_role').prop('disabled',false);
                            $('#user_role').val(data.role);
                        }
                        else if(data.usertype == '${FESConstants.USER_TYPE_SUPER}'){
                            $('#user_department').prop('disabled',true);
                            $('#user_role').prop('disabled',true);
                        }

                        $('#btnAdd').attr('disabled',true);
                        $('#btnUpdate').attr('disabled',false);
                        $('#user_password, #user_confirm').prop('required',false);
                    }
                });
            }else{
                $('#user_password, #user_confirm').prop('required',true);
                $('form').trigger('reset');
                $('#btnAdd').attr('disabled',false);
                $('#btnUpdate').attr('disabled',true);
            }
        }
        function setupGrids() {
            initDataTable('user_grid', {},
                    [
                        {data: 'username',width:'15%',className:'dt-head-center dt-body-left'},
                        {data: 'name',width:'20%',className:'dt-head-center dt-body-left'},
                        {data: 'usertype',width:'15%',className:'dt-head-center dt-body-left'},
                        {data: 'role',width:'15%',className:'dt-head-center dt-body-left'},
                        {data: 'department',width:'30%',className:'dt-head-center dt-body-left'},
                        {data: 'active',width:'5%',className:'dt-center'}
                    ], '${createLink(action:'viewUserList')}',onSelectUser,'user_id');

        }
        function onTypeChange(){
            $('#user_department').prop('disabled',this.value != '${FESConstants.USER_TYPE_CHAIR}');
            $('#user_department').val('');
            $('#user_role').prop('disabled',this.value != '${FESConstants.USER_TYPE_ADMIN}');
            $('#user_role').val('');
        }
        function onPasswordInput(){
            if(this.value != '' || $('#user_id').val() != ''){
                $('#user_password, #user_confirm').prop('required',true);
            }else{
                $('#user_password, #user_confirm').prop('required',false);
            }
        }
        function setupForm(){
            $('#user_type').on('change',onTypeChange);
            $('#user_password').on('change',onPasswordInput);
            $('#user_department').prop('disabled',true);
            $('#user_role').prop('disabled',true);
        }
        function init() {
            setupGrids();
            setupForm();

            if($('#user_id').val() != ''){
                $('#btnAdd').attr('disabled',true);
                $('#btnUpdate').attr('disabled',false);
            }

        }
    </script>
</head>

<body>
<div class="panel panel-material-light-blue">
    <div class="panel-heading">
        <h3 class="panel-title">Users</h3>
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
                    <table id="user_grid" class="table table-striped table-bordered table-hover">
                        <thead>
                        <tr>
                            <th>Username</th>
                            <th>Name</th>
                            <th>Type</th>
                            <th>Role</th>
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
                    <g:hiddenField name="user_id"/>
                    <div class="form-group form-group-material-light-blue">
                        <label for="user_username" class="control-label col-md-2">Username:</label>

                        <div class="col-md-10">
                            <g:field name="user_username" type="text" class="form-control" placeholder="Username" required="true"/>
                        </div>
                    </div>
                    <div class="form-group form-group-material-light-blue">
                        <label for="user_password" class="control-label col-md-2">Password:</label>

                        <div class="col-md-10">
                            <g:field name="user_password" type="password" class="form-control" placeholder="Password"/>
                        </div>
                    </div>
                    <div class="form-group form-group-material-light-blue">
                        <label for="user_confirm" class="control-label col-md-2">Confirm Password:</label>

                        <div class="col-md-10">
                            <g:field name="user_confirm" type="password" class="form-control" placeholder="Confirm Password"/>
                        </div>
                    </div>
                    <div class="form-group form-group-material-light-blue">
                        <label for="user_firstname" class="control-label col-md-2">First Name:</label>

                        <div class="col-md-10">
                            <g:field name="user_firstname" type="text" class="form-control" placeholder="First Name" value="${user?.firstname}" required="true"/>
                        </div>
                    </div>
                    <div class="form-group form-group-material-light-blue">
                        <label for="user_surname" class="control-label col-md-2">Surname:</label>

                        <div class="col-md-10">
                            <g:field name="user_surname" type="text" class="form-control" placeholder="Surname" value="${user?.surname}" required="true"/>
                        </div>
                    </div>
                    <div class="form-group form-group-material-light-blue">
                        <label for="user_type" class="control-label col-md-2">Type:</label>

                        <div class="col-md-10">
                            <fesSelect:usertype name="user_type" class="form-control" value="${user?.usertype}" required="true"/>
                        </div>
                    </div>
                    <div class="form-group form-group-material-light-blue">
                        <label for="user_role" class="control-label col-md-2">Role:</label>

                        <div class="col-md-10">
                            <fesSelect:roles name="user_role" class="form-control" value="${user?.roles?.id?:''}" required="true"/>
                        </div>
                    </div>
                    <div class="form-group form-group-material-light-blue">
                        <label for="user_department" class="control-label col-md-2">Department:</label>

                        <div class="col-md-10">
                            <fesSelect:department name="user_department" class="form-control" value="${user?.department?.id?:''}" required="true"/>
                        </div>
                    </div>
                    <div class="form-group form-group-material-light-blue">
                        <label for="user_active" class="control-label col-md-2">Active: </label>

                        <div class="col-md-10">
                            <div class="checkbox checkbox-material-light-blue no-space">
                                <label>
                                    <g:checkBox name="user_active" checked="${user?.active != null ? user?.active:true}"/>
                                </label>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-4 col-md-offset-8">
                            <g:actionSubmit id="btnAdd" value="Add" action='addUser' class="btn  btn-material-light-blue"/>
                            <g:actionSubmit id="btnUpdate" value="Update" action='editUser' class="btn  btn-material-light-blue" disabled="true"/>
                        </div>
                    </div>
                </g:form>

            </div>
        </div>
    </div>
</div>
</body>
</html>