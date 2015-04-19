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
    <title>List Maintenance - For Supervisor | PLV-FES</title>
    <script>
        var viewAvailableSupervisor = '${createLink(controller: 'supervisorListMaintenance',action:'viewAvailableSupervisorList')}';
        var viewSelectedSupervisor = "${createLink(controller: 'supervisorListMaintenance', action: 'viewSelectedSupervisorList')}";

        function onBtnSave(){
            var supervisor = '';
            $.each($('#selectedSupervisor').children(),function(){
                if(supervisor){
                    supervisor = this.value + ',' + supervisor;
                }else{
                    supervisor = this.value;
                }
            });
            $('#selectedSupervisorId').val(supervisor);
        }

        function onBtnAdd(){
            var availableSupervisor = $('#availableSupervisor');
            var selectedSupervisor = $('#selectedSupervisor');
            if(availableSupervisor.val()){
                $.each(availableSupervisor.val(),function(){
                    var supervisor = $('#availableSupervisor option[value="' + this + '"]');
                    selectedSupervisor.append($('<option>', {
                        value: this,
                        text: supervisor.text()
                    }));
                    supervisor.remove();
                });

            }else{
                alert("No professor(s) Selected!");
            }
            return false;
        }
        function onBtnAddAll(){
            var availableSupervisor = $('#availableSupervisor');
            var selectedSupervisor = $('#selectedSupervisor');
            if(availableSupervisor.children().length > 0){
                $.each(availableSupervisor.children(),function(){
                    var supervisor =  $('#availableSupervisor option[value="' + $(this).val() + '"]');
                    selectedSupervisor.append($('<option>', {
                        value: $(this).val(),
                        text: supervisor.text()
                    }));
                    supervisor.remove();
                });

            }else{
                alert("There are no available professor(s)!");
            }
            return false;
        }

        function onBtnRemove(){
            var availableSupervisor = $('#availableSupervisor');
            var selectedSupervisor = $('#selectedSupervisor');
            if(selectedSupervisor.val()){
                $.each(selectedSupervisor.val(),function(){
                    var supervisor =  $('#selectedSupervisor option[value="' + this + '"]');
                    availableSupervisor.append($('<option>', {
                        value: this,
                        text: supervisor.text()
                    }));
                    supervisor.remove();
                });

            }else{
                alert("No professor(s) Selected!");
            }
            return false;
        }
        function onBtnRemoveAll(){
            var availableSupervisor = $('#availableSupervisor');
            var selectedSupervisor = $('#selectedSupervisor');
            if(selectedSupervisor.children().length > 0){
                $.each(selectedSupervisor.children(),function(){
                    var supervisor =  $('#selectedSupervisor option[value="' + $(this).val() + '"]');
                    availableSupervisor.append($('<option>', {
                        value: $(this).val(),
                        text: supervisor.text()
                    }));
                    supervisor.remove();
                });
                $('#selectedSupervisorId').val('');
            }else{
                alert("There are no selected professor(s)!");
            }
            return false;
        }

        function onSelectSupervisor(){
            $('#availableSupervisor').find('option').remove().end();
            $('#selectedSupervisor').find('option').remove().end();
            $('#id').val('');
            if($(this).hasClass('selected')){
                $.post(viewAvailableSupervisor,{id:this.id},function(data){
                    $.each(data,function(){
                        $('#availableSupervisor').append($('<option></option>').val(this.id).html(this.name));
                    });
                });
                $.post(viewSelectedSupervisor,{id:this.id},function(data){
                    $.each(data,function(){
                        $('#selectedSupervisor').append($('<option></option>').val(this.id).html(this.name));
                    });
                });
                $('#supervisorName').text($(this).children('td').eq(0).html());
                $('#id').val(this.id);
                $('#btnSave').attr('disabled',false);
                $('#btnCancel').attr('disabled',false);
            }else{
                $('form').trigger('reset');
                $('#supervisorName').text('');
                $('#id').val('');
                $('#btnSave').attr('disabled',true);
                $('#btnCancel').attr('disabled',true);
                $('tr.selected').removeClass('selected');
            }
        }
        function setupGrid() {
            initDataTable('supervisor_grid',
                    {searching:true},
                    [
                        {data: 'name',width:'100%',className:'dt-head-center dt-body-left'}
                    ], '${createLink(action:'viewSupervisorList')}',onSelectSupervisor,'id');
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
    #selectedSupervisor, #availableSupervisor{
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
        <h3 class="panel-title">List Maintenance - For Supervisor</h3>
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
                    <table id="supervisor_grid" class="table table-striped table-bordered table-hover">
                        <thead>
                        <tr>
                            <th>Supervisor Name</th>
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
                        <h3><label class="control-label">Supervisor: <span id="supervisorName"></span></label></h3>
                        <g:hiddenField name="id"/>
                    </div>
                    <div class="form-group form-group-material-light-blue">
                        <div class="col-md-6">
                            <label for="availableSupervisor" class="control-label">Available Professor(s):</label>
                            <g:select name="availableSupervisor" from="${null}" multiple="true" class="form-control" />
                        </div>
                    </div>
                    <div class="form-group form-group-material-light-blue">
                        <div class="col-md-6">
                            <label for="selectedSupervisor" class="control-label">Selected Professor(s):</label>
                            <g:select name="selectedSupervisor" from="${null}" multiple="true" class="form-control"/>
                            <g:hiddenField name="selectedSupervisorId"/>
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
                            <g:actionSubmit id="btnSave" value="Save" action='addSupervisorEvaluationList' onclick="onBtnSave()" class="btn btn-material-light-blue"/>
                            <input type="reset" id="btnCancel" value="Cancel" onclick="onSelectSupervisor()" class="btn btn-default"/>
                        </div>
                    </div>
                </g:form>
            </div>
        </div>
    </div>
</div>
</body>
</html>