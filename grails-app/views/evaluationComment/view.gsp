<%--
  Created by IntelliJ IDEA.
  User: Nas Villanueva
  Date: 8/19/2014
  Time: 5:12 PM
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main"/>
    <title>Evaluation Comments | PLV-FES</title>
    <script type="text/javascript">

        var viewAllComments = '${createLink(action:'viewAllComments')}';
        var viewOverallScore = '${createLink(action:'viewOverallScore')}';
        var viewTallyCounter = '${createLink(action:'viewTallyCounter')}';
        function onSelectProf(){
            $('#availableComments').find('option').remove().end();
            $('#selectedComments').find('option').remove().end();
            $('#prof_id').val('');
            if($(this).hasClass('selected')){
                $.post(viewAllComments,{id:this.id},function(data){
                    $.each(data,function(){
                        $('#availableComments').append($('<option></option>').val(this[0]).html(this[1]));
                    });
                });
                $.post(viewAllComments,{id:this.id,selected:true},function(data){
                    $.each(data,function(){
                        $('#selectedComments').append($('<option></option>').val(this[0]).html(this[1]));
                    });
                });

                $.post(viewOverallScore,{id:this.id},function(data){
                    $('#profScore').text(data.score);
                });

                $.post(viewTallyCounter,{id:this.id},function(data){
                    $('#tallyCounter').text(data.count);
                });

                $('#profName').text($(this).children('td').eq(0).html());
                $('#prof_id').val(this.id);
                $('#btnSave').attr('disabled',false);
                $('#btnCancel').attr('disabled',false);
            }else{
                $('form').trigger('reset');
                $('#profName').text('');
                $('#profScore').text('');
                $('#prof_id').val('');
                $('#btnSave').attr('disabled',true);
                $('#btnCancel').attr('disabled',true);
                $('tr.selected').removeClass('selected');
            }
        }

        function onBtnSave(){
            if($('#selectedComments').children().length > 5) {
                if(!confirm("Note: The recommended number of comments that will be displayed is 5. Are you sure you want to continue?")){
                    return false;
                }
            }
            var comments = '';
            $.each($('#selectedComments').children(),function(){
                if(comments){
                    comments = this.value + ',' + comments;
                }else{
                    comments = this.value;
                }
            });
            $('#selectedCommentsId').val(comments);
            return true;
        }

        function onBtnAdd(){
            var availableComments = $('#availableComments');
            var selectedComments = $('#selectedComments');
            if(availableComments.val()){
                $.each(availableComments.val(),function(){
                    var comment = $('#availableComments option[value="' + this + '"]');
                    selectedComments.append($('<option>', {
                        value: this,
                        text: comment.text()
                    }));
                    comment.remove();
                });

            }else{
                alert("No Comment(s) Selected!");
            }
            return false;
        }

        function onBtnRemove(){
            var availableComments = $('#availableComments');
            var selectedComments = $('#selectedComments');
            if(selectedComments.val()){
                $.each(selectedComments.val(),function(){
                    var comment = $('#selectedComments option[value="' + this + '"]');
                    availableComments.append($('<option>', {
                        value: this,
                        text: comment.text()
                    }));
                    comment.remove();
                });

            }else{
                alert("No Comment(s) Selected!");
            }
            return false;
        }

        function onCommentPreview(){
            $('#commentPreview').val($('option[value="' + this.value + '"]').text());
        }

        function setupGrid() {
            initDataTable('prof_grid',
                    {searching:true},
                    [
                        {data: 'name',width:'30%',className:'dt-head-center dt-body-left'},
                        {data: 'college',width:'40%',className:'dt-head-center dt-body-left'},
                        {data: 'department',width:'20%',className:'dt-head-center dt-body-left'}
                    ], '${createLink(action:'viewEvaluatedProfessorList')}',onSelectProf,'prof_id');
        }
        function setupForm(){
            $('#btnAdd').on('click',onBtnAdd);
            $('#btnRemove').on('click',onBtnRemove);
            $('#availableComments,#selectedComments').on('change',onCommentPreview);
            $('#btnSave').attr('disabled',true);
            $('#btnCancel').attr('disabled',true);
        }
        function init() {
            setupGrid();
            setupForm();
        }
    </script>
    <style type="text/css">
        #selectedComments, #availableComments{
            height:250px;
        }
    </style>
</head>

<body>
<div class="panel panel-material-light-blue">
    <div class="panel-heading">
        <h3 class="panel-title">Evaluation Comments</h3>
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
                            <th>Professor Name</th>
                            <th>College</th>
                            <th>Department</th>
                        </tr>
                        </thead>
                    </table>
                </div>
            </div>
        </div>

        <div class="panel">
            <div class="panel-body">
                <g:form name="listForm" useToken="true" role="form" class="form">
                    <div class="form-group form-group-material-light-blue">
                        <h3><label class="control-label">Professor: <span id="profName"></span></label><br/><label class="control-label">Overall: <span id="profScore"></span></label><br/><label class="control-label">Tally: <span id="tallyCounter"></span></label></h3>
                        <g:hiddenField name="prof_id"/>
                    </div>

                    <div class="col-md-8 col-md-offset-2">
                        <div class="form-group form-group-material-light-blue">
                            <label for="commentPreview" class="control-label">Comment Preview:</label>
                            <g:textArea name="commentPreview" class="form-control" rows="3" readonly="readonly"/>
                        </div>
                    </div>
                    <div class="form-group form-group-material-light-blue">
                        <div class="col-md-6">
                            <label for="availableComments" class="control-label">Available Comment(s):</label>
                            <g:select name="availableComments" from="${null}" multiple="true" class="form-control" />
                        </div>
                    </div>
                    <div class="form-group form-group-material-light-blue">
                        <div class="col-md-6 ">
                            <label for="selectedComments" class="control-label">Selected Comments(s):</label>
                            <g:select name="selectedComments" from="${null}" multiple="true" class="form-control"/>
                            <g:hiddenField name="selectedCommentsId"/>
                        </div>
                    </div>
                    <div class="col-md-6">
                            <button id="btnAdd" class="btn btn-material-light-blue btn-block">Add</button>
                    </div>
                    <div class="col-md-6">
                            <button id="btnRemove" class="btn btn-primary btn-material-light-blue btn-block" >Remove</button>
                    </div>
                    <div class="row">
                        <div class="col-md-4 col-md-offset-8">
                            <g:actionSubmit id="btnSave" value="Save" action='addSaveComment' onclick="return onBtnSave()" class="btn  btn-material-light-blue"/>
                            <input type="reset" id="btnCancel" value="Cancel" onclick="onSelectProf()" class="btn  btn-default"/>
                        </div>
                    </div>
                </g:form>
            </div>
        </div>
    </div>
</div>
</body>
</html>