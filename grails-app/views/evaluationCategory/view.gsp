<%--
  Created by IntelliJ IDEA.
  User: Nas
  Date: 7/10/2014
  Time: 7:42 PM
--%>

<%@ page import="edu.plv.fes.constants.FESConstants" contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main"/>
    <title>Evaluation Categories | PLV-FES</title>
    <script>
        var viewCategory = '${createLink(action:'viewEvaluationCategory')}';
        function onSelectCategory() {
            if($(this).hasClass('selected')){
                $.post(viewCategory,{id:this.id},function(data){
                    if(data.id){
                        $('#cat_id').val(data.id);
                        $('#cat_desc').val(data.description);
                        $('#cat_index').val(data.catIndex);
                        $('#cat_percent').val(data.percentage);
                        $('#cat_stud').prop('checked',data.student);
                        $('#cat_chair').prop('checked',data.chair);
                        $('#cat_sv').prop('checked',data.super);
                        $('#cat_active').prop('checked',data.active);

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
            initDataTable('category_grid', {},
                    [
                        {data: 'description',width:'35%',className:'dt-head-center dt-body-left'},
                        {data: 'percentage',width:'10%',className:'dt-head-center dt-body-left'},
                        {data: 'index',width:'17.2%',className:'dt-center'},
                        {data: 'evaluator',width:'24.4%',className:'dt-center'},
                        {data: 'active',width:'12.2%',className:'dt-center'}
                    ], '${createLink(action:'viewEvaluationCategoryList')}',onSelectCategory,'cat_id');

        }
        function init() {
            setupGrids();

            if($('#cat_id').val() != ''){
                $('#btnAdd').attr('disabled',true);
                $('#btnUpdate').attr('disabled',false);
            }
        }
    </script>
</head>

<body>
<div class="panel panel-material-light-blue">
    <div class="panel-heading">
        <h3 class="panel-title">Evaluation Categories</h3>
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
                    <table id="category_grid" class="table table-striped table-bordered table-hover">
                        <thead>
                        <tr>
                            <th>Description</th>
                            <th>Percentage</th>
                            <th>Index</th>
                            <th>Evaluator</th>
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
                    <g:hiddenField name="cat_id"/>
                    <div class="form-group form-group-material-light-blue">
                        <label for="cat_desc" class="control-label col-md-2">Description:</label>

                        <div class="col-md-10">
                            <g:field name="cat_desc" type="text" class="form-control" placeholder="Description" value="${evalCat?.description}" required="true"/>
                        </div>
                    </div>
                    <div class="form-group form-group-material-light-blue">
                        <label for="cat_percent" class="control-label col-md-2">Percentage:</label>

                        <div class="col-md-10">
                            <g:field name="cat_percent" type="number" class="form-control" placeholder="Percentage" value="${evalCat?.percentage}" required="true" min="0" max="100"/>
                        </div>
                    </div>
                    <div class="form-group form-group-material-light-blue">
                        <label for="cat_index" class="control-label col-md-2">Index:</label>

                        <div class="col-md-10">
                            <g:field name="cat_index" type="text" class="form-control" placeholder="Index" value="${evalCat?.catIndex}" required="true"/>
                        </div>
                    </div>
                    <div class="form-group form-group-material-light-blue">
                        <label for="cat_stud" class="control-label col-md-2">Student: </label>

                        <div class="col-md-2">
                            <div class="checkbox checkbox-material-light-blue no-space">
                                <label>
                                    <g:checkBox name="cat_stud" checked="${evalCat?.evaluator?.contains(FESConstants.USER_TYPE_STUDENT)?:false}"/>
                                </label>
                            </div>
                        </div>
                        <label for="cat_chair" class="control-label col-md-2">Chairperson: </label>

                        <div class="col-md-2">
                            <div class="checkbox checkbox-material-light-blue no-space">
                                <label>
                                    <g:checkBox name="cat_chair" checked="${evalCat?.evaluator?.contains(FESConstants.USER_TYPE_CHAIR)?:false}"/>
                                </label>
                            </div>
                        </div>
                        <label for="cat_sv" class="control-label col-md-2">Supervisor: </label>

                        <div class="col-md-2">
                            <div class="checkbox checkbox-material-light-blue no-space">
                                <label>
                                    <g:checkBox name="cat_sv" checked="${evalCat?.evaluator?.contains(FESConstants.USER_TYPE_SUPER)?:false}"/>
                                </label>
                            </div>
                        </div>
                    </div>
                    <div class="form-group form-group-material-light-blue">
                        <label for="cat_active" class="control-label col-md-2">Active: </label>

                        <div class="col-md-10">
                            <div class="checkbox checkbox-material-light-blue no-space">
                                <label>
                                    <g:checkBox name="cat_active" checked="${evalCat?.active != null ? evalCat?.active:true}"/>
                                </label>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-4 col-md-offset-8">
                            <g:actionSubmit id="btnAdd" value="Add" action='addEvaluationCategory' class="btn btn-material-light-blue"/>
                            <g:actionSubmit id="btnUpdate" value="Update" action='editEvaluationCategory' class="btn btn-material-light-blue" disabled="true"/>
                        </div>
                    </div>
                </g:form>

            </div>
        </div>
    </div>
</div>
</body>
</html>