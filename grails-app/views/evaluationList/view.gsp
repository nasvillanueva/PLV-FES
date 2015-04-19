<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main"/>
    <title>Evaluation List | PLV-FES</title>
</head>

<body>
<div class="panel panel-default panel-material-light-blue">
    <div class="panel-heading">
        <h3 class="panel-title">Evaluation List</h3>
    </div>

    <div class="panel-body">
        <g:if test="${flash.errors}">
            <div class="alert alert-dismissable alert-danger" id="alert">
                <button type="button" class="close" data-dismiss="alert">×</button>
                <strong>${flash.errors}</strong>
            </div>
        </g:if>
        <g:if test="${availableProf.size() > 0}">
            <div class="table-responsive">
                <table class="table table-hover table-bordered">
                    <g:each in="${availableProf}">
                    <tr>
                        <td class="text-center" onclick="location.href='${createLink(controller: 'evaluation', action: 'view', id:it.id)}';">
                            <h3><a class="head" href="${createLink(controller: 'evaluation', action: 'view', id:it.id)}">${it.toString()}</a></h3>
                        </td>
                    </tr>
                    </g:each>
                </table>
            </div>
        </g:if>
        <g:else>
            <h2 class="text-center text-info">The Evaluation List is empty!</h2>
        </g:else>
    </div>
</div>
</body>
</html>