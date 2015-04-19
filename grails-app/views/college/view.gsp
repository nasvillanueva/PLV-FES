<%--
  Created by IntelliJ IDEA.
  User: NazIsEvil
  Date: 12/25/2014
  Time: 7:39 PM
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main"/>
    <title>College | PLV-FES</title>
    <script>
        var viewCollege = '${createLink(action:'viewCollege')}';
        function onSelectCollege() {
            if($(this).hasClass('selected')){
                $.post(viewCollege,{id:this.id},function(data){
                    if(data.id){
                        $('#college_id').val(data.id);
                        $('#college_name').val(data.name);
                        $('#college_active').prop('checked',data.active);

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
            initDataTable('college_grid', {},
                    [
                        {data: 'name',width:'80%',className:'dt-head-center dt-body-left'},
                        {data: 'active',width:'20%',className:'dt-center'}
                    ], '${createLink(action:'viewCollegeList')}',onSelectCollege,'college_id');

        }
        function init() {
            setupGrids();

            if($('#college_id').val() != ''){
                $('#btnAdd').attr('disabled',true);
                $('#btnUpdate').attr('disabled',false);
            }
        }
    </script>
</head>

<body>
<div class="panel panel-material-light-blue">
    <div class="panel-heading">
        <h3 class="panel-title">Colleges</h3>
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
                    <table id="college_grid" class="table table-striped table-bordered table-hover">
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
                    <g:hiddenField name="college_id"/>
                    <div class="form-group form-group-material-light-blue">
                        <label for="college_name" class="control-label col-md-2">Name:</label>

                        <div class="col-md-10">
                            <g:field name="college_name" type="text" class="form-control" placeholder="Name" value="${college?.collegeName}" required="true"/>
                        </div>
                    </div>
                    <div class="form-group form-group-material-light-blue">
                        <label for="college_active" class="control-label col-md-2">Active: </label>

                        <div class="col-md-10">
                            <div class="checkbox checkbox-material-light-blue no-space">
                                <label>
                                    <g:checkBox name="college_active" checked="${college?.active != null ? college?.active:true}"/>
                                </label>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-4 col-md-offset-8">
                            <g:actionSubmit id="btnAdd" value="Add" action='addCollege' class="btn btn-material-light-blue"/>
                            <g:actionSubmit id="btnUpdate" value="Update" action='editCollege' class="btn  btn-material-light-blue" disabled="true"/>
                        </div>
                    </div>
                </g:form>

            </div>
        </div>
    </div>
</div>
</body>
</html>