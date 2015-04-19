<div class="panel panel-material-light-blue">
    <div class="panel-body">
        <div class="row">
            <div class="form-group col-md-6 form-group-material-light-blue">
                <label for="schoolyear" class="control-label col-md-4">School Year:</label>
                <div class="col-md-8">
                    <g:select from="${evalYear}" noSelection='["${edu.plv.fes.SystemConfiguration?.findByConfigName('schoolyear')?.configValue}":"${edu.plv.fes.SystemConfiguration?.findByConfigName('schoolyear')?.configValue}"]' name="schoolyear" class="form-control"/>
                </div>
            </div>
            <div class="form-group col-md-6 form-group-material-light-blue">
                <label for="semester" class="control-label col-md-4">Semester:</label>
                <div class="col-md-8">
                    <g:select from="${[[key:'1',value:'1st Semester'],[key:'2',value:'2nd Semester']]}" value="${edu.plv.fes.SystemConfiguration?.findByConfigName('semester')?.configValue}" optionKey="key" optionValue="value" name="semester" class="form-control" />
                </div>
            </div>
        </div>
        <div class="table-responsive">
            <table id="studentResults_grid" class="table table-striped table-bordered table-hover">
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
<div class="panel panel-material-light-blue">
    <div class="panel-body">
        <div class="col-md-6">
            <div class="form-group form-group-material-light-blue">
                <label for="selectedProf" class="control-label">Selected Professors(s):</label>
                <g:select name="selectedProf" from="${null}" multiple="true" class="form-control" style="height:200px;"/>
            </div>
        </div>
        <div class="col-md-6">
            <div class="col-md-12">
                <button type="button" id="printAllReport" class="btn btn-material-blue btn-block">Print All</button>
            </div>
            <div class="col-md-12">
                <button type="button" id="printReport" class="btn btn-material-blue btn-block">Print Selected</button>
            </div>
            <div class="col-md-12">
                <button type="button" id="clearSelected" class="btn btn-default btn-block">Clear Selected</button>
            </div>
        </div>
    </div>
</div>