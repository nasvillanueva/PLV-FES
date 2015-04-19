<%--
  Created by IntelliJ IDEA.
  User: Nas
  Date: 6/27/2014
  Time: 8:50 PM
--%>

<%@ page import="edu.plv.fes.SystemConfiguration; edu.plv.fes.FESUser" contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main"/>
    <title>Evaluation | PLV-FES</title>
    <script>
        function checkInput(){
            var check = $('.form-question').length == $('input[type="radio"]:checked').length;
            if(!check){
                alert("Please answer all the questions from the evaluation!");
            }
            if(check){
                check = confirm("Are you sure you want to submit this evaluation?");
            }
            return check;
        }
        function lineBreakWatcher(event){
            var keyInput = event.keyCode || event.which;
            var lineBreaks = $('#comment').val().match(/\n/) !== null ? $('#comment').val().match(/\n/gm).length : 0;
            if(keyInput == '13' && lineBreaks == 2){
                return false;
            }
            return true;
        }
        function init(){
            $('#btnSubmit').on('click',checkInput);
            $('#comment').on('keydown',lineBreakWatcher);
        }
    </script>
</head>

<body>
<div class="panel panel-default panel-material-light-blue">
    <div class="panel-heading">
        <%
            def semester = SystemConfiguration.findByConfigName('semester').configValue;
            def schoolYear = SystemConfiguration.findByConfigName('schoolyear').configValue;
        %>
        <h3 class="panel-title">Evaluation for <strong>${prof.salutation ? prof.salutation + ' ' + prof.toString() : prof.toString()}</strong> for ${semester}<sup>${(semester == 1)?'st':'nd'}</sup> Semester, S.Y ${schoolYear} - ${schoolYear + 1}</h3>
    </div>

    <div class="panel-body">
        <div class="col-md-6 col-md-offset-3">
        <div class="alert alert-success">
            <h4>Interpretation:</h4>
            <table class="table table-condensed table-bordered">
                <g:each in="${edu.plv.fes.Interpretation.withCriteria{ order 'scale','desc' eq 'active',true }}" var="i">
                <tr>
                    <td>${i.scale} - ${i.rating}</td>
                    <td>${i.description}</td>
                </tr>
                </g:each>
            </table>
        </div>
        </div>
        <g:form controller="evaluation" action="addEvaluation" role="form" method="post">
            <div class="row">
                <div class="col-md-12">
                    <div class="table-responsive">
                        <g:hiddenField name="prof_id" value="${prof.id}"/>
                        <g:hiddenField id="questionString" name="questionString" value="${question.id}"/>

                        <table class="table table-hover">
                            <g:each in="${category}" var="cat">
                                <tr class="active">
                                    <th>${cat.description}</th>
                                    <g:each in="${interpretation}" var="i">
                                        <th style="padding-left: 20px;">${i.scale}</th>
                                    </g:each>
                                </tr>
                                <g:each in="${question}" var="q">
                                    <g:if test="${q.evaluationCategory.equals(cat)}">
                                        <tr>
                                            <td class="form-question">${q.question}</td>
                                            <g:each in="${interpretation}" var="i">
                                                <td>
                                                    <div class="radio radio-material-light-blue">
                                                        <label>
                                                            <input type="radio" name="${q.id}" value="${i.scale}"
                                                                   required="required"/>
                                                        </label>
                                                    </div>
                                                </td>
                                            </g:each>
                                        </tr>
                                    </g:if>
                                </g:each>
                            </g:each>
                        </table>

                    </div>
                </div>
            </div>
            <g:if test="${edu.plv.fes.FESUser.findByUsername(org.apache.shiro.SecurityUtils.subject.principal.toString()).usertype == edu.plv.fes.constants.FESConstants.USER_TYPE_STUDENT}">
                <div class="row">
                    <div class="col-md-8 col-md-offset-2">
                        <div class="form-group form-group-material-light-blue">
                            <label for="comment" class="control-label">Comments and/or Suggestions:</label>

                            <div class="form-control-wrapper">
                                <g:textArea name="comment" rows="5" maxlength="250" placeholder="Comments/Suggestions" class="form-control" required="required" onpaste="return false;"/>
                                <span class="material-input"></span>
                            </div>
                        </div>
                    </div>
                </div>
            </g:if>

            <div class="row">
                <div class="col-md-4 col-md-offset-5">
                    <input id="btnSubmit" type="submit" class="btn btn-lg btn-material-light-blue"/>
                </div>
            </div>
        </g:form>
        <script>
        </script>
    </div>
</div>

</body>
</html>