<%--
  Created by IntelliJ IDEA.
  User: Nas
  Date: 7/10/2014
  Time: 7:42 PM
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main"/>
    <title>Evaluation Questions | PLV-FES</title>
    <script>
        var viewQuestion = '${createLink(action:'viewEvaluationQuestion')}';
        function onSelectQuestion() {
            if($(this).hasClass('selected')){
                $.post(viewQuestion,{id:this.id},function(data){
                    if(data.id){
                        $('#q_id').val(data.id);
                        $('#category').val(data.category);
                        $('#question').val(data.question);
                        $('#q_active').prop('checked',data.active);

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
            initDataTable('question_grid', {},
                    [
                        {data: 'category',width:'35%',className:'dt-head-center dt-body-left'},
                        {data: 'question',width:'55%',className:'dt-head-center dt-body-left'},
                        {data: 'active',width:'10%',className:'dt-center'}
                    ], '${createLink(action:'viewEvaluationQuestionList')}',onSelectQuestion,'q_id');

        }
        function init() {
            setupGrids();

            if($('#q_id').val() != ''){
                $('#btnAdd').attr('disabled',true);
                $('#btnUpdate').attr('disabled',false);
            }
        }
    </script>
</head>
<body>
<div class="panel panel-material-light-blue">
    <div class="panel-heading">
        <h3 class="panel-title">Evaluation Questions</h3>
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
                    <table id="question_grid" class="table table-striped table-bordered table-hover">
                        <thead>
                        <tr>
                            <th>Category</th>
                            <th>Question</th>
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
                    <g:hiddenField name="q_id"/>
                    <div class="form-group form-group-material-light-blue">
                        <label for="category" class="control-label col-md-2">Category:</label>

                        <div class="col-md-10">
                            <fesSelect:category name="category" class="form-control" value="${evalQ?.evaluationCategory?.id}" required="required"/>
                        </div>
                    </div>
                    <div class="form-group form-group-material-light-blue">
                        <label for="question" class="control-label col-md-2">Question:</label>

                        <div class="col-md-10">
                            <g:textArea name="question" rows="3" class="form-control"  placeholder="Question" value="${evalQ?.question}" required="required"/>
                        </div>
                    </div>
                    <div class="form-group form-group-material-light-blue">
                        <label for="q_active" class="control-label col-md-2">Active: </label>

                        <div class="col-md-10">
                            <div class="checkbox checkbox-material-light-blue no-space">
                                <label>
                                    <g:checkBox name="q_active" checked="${evalQ?.active != null ? evalQ?.active:true}"/>
                                </label>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-4 col-md-offset-8">
                            <g:actionSubmit id="btnAdd" value="Add" action='addEvaluationQuestion' class="btn btn-primary btn-material-light-blue"/>
                            <g:actionSubmit id="btnUpdate" value="Update" action='editEvaluationQuestion' class="btn btn-primary btn-material-light-blue" disabled="true"/>
                        </div>
                    </div>
                </g:form>

            </div>
        </div>
    </div>
</div>
</body>
</html>