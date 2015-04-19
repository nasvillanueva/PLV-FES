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
    <title>List Maintenance - For Peer | PLV-FES</title>
    <script>
        var viewAvailablePeer = '${createLink(controller: 'peerListMaintenance',action:'viewAvailablePeerList')}';
        var viewSelectedPeer = "${createLink(controller: 'peerListMaintenance', action: 'viewSelectedPeerList')}";

        function onBtnSave(){
            var peer = '';
            $.each($('#selectedPeer').children(),function(){
                if(peer){
                    peer = this.value + ',' + peer;
                }else{
                    peer = this.value;
                }
            });
            $('#selectedPeerId').val(peer);
        }

        function onBtnAdd(){
            var availablePeer = $('#availablePeer');
            var selectedPeer = $('#selectedPeer');
            if(availablePeer.val()){
                $.each(availablePeer.val(),function(){
                    var peer = $('#availablePeer option[value="' + this + '"]');
                    selectedPeer.append($('<option>', {
                        value: this,
                        text: peer.text()
                    }));
                    peer.remove();
                });

            }else{
                alert("No peer(s) Selected!");
            }
            return false;
        }
        function onBtnAddAll(){
            var availablePeer = $('#availablePeer');
            var selectedPeer = $('#selectedPeer');
            if(availablePeer.children().length > 0){
                $.each(availablePeer.children(),function(){
                    var peer =  $('#availablePeer option[value="' + $(this).val() + '"]');
                    selectedPeer.append($('<option>', {
                        value: $(this).val(),
                        text: peer.text()
                    }));
                    peer.remove();
                });

            }else{
                alert("There are no available peer(s)!");
            }
            return false;
        }

        function onBtnRemove(){
            var availablePeer = $('#availablePeer');
            var selectedPeer = $('#selectedPeer');
            if(selectedPeer.val()){
                $.each(selectedPeer.val(),function(){
                    var peer =  $('#selectedPeer option[value="' + this + '"]');
                    availablePeer.append($('<option>', {
                        value: this,
                        text: peer.text()
                    }));
                    peer.remove();
                });

            }else{
                alert("No Peer(s) Selected!");
            }
            return false;
        }
        function onBtnRemoveAll(){
            var availablePeer = $('#availablePeer');
            var selectedPeer = $('#selectedPeer');
            if(selectedPeer.children().length > 0){
                $.each(selectedPeer.children(),function(){
                    var peer =  $('#selectedPeer option[value="' + $(this).val() + '"]');
                    availablePeer.append($('<option>', {
                        value: $(this).val(),
                        text: peer.text()
                    }));
                    peer.remove();
                });
                $('#selectedPeerId').val('');
            }else{
                alert("There are no selected peer(s)!");
            }
            return false;
        }

        function onSelectChairperson(){
            $('#availablePeer').find('option').remove().end();
            $('#selectedPeer').find('option').remove().end();
            $('#id').val('');
            if($(this).hasClass('selected')){
                $.post(viewAvailablePeer,{id:this.id},function(data){
                    $.each(data,function(){
                        $('#availablePeer').append($('<option></option>').val(this.id).html(this.name));
                    });
                });
                $.post(viewSelectedPeer,{id:this.id},function(data){
                    $.each(data,function(){
                        $('#selectedPeer').append($('<option></option>').val(this.id).html(this.name));
                    });
                });
                $('#chairpersonName').text($(this).children('td').eq(0).html());
                $('#id').val(this.id);
                $('#btnSave').attr('disabled',false);
                $('#btnCancel').attr('disabled',false);
            }else{
                $('form').trigger('reset');
                $('#chairpersonName').text('');
                $('#id').val('');
                $('#btnSave').attr('disabled',true);
                $('#btnCancel').attr('disabled',true);
                $('tr.selected').removeClass('selected');
            }
        }
        function setupGrid() {
            initDataTable('chairperson_grid',
                    {searching:true},
                    [
                        {data: 'name',width:'55%',className:'dt-head-center dt-body-left'},
                        {data: 'department',width:'45%',className:'dt-head-center dt-body-left'}
                    ], '${createLink(action:'viewChairpersonList')}',onSelectChairperson,'id');
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
        #selectedPeer, #availablePeer{
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
        <h3 class="panel-title">List Maintenance - For Peer</h3>
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
                    <table id="chairperson_grid" class="table table-striped table-bordered table-hover">
                        <thead>
                        <tr>
                            <th>Chairperson Name</th>
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
                        <h3><label class="control-label">Chairperson: <span id="chairpersonName"></span></label></h3>
                        <g:hiddenField name="id"/>
                    </div>
                    <div class="form-group form-group-material-light-blue">
                        <div class="col-md-6">
                            <label for="availablePeer" class="control-label">Available Peer(s):</label>
                            <g:select name="availablePeer" from="${null}" multiple="true" class="form-control" />
                        </div>
                    </div>
                    <div class="form-group form-group-material-light-blue">
                        <div class="col-md-6">
                            <label for="selectedPeer" class="control-label">Selected Peer(s):</label>
                            <g:select name="selectedPeer" from="${null}" multiple="true" class="form-control"/>
                            <g:hiddenField name="selectedPeerId"/>
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
                            <g:actionSubmit id="btnSave" value="Save" action='addPeerEvaluationList' onclick="onBtnSave()" class="btn btn-material-light-blue"/>
                            <input type="reset" id="btnCancel" value="Cancel" onclick="onSelectChairperson()" class="btn btn-default"/>
                        </div>
                    </div>
                </g:form>
            </div>
        </div>
    </div>
</div>
</body>
</html>