/**
 * Created by NazIsEvil on 12/2/2014.
 */
function initDataTable(table_id, params, columns, dataUrl, onSelectRow, idHolder) {
    var dtParams = {
        dom:'<"table-responsive"lfrt>ip',
        scrollX:true,
        scrollCollapse:false,
        autoWidth:false,
        stateSave: true,
        processing: true,
        searching: false,
        ordering: false,
        lengthChange: false,
        columns: columns,
        serverSide: true,
        ajax: {
            url: dataUrl,
            type: 'POST'
        },
        rowCallback:
            function( row, data ){
                if(data.DT_RowId == $('#' + idHolder).val() ) {
                    $(row).addClass('selected');
                }
        },
        drawCallback:
            function(settings){
                if(settings._iRecordsDisplay > 0){
                    var appendString = "<tr role='row' id='dummy'>";
                    $.each(columns,function(){
                        appendString += "<td>&nbsp;</td>";
                    });
                    appendString += "</tr>";
                    var length = typeof(settings.oInit.pageLength) == 'undefined' ? 10 : settings.oInit.pageLength;
                    for(var i = settings.aoData.length;i < length;i++){
                        $(this.selector +' tbody').append(appendString);
                    }
                }
                $(this.selector +' tbody tr[id="dummy"]').prop('disabled',true);
            }
    };
    $.extend(dtParams,params);
    var table = $('#'+table_id).DataTable(dtParams);

    $('#'+table_id+' tbody').on( 'click', 'tr', function () {
        if(this.id != ''){
            if ( $(this).hasClass('selected') ) {
                $(this).removeClass('selected');
            }
            else {
                if(idHolder != 'multiple'){
                    table.$('tr.selected').removeClass('selected');
                }
                $(this).addClass('selected');
            }
        }
    } );
    $('#'+table_id+' tbody').on( 'click', 'tr', onSelectRow);
}