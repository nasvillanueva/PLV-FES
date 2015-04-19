<%--
  Created by IntelliJ IDEA.
  User: Nas
  Date: 7/6/2014
  Time: 4:47 PM
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main"/>
    <title>List Maintenance - For Students | PLV-FES</title>
    <script>
        var viewAvailableSection = '${createLink(controller: 'listMaintenance',action:'viewAvailableSectionList')}';
        var viewEvaluatingSection = "${createLink(controller: 'listMaintenance', action: 'viewEvaluatingSectionList')}";

        function onBtnSave(){
            var section = '';
            $.each($('#evaluatingSection').children(),function(){
                if(section){
                    section = this.value + ',' + section;
                }else{
                    section = this.value;
                }
            });
            $('#selectedSection').val(section);
        }

        function onBtnAdd(){
            var availableSection = $('#availableSection');
            var evaluatingSection = $('#evaluatingSection');
            if(availableSection.val()){
                $.each(availableSection.val(),function(){
                    evaluatingSection.append($('<option>', {
                        value: this,
                        text: this
                    }));
                    $('#availableSection option[value="' + this + '"]').remove();
                });

            }else{
                alert("No Section(s) Selected!");
            }
            return false;
        }
        function onBtnAddAll(){
            var availableSection = $('#availableSection');
            var evaluatingSection = $('#evaluatingSection');
            if(availableSection.children().length > 0){
                $.each(availableSection.children(),function(){
                    evaluatingSection.append($('<option>', {
                        value: $(this).val(),
                        text: $(this).val()
                    }));
                    $('#availableSection option[value="' + $(this).val() + '"]').remove();
                });

            }else{
                alert("There are no available section(s)!");
            }
            return false;
        }

        function onBtnRemove(){
            var availableSection = $('#availableSection');
            var evaluatingSection = $('#evaluatingSection');
            if(evaluatingSection.val()){
                $.each(evaluatingSection.val(),function(){
                    availableSection.append($('<option>', {
                        value: this,
                        text: this
                    }));
                    $('#evaluatingSection option[value="' + this + '"]').remove();
                });

            }else{
                alert("No Section(s) Selected!");
            }
            return false;
        }
        function onBtnRemoveAll(){
            var availableSection = $('#availableSection');
            var evaluatingSection = $('#evaluatingSection');
            if(evaluatingSection.children().length > 0){
                $.each(evaluatingSection.children(),function(){
                    availableSection.append($('<option>', {
                        value: $(this).val(),
                        text: $(this).val()
                    }));
                    $('#evaluatingSection option[value="' + $(this).val() + '"]').remove();
                });
                $('#selectedSection').val('');
            }else{
                alert("There are no evaluating section(s)!");
            }
            return false;
        }

        function onSelectProf(){
            $('#availableSection').find('option').remove().end();
            $('#evaluatingSection').find('option').remove().end();
            $('#id').val('');
            if($(this).hasClass('selected')){
                $.post(viewAvailableSection,{id:this.id},function(data){
                    $.each(data,function(){
                        $('#availableSection').append($('<option></option>').val(this).html(this));
                    });
                });
                $.post(viewEvaluatingSection,{id:this.id},function(data){
                    $.each(data,function(){
                        $('#evaluatingSection').append($('<option></option>').val(this).html(this));
                    });
                });
                $('#profName').text($(this).children('td').eq(0).html());
                $('#id').val(this.id);
                $('#btnSave').attr('disabled',false);
                $('#btnCancel').attr('disabled',false);
            }else{
                $('form').trigger('reset');
                $('#profName').text('');
                $('#id').val('');
                $('#btnSave').attr('disabled',true);
                $('#btnCancel').attr('disabled',true);
                $('tr.selected').removeClass('selected');
            }
        }
        function setupGrid() {
            initDataTable('prof_grid',
                    {searching:true},
                    [
                        {data: 'name',width:'40%',className:'dt-head-center dt-body-left'},
                        {data: 'college',width:'30%',className:'dt-head-center dt-body-left'},
                        {data: 'department',width:'30%',className:'dt-head-center dt-body-left'}
                    ], '${createLink(action:'viewProfessorList')}',onSelectProf,'id');
        }
        function setupForm(){
            $('#btnAdd').on('click',onBtnAdd);
            $('#btnAddAll').on('click',onBtnAddAll);
            $('#btnRemove').on('click',onBtnRemove);
            $('#btnRemoveAll').on('click',onBtnRemoveAll);
            $('#btnSave').attr('disabled',true);
            $('#btnCancel').attr('disabled',true);
        }
        function init() {
            setupGrid();
            setupForm();

        }
    </script>
    <style>
        #evaluatingSection, #availableSection{
            height:250px;
            text-align:center;
        }
        #btnAdd,#btnAddAll,#btnRemove,#btnRemoveAll{
            width:50%;
        }
    </style>
</head>

<body>
<div class="panel panel-material-light-blue">
    <div class="panel-heading">
        <h3 class="panel-title">List Maintenance - For Students</h3>
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
                        <h3><label class="control-label">Professor: <span id="profName"></span></label></h3>
                        <g:hiddenField name="id"/>
                    </div>
                    <div class="form-group form-group-material-light-blue">
                        <div class="col-md-6">
                            <label for="availableSection" class="control-label">Available Section(s):</label>
                            <g:select name="availableSection" from="${null}" multiple="true" class="form-control" />
                        </div>
                    </div>
                    <div class="form-group form-group-material-light-blue">
                        <div class="col-md-6">
                            <label for="evaluatingSection" class="control-label">Evaluating Section(s):</label>
                            <g:select name="evaluatingSection" from="${null}" multiple="true" class="form-control"/>
                            <g:hiddenField name="selectedSection"/>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="btn-group btn-group-justified">
                            <button id="btnAdd" class="btn btn-material-light-blue"  >Add</button>
                            <button id="btnAddAll" class="btn btn-material-light-blue" >Add All</button>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="btn-group btn-group-justified">
                            <button id="btnRemove" class="btn btn-material-light-blue" >Remove</button>
                            <button id="btnRemoveAll" class="btn btn-material-light-blue">Remove All</button>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-4 col-md-offset-8">
                            <g:actionSubmit id="btnSave" value="Save" action='addEvaluationList' onclick="onBtnSave()" class="btn btn-material-light-blue"/>
                            <input type="reset" id="btnCancel" value="Cancel" onclick="onSelectProf()" class="btn btn-default"/>
                        </div>
                    </div>
                </g:form>
            </div>
        </div>
    </div>
</div>
</body>
</html>