<div class="panel panel-material-light-blue">
    <div class="panel-body">
        <div class="col-md-12">
            <g:form target="_blank" class="form-horizontal" name="groupComp">
                <div class="form-group form-group-material-light-blue">
                    <label class="control-label col-md-3" for="groupType">Group Type</label>
                    <div class="col-md-9">
                        <div class="col-md-12">
                            <g:select name="groupType" from="['College','Department']" noSelection="['':'Select One...']" class="form-control" required="required"/>
                        </div>
                    </div>
                </div>
                <div class="form-group form-group-material-light-blue">
                    <label for="schoolyear" class="control-label col-md-3">School Year:</label>
                    <div class="col-md-9">
                        <div class="col-md-12">
                            <g:select from="${evalYear}" noSelection='["${edu.plv.fes.SystemConfiguration?.findByConfigName('schoolyear')?.configValue}":"${edu.plv.fes.SystemConfiguration?.findByConfigName('schoolyear')?.configValue}"]' name="schoolyear" class="form-control" form="groupComp" required="required"/>
                        </div>
                    </div>
                </div>
                <div class="form-group form-group-material-light-blue">
                    <label for="semester" class="control-label col-md-3">Semester:</label>
                    <div class="col-md-9">
                        <div class="col-md-12">
                            <g:select from="${[[key:'1',value:'1st Semester'],[key:'2',value:'2nd Semester']]}" value="${edu.plv.fes.SystemConfiguration?.findByConfigName('semester')?.configValue}" optionKey="key" optionValue="value" name="semester" class="form-control" form="groupComp" required="required"/>
                        </div>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-3 col-md-offset-9">
                        <g:actionSubmit action="viewPrintGroupComparison" value="Print Report" class="btn btn-material-light-blue"/>
                    </div>
                </div>
            </g:form>
        </div>
    </div>
</div>