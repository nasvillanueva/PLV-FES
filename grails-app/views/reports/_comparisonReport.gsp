<div class="panel panel-material-light-blue">
    <div class="panel-body">
        <div class="col-md-12">
            <g:form target="_blank" class="form-horizontal" name="individualComp">
                <div class="form-group form-group-material-light-blue">
                    <label for="schoolyear" class="control-label col-md-3">School Year:</label>
                    <div class="col-md-9">
                        <div class="col-md-12">
                            <g:select from="${evalYear}" noSelection='["${edu.plv.fes.SystemConfiguration?.findByConfigName('schoolyear')?.configValue}":"${edu.plv.fes.SystemConfiguration?.findByConfigName('schoolyear')?.configValue}"]' name="schoolyear" class="form-control" form="individualComp" required="required"/>
                        </div>
                    </div>
                </div>
                <div class="form-group form-group-material-light-blue">
                    <label for="semester" class="control-label col-md-3">Semester:</label>
                    <div class="col-md-9">
                        <div class="col-md-12">
                            <g:select from="${[[key:'1',value:'1st Semester'],[key:'2',value:'2nd Semester']]}" value="${edu.plv.fes.SystemConfiguration?.findByConfigName('semester')?.configValue}" optionKey="key" optionValue="value" name="semester" class="form-control" form="individualComp" required="required"/>
                        </div>
                    </div>
                </div>
                <div class="form-group form-group-material-light-blue">
                    <label class="control-label col-md-3" for="cFilterCheck">
                        <div class="checkbox no-space">
                            <label>
                                <g:checkBox name="cFilterCheck"/> <strong>Group:</strong>
                            </label>
                        </div>
                    </label>
                    <div class="col-md-9">
                        <div class="col-md-12">
                            <fesSelect:filterType name="cFilterType" class="form-control" disabled="true" required="required"/>
                        </div>
                        <div class="col-md-12">
                            <fesSelect:college name="cCollegeFilter" class="form-control collapse" disabled="true" required="required"/>
                        </div>
                        <div class="col-md-12">
                            <fesSelect:department name="cDepartmentFilter" class="form-control collapse" disabled="true" required="required"/>
                        </div>
                    </div>
                </div>
                <div class="form-group form-group-material-light-blue">
                    <label class="control-label col-md-3" for="cRankCheck">
                        <div class="checkbox no-space">
                            <label>
                                <g:checkBox name="cRankCheck"/> <strong>&nbsp;&nbsp;Rank:</strong>
                            </label>
                        </div>
                    </label>
                    <div class="col-md-9">
                        <div class="col-md-12">
                            <fesSelect:ranking name="cRankFilter" class="form-control" disabled="true" required="required"/>
                        </div>
                    </div>
                </div>
                <div class="form-group form-group-material-light-blue">
                    <label class="control-label col-md-3" for="cLimitCheck">
                        <div class="checkbox no-space">
                            <label>
                                <g:checkBox name="cLimitCheck"/> <strong>&nbsp;Limit:</strong>
                            </label>
                        </div>
                    </label>
                    <div class="col-md-9">
                        <div class="col-md-12">
                            <g:field type="number" name="cLimit" placeholder="Limit" class="form-control" disabled="true" required="required" min="1"/>
                        </div>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-3 col-md-offset-9">
                        <g:actionSubmit action="viewPrintComparison" value="Print Report" class="btn btn-material-light-blue"/>
                    </div>
                </div>
            </g:form>
        </div>
    </div>
</div>