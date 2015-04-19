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
    <title>Interpretation | PLV-FES</title>
    <script>
        var viewInterpretation = '${createLink(action:'viewInterpretation')}';
        function onSelectInterpretation() {
            if($(this).hasClass('selected')){
                $.post(viewInterpretation,{id:this.id},function(data){
                    if(data.id){
                        $('#interpret_id').val(data.id);
                        $('#interpret_scale').val(data.scale);
                        $('#interpret_rating').val(data.rating);
                        $('#interpret_desc').val(data.description);
                        $('#interpret_active').prop('checked',data.active);

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
            initDataTable('interpretation_grid', {},
                    [
                        {data: 'scale',width:'10%',className:'dt-center'},
                        {data: 'rating',width:'20%',className:'dt-head-center dt-body-left'},
                        {data: 'description',width:'60%',className:'dt-head-center dt-body-left'},
                        {data: 'active',width:'10%',className:'dt-center'}
                    ], '${createLink(action:'viewInterpretationList')}',onSelectInterpretation,'interpret_id');

        }
        function init() {
            setupGrids();

            if($('#interpret_id').val() != ''){
                $('#btnAdd').attr('disabled',true);
                $('#btnUpdate').attr('disabled',false);
            }
        }
    </script>
</head>

<body>
<div class="panel panel-material-light-blue">
    <div class="panel-heading">
        <h3 class="panel-title">Interpretations</h3>
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
                    <table id="interpretation_grid" class="table table-striped table-bordered table-hover">
                        <thead>
                        <tr>
                            <th>Scale</th>
                            <th>Rating</th>
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
                    <g:hiddenField name="interpret_id" />
                    <div class="form-group form-group-material-light-blue">
                        <label for="interpret_scale" class="control-label col-md-2">Scale:</label>

                        <div class="col-md-10">
                            <g:field name="interpret_scale" type="number" class="form-control" placeholder="Scale" min="0" value="${interpret?.scale}" required="true"/>
                        </div>
                    </div>
                    <div class="form-group form-group-material-light-blue">
                        <label for="interpret_rating" class="control-label col-md-2">Rating:</label>

                        <div class="col-md-10">
                            <g:field name="interpret_rating" type="text" class="form-control" placeholder="Rating" value="${interpret?.rating}" required="true"/>
                        </div>
                    </div>
                    <div class="form-group form-group-material-light-blue">
                        <label for="interpret_desc" class="control-label col-md-2">Rating:</label>

                        <div class="col-md-10">
                            <g:textArea name="interpret_desc" rows="3" class="form-control"  placeholder="Description"  value="${interpret?.description}" required="required"/>
                        </div>
                    </div>
                    <div class="form-group form-group-material-light-blue">
                        <label for="interpret_active" class="control-label col-md-2">Active: </label>

                        <div class="col-md-10">
                            <div class="checkbox checkbox-material-light-blue no-space">
                                <label>
                                    <g:checkBox name="interpret_active" checked="${interpret?.active != null ? interpret?.active:true}"/>
                                </label>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-4 col-md-offset-8">
                            <g:actionSubmit id="btnAdd" value="Add" action='addInterpretation' class="btn btn-primary btn-material-light-blue"/>
                            <g:actionSubmit id="btnUpdate" value="Update" action='editInterpretation' class="btn btn-primary btn-material-light-blue" disabled="true"/>
                        </div>
                    </div>
                </g:form>

            </div>
        </div>
    </div>
</div>
</body>
</html>