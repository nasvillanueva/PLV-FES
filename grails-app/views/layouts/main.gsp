<%@ page import="edu.plv.fes.constants.FESConstants; edu.plv.fes.FESUser; edu.plv.fes.SystemConfiguration; org.apache.shiro.SecurityUtils" %>
<!DOCTYPE html>
<!--[if lt IE 7 ]> <html lang="en" class="no-js ie6"> <![endif]-->
<!--[if IE 7 ]>    <html lang="en" class="no-js ie7"> <![endif]-->
<!--[if IE 8 ]>    <html lang="en" class="no-js ie8"> <![endif]-->
<!--[if IE 9 ]>    <html lang="en" class="no-js ie9"> <![endif]-->
<!--[if (gt IE 9)|!(IE)]><!--> <html lang="en" class="no-js"><!--<![endif]-->
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <title><g:layoutTitle default="PLV-FES"/></title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="shortcut icon" href="${assetPath(src: 'favicon.ico')}" type="image/x-icon">
    <link rel="apple-touch-icon" href="${assetPath(src: 'apple-touch-icon.png')}">
    <link rel="apple-touch-icon" sizes="114x114" href="${assetPath(src: 'apple-touch-icon-retina.png')}">
    <asset:stylesheet src="application.css"/>
    <asset:javascript src="application.js"/>
    <link rel="stylesheet" href="${resource(file: 'css/bootstrap.css')}"/>
    <link rel="stylesheet" href="${resource(file: 'css/material.css')}"/>
    <link rel="stylesheet" href="${resource(file: 'css/ripples.css')}"/>
    <link rel="stylesheet" href="${resource(file: 'css/jquery.dataTables.css')}"/>
    <link rel="stylesheet" href="${resource(file: 'css/dataTables.bootstrap.css')}"/>
    <script src="${resource(file: 'js/bootstrap.js')}"></script>
    <script src="${resource(file: 'js/material.js')}"></script>
    <script src="${resource(file: 'js/ripples.js')}"></script>
    <script src="${resource(file: 'js/jquery.dataTables.js')}"></script>
    <script src="${resource(file: 'js/dataTables.bootstrap.js')}"></script>
    <asset:javascript src="dataTableUtils.js"/>
    <g:layoutHead/>
</head>

<body>
<%
    def isAdmin = false
    if(SecurityUtils.subject.isAuthenticated()){
        isAdmin = FESUser.findByUsername(SecurityUtils.subject.principal.toString()).usertype == FESConstants.USER_TYPE_ADMIN
    }
%>
<div id="content">
    <div class="container">
        <nav class="navbar navbar-material-light-blue" role="navigation">
            <div class="navbar-header">
                <a class="navbar-brand" href="${createLink(uri: '/')}"><asset:image
                        src="plvfes_logo.png" width="120" alt="PLV-FES"/></a>
            </div>
            <g:if test="${controllerName != 'auth'}">
                <div class="navbar-collapse collapse navbar-responsive-collapse">
                    <ul class="nav navbar-nav navbar-right">
                        <li><a href="${createLink(controller: 'auth',action: 'signOut')}">Log Out</a></li>
                    </ul>
                </div>
            </g:if>
        </nav>
    </div>

    <div class="container">
        <div class="row">
            <g:if test="${controllerName != 'auth' && isAdmin}">
            <div class="col-md-3">
                <div class="panel panel-material-light-blue">
                    <div class="panel-body">
                        <ul class="nav nav-pills nav-stacked">
                            <%
                                def a = SecurityUtils.subject.isPermitted('auditLog:view')
                                def cat = SecurityUtils.subject.isPermitted('evaluationCategory:view')
                                def col = SecurityUtils.subject.isPermitted('college:view')
                                def c = SecurityUtils.subject.isPermitted('evaluationComment:view')
                                def d = SecurityUtils.subject.isPermitted('department:view')
                                def i = SecurityUtils.subject.isPermitted('interpretation:view')
                                def l1 = SecurityUtils.subject.isPermitted('listMaintenance:view')
                                def l2 = SecurityUtils.subject.isPermitted('peerListMaintenance:view')
                                def l3 = SecurityUtils.subject.isPermitted('supervisorListMaintenance:view')
                                def p = SecurityUtils.subject.isPermitted('professor:view')
                                def q = SecurityUtils.subject.isPermitted('evaluationQuestion:view')
                                def r0 = SecurityUtils.subject.isPermitted('ranking:view')
                                def r1 = SecurityUtils.subject.isPermitted('role:view')
                                def r2 = SecurityUtils.subject.isPermitted('results:view')
                                def r3 = SecurityUtils.subject.isPermitted('results:view')
                                def u = SecurityUtils.subject.isPermitted('user:view')
                                def s = SecurityUtils.subject.isPermitted('systemConfiguration:view')
                            %>
                            <li class="dropdown <%if(controllerName == "listMaintenance" || controllerName == "peerListMaintenance" || controllerName == "supervisorListMaintenance" )%> active<%; if(!l1 || !l2 || !l3) %> disabled <%;%>">
                                <a class="dropdown-toggle" data-toggle="dropdown" href="javascript:void(0)">
                                    Evaluation<span class="caret"></span>
                                </a>
                                <ul class="dropdown-menu" role="menu">
                                    <li class="menu-item <% if(!l1)%>disabled<%;if(controllerName == "listMaintenance")%> active<%;%>"><a href="${createLink(uri:'/StudentsListMaintenance')}">List Maintenance - Students</a></li>
                                    <li class="menu-item <% if(!l2)%>disabled<%;if(controllerName == "peerListMaintenance")%> active<%;%>"><a href="${createLink(uri:'/PeerListMaintenance')}">List Maintenance - Peer</a></li>
                                    <li class="menu-item <% if(!l3)%>disabled<%;if(controllerName == "supervisorListMaintenance")%> active<%;%>"><a href="${createLink(uri:'/SupervisorListMaintenance')}">List Maintenance - Supervisor</a></li>

                                </ul>
                            </li>
                            <li class="dropdown <%if(controllerName == "reports" || controllerName == "results" || controllerName == "evaluationComment")%> active<%; if(!r3 || !r2 || !c) %> disabled <%;%>">
                                <a class="dropdown-toggle" data-toggle="dropdown" href="javascript:void(0)">
                                    Reports<span class="caret"></span>
                                </a>
                                <ul class="dropdown-menu" role="menu">
                                    <li class="<% if(!r2)%>disabled<%;if(controllerName == "results")%> active<%;%>"><a href="${createLink(uri:'/Results')}">Results</a></li>
                                    <li class="<% if(!c)%>disabled<%;if(controllerName == "evaluationComment")%> active<%;%>"><a href="${createLink(uri:'/Comments')}">Comments</a></li>
                                    <li class="<% if(!r3)%>disabled<%;if(controllerName == "reports")%> active<%;%>"><a href="${createLink(uri:'/Reports')}">Reports</a></li>
                                </ul>
                            </li>
                            <li class="dropdown <%if(controllerName == "role" || controllerName == "user" || controllerName == "auditLog")%> active<%; if(!r1 || !u || !a) %> disabled <%;%>">
                                <a class="dropdown-toggle" data-toggle="dropdown" href="javascript:void(0)">
                                    Security<span class="caret"></span>
                                </a>
                                <ul class="dropdown-menu" role="menu">
                                    <li class="<% if(!r1)%>disabled<%;if(controllerName == "role")%> active<%;%>"><a href="${createLink(uri:'/Roles')}">Roles</a></li>
                                    <li class="<% if(!u)%>disabled<%;if(controllerName == "user")%> active<%;%>"><a href="${createLink(uri:'/Users')}">Users</a></li>
                                    <li class="<% if(!a)%>disabled<%;if(controllerName == "auditLog")%> active<%;%>"><a href="${createLink(uri:'/AuditLog')}">Audit Logs</a></li>
                                </ul>
                            </li>

                            <li class="dropdown <%if(controllerName == "evaluationCategory" || controllerName == "college" || controllerName == "department" || controllerName == "interpretation" || controllerName == "professor" || controllerName == "evaluationQuestion" || controllerName == "ranking" )%> active<%; if(!cat || !q || !i || !col || !d || !p || !r0) %> disabled <%;%>">
                                <a class="dropdown-toggle" data-toggle="dropdown" href="javascript:void(0)">
                                    Settings<span class="caret"></span>
                                </a>
                                <ul class="dropdown-menu" role="menu">
                                    <li class="<% if(!cat)%>disabled<%;if(controllerName == "evaluationCategory")%> active<%;%>"><a href="${createLink(uri:'/Category')}">Categories</a></li>
                                    <li class="<% if(!q)%>disabled<%;if(controllerName == "evaluationQuestion")%> active<%;%>"><a href="${createLink(uri:'/Question')}">Questions</a></li>
                                    <li class="<% if(!i)%>disabled<%;if(controllerName == "interpretation")%> active<%;%>"><a href="${createLink(uri:'/Interpretation')}">Interpretation</a></li>
                                    <li class="<% if(!col)%>disabled<%;if(controllerName == "college")%> active<%;%>"><a href="${createLink(uri:'/College')}">College</a></li>
                                    <li class="<% if(!d)%>disabled<%;if(controllerName == "department")%> active<%;%>"><a href="${createLink(uri:'/Department')}">Department</a></li>
                                    <li class="<% if(!p)%>disabled<%;if(controllerName == "professor")%> active<%;%>"><a href="${createLink(uri:'/Professors')}">Professors</a></li>
                                    <li class="<% if(!r0)%>disabled<%;if(controllerName == "ranking")%> active<%;%>"><a href="${createLink(uri:'/Ranking')}">Professor Ranking</a></li>

                                    <li class="<% if(!s){%>disabled <%}%>">
                                        <a data-toggle="modal" data-target="#sysConfModal">System Configuration</a>
                                    </li>
                                </ul>
                            </li>
                        </ul>
                    </div>
                </div>
            </div>
            </g:if>

            <g:if test="${controllerName != 'auth'}">
                <div class="col-md-${isAdmin ? '9' : '12'}">
            </g:if>
                <g:layoutBody/>
            <g:if test="${controllerName != 'auth'}">
                </div>
            </g:if>
        </div>
    </div>
    <div class="container">
        <nav class="navbar navbar-material-light-blue">
            <div class="container">
                <p class="muted credit text-center" style="margin-top:15px;">Developed by Zyrel Abaiz and Jonas Manuel Villanueva</p>
            </div>
        </nav>
    </div>
</div>

<g:if test="${SecurityUtils?.subject?.isPermitted('systemConfiguration:view')}">
<div class="modal fade" id="sysConfModal" tabindex="-1" role="dialog" aria-labelledby="sysConfig" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <hr class="no-space">
            <div class="modal-body">
                <div class="bs-component">
                    <ul class="nav nav-tabs nav-justified" style="margin-bottom: 15px;">
                        <li class="active center-block"><a href="#respondentLimit" data-toggle="tab">Respondent Limiter</a></li>
                        <li class="center-block"><a href="#yearsem" data-toggle="tab">S.Y. and Semester</a></li>
                        <li class="center-block"><a href="#sync" data-toggle="tab">Synchronization</a></li>
                    </ul>
                    <div id="myTabContent" class="tab-content">
                        <div class="tab-pane fade active in" id="respondentLimit">
                            <div class="panel panel-material-light-blue">
                                <div class="panel-body">
                                    <g:form controller="systemConfiguration" class="form form-horizontal">
                                        <g:hiddenField name="redirectUri" value="${request.forwardURI - request.contextPath}"/>
                                        <div class="form-group form-group-material-light-blue">
                                            <label class="control-label col-md-3" for="limiter">Repondents' Limit:</label>
                                            <div class="col-md-9">
                                                <g:field type="number" name="limiter" placeholder="Repondents' Limit" value="${SystemConfiguration.findByConfigName('respondentLimit')?.configValue}" class="form-control" required="required"/>
                                            </div>
                                        </div>
                                        <div class="row">
                                            <div class="col-md-4 col-md-offset-8 text-right">
                                                <g:actionSubmit id="btnUpdate" value="Update" action="editRespondentLimit" class="btn btn-material-light-blue"/>
                                            </div>
                                        </div>
                                    </g:form>
                                </div>
                            </div>
                        </div>
                        <div class="tab-pane fade" id="yearsem">
                            <div class="panel panel-material-light-blue">
                                <div class="panel-body">
                                    <g:form controller="systemConfiguration" class="form form-horizontal">
                                        <g:hiddenField name="redirectUri" value="${request.forwardURI - request.contextPath}"/>
                                        <div class="form-group form-group-material-light-blue">
                                            <label class="control-label col-md-3" for="schoolyear">School Year:</label>
                                            <div class="col-md-9">
                                                <select name="schoolYear" id="schoolYear" class="form-control">
                                                <% def sy = SystemConfiguration.findByConfigName('schoolyear').configValue
                                                    for(int x = sy-10;x<sy+10;x++) {
                                                        if (x == sy){ %>
                                                            <option value='${x}' selected>${x}</option>
                                                <%      }else{ %>
                                                            <option value='${x}'>${x}</option>
                                                <%    }
                                                    }
                                                %>
                                                </select>
                                            </div>
                                        </div>
                                        <div class="form-group form-group-material-light-blue">
                                            <label class="control-label col-md-3" for="semester">Semester:</label>
                                            <div class="col-md-9">
                                                <g:select name="semester" from="[1,2]" value="${SystemConfiguration.findByConfigName('semester').configValue}" class="form-control"/>
                                            </div>
                                        </div>
                                        <div class="row">
                                            <div class="col-md-4 col-md-offset-8 text-right">
                                                <g:actionSubmit id="btnUpdate" value="Update" action="editSysConf" class="btn btn-material-light-blue"/>
                                            </div>
                                        </div>
                                    </g:form>
                                </div>
                            </div>
                        </div>
                        <div class="tab-pane fade" id="sync">
                            <div class="panel panel-material-light-blue">
                                <div class="panel-body">
                                    <div class="alert alert-warning">
                                        <h4>Note:</h4>
                                        <p>Make sure to Update School Year and Semester before synchronizing with PLV System</p>
                                    </div>
                                    <div class="row">
                                        <div class="col-md-12">
                                            <button type="button" id="profSync" data-loading-text="<img src='${assetPath(src:'spinner.gif')}' width='20px' height='20px'/> Synchronizing Professors... " class="btn btn-material-green btn-block">
                                                Synchronize Professors
                                            </button>
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="col-md-12">
                                            <button type="button" id="studentSync" data-loading-text="<img src='${assetPath(src:'spinner.gif')}' width='20px' height='20px'/> Synchronizing Students... " class="btn btn-material-green btn-block">
                                        Synchronize Students
                                        </button>
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="col-md-12">
                                            <button type="button" id="schedSync" data-loading-text="<img src='${assetPath(src:'spinner.gif')}' width='20px' height='20px'/> Synchronizing Schedule... " class="btn btn-material-green btn-block" >
                                        Synchronize Schedule
                                        </button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
            </div>
        </div>
    </div>
</div>
<script>
     function synchronizeSys(){
         var id = $(this).attr('id');
         var msg = "";
         var link = "";
         if(id == 'profSync'){
             msg = "Professors";
             link = "${createLink(controller: 'systemConfiguration',action: 'editSyncProfessor')}";
         }else if(id == 'studentSync'){
             msg = "Students";
             link = "${createLink(controller: 'systemConfiguration',action: 'editSyncStudent')}";
         }else if(id == 'schedSync'){
             msg = "Schedules";
             link = "${createLink(controller: 'systemConfiguration',action: 'editSyncStudentSchedule')}";
         }
         if(confirm("Synchronize "+ msg +"?")) {
             $(this).button('loading');
             popupOverlay();
             $.post(link, function (data) {
                 if (data.success)
                     alert(msg + " are now synchronized with PLV System");
                 else
                     alert("There was a problem synchronizing with PLV System. Please try again.");

                 $('#'+id).button('reset');
                 removeOverlay();
             });
         }
     }
     $(document).ready(function() {
        $('#profSync, #studentSync, #schedSync').on('click',synchronizeSys);
     });
</script>
</g:if>

<div id="spinner" class="spinner" style="display:none;"><g:message code="spinner.alt"
                                                                   default="Loading&hellip;"/></div>
<script>
    function popupOverlay(){
        var docHeight = $(document).height();

        $("body").append("<div id='overlay'></div>");

        $("#overlay")
                .height(docHeight)
                .css({
                    'opacity' : 0.0,
                    'position': 'absolute',
                    'top': 0,
                    'left': 0,
                    'width': '100%',
                    'z-index': 5000
                });
    }
    function removeOverlay(){
        $("#overlay").remove();
    }
    $(document).ready(function() {
        $.material.init();
        $(init);
    });
</script>
</body>
</html>
