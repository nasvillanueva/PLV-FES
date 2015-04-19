<div class="panel panel-material-light-blue">
    <div class="panel-body">
        <div class="col-md-12">
            <g:form target="_blank" class="form-horizontal">
                <div class="form-group form-group-material-light-blue">
                    <label class="control-label col-md-3" for="lFilterCheck">
                        <div class="checkbox no-space">
                            <label>
                                <g:checkBox name="lFilterCheck"/> <strong>Group:</strong>
                            </label>
                        </div>
                    </label>
                    <div class="col-md-9">
                        <div class="col-md-12">
                            <fesSelect:filterType name="lFilterType" class="form-control" disabled="true" required="required"/>
                        </div>
                        <div class="col-md-12">
                            <fesSelect:college name="lCollegeFilter" class="form-control collapse" disabled="true" required="required"/>
                        </div>
                        <div class="col-md-12">
                            <fesSelect:department name="lDepartmentFilter" class="form-control collapse" disabled="true" required="required"/>
                        </div>
                    </div>
                </div>
                <div class="form-group form-group-material-light-blue">
                    <label class="control-label col-md-3" for="rankCheck">
                        <div class="checkbox no-space">
                            <label>
                                <g:checkBox name="lRankCheck"/> <strong>&nbsp;&nbsp;Rank:</strong>
                            </label>
                        </div>
                    </label>
                    <div class="col-md-9">
                        <div class="col-md-12">
                            <fesSelect:ranking name="lRankFilter" class="form-control" disabled="true" required="required"/>
                        </div>
                    </div>
                </div>
                <div class="form-group form-group-material-light-blue">
                    <label class="control-label col-md-3" for="lLimitCheck">
                        <div class="checkbox no-space">
                            <label>
                                <g:checkBox name="lLimitCheck"/> <strong>&nbsp;Limit:</strong>
                            </label>
                        </div>
                    </label>
                    <div class="col-md-9">
                        <div class="col-md-12">
                            <g:field type="number" name="lLimit" placeholder="Limit" class="form-control" disabled="true" required="required" min="1"/>
                        </div>
                    </div>
                </div>
                <div class="form-group form-group-material-light-blue">
                    <label class="control-label col-md-3" for="lLimitCheck">
                        <div class="checkbox no-space">
                            <label>
                                <g:checkBox name="lEvalStatCheck"/> <strong>Status:</strong>
                            </label>
                        </div>
                    </label>
                    <div class="col-md-9">
                        <div class="col-md-12">
                            <g:select name="lEvalStat" from="${[[key:'evaluated',value:'Evaluated'],[key:'nevaluated',value:'Not Evaluated']]}" noSelection="['':'Select One...']" optionKey="key" optionValue="value" required="required" disabled="true" class="form-control"/>
                        </div>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-3 col-md-offset-9">
                        <g:actionSubmit action="viewPrintListOfFaculties" value="Print Report" class="btn btn-material-light-blue"/>
                    </div>
                </div>
            </g:form>
        </div>
    </div>
</div>