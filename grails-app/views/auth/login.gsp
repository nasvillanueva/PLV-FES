<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main"/>
    <title>Login | PLV-FES</title>
    <style>
        .no-top-margin{
            margin-top:10px;
        }
        .statement-title{
            width:120px;
            text-transform: uppercase;
            float:left;
            text-align: right;
            margin-right:20px;
        }
    </style>
</head>

<body>
<div class="col-md-8">
    <div class="panel panel-material-light-blue">
        <div class="panel-body">
            <div class="col-md-10 col-md-offset-1">
                <h3 class="text-info no-top-margin">PLV-FES<br><small class="text-info">Pamantasan ng Lungsod ng Valenzuela - Faculty Evaluation System</small></h3>
            </div>
            <div class="col-md-10 col-md-offset-1">
                <hr class="no-top-margin"/>
            </div>
            <div class="col-md-10 col-md-offset-1">
                <h2 class="text-success no-top-margin statement-title" style="float:left;">Vision</h2>
                <p class="lead text-justify">Ensuring a consistently high quality of instruction with a supportive, growth-oriented environment for both students and faculty of the university.</p>
            </div>
            <div class="col-md-10 col-md-offset-1">
                <h2 class="text-success no-top-margin statement-title">Mission</h2>
                <p class="lead text-justify">To provide feedback to help each individual instructor improve the quality of their instruction. In this way, data from evaluation can serve as indicators of programmatic instructional effectiveness related to student learning outcomes.</p>
            </div>
        </div>
    </div>
</div>

<div class="col-md-4" id="loginForm">
    <div class="panel panel-material-light-blue">
        <div class="panel-heading ">
            <h3 class="panel-title">Login</h3>
        </div>

        <div class="panel-body">
            <g:form action="signIn" class="form-horizontal" role="form">
                <input type="hidden" name="targetUri" value="${targetUri}" />
                <div class="form-group form-group-material-light-blue">
                    <label for="username" class="col-md-3 control-label">Username</label>

                    <div class="col-md-9">
                        <g:field type="text" class="form-control" name="username" placeholder="Username"/>
                    </div>
                </div>

                <div class="form-group  form-group-material-light-blue">
                    <label for="password" class="col-md-3 control-label">Password</label>

                    <div class="col-md-9">
                        <g:field type="password" class="form-control" name="password" placeholder="Password"/>
                    </div>
                </div>
                <g:if test="${flash.message}">
                    <div class="alert alert-dismissable alert-danger">
                        <button type="button" class="close" data-dismiss="alert">×</button>
                        <strong>${flash.message}</strong>
                    </div>
                </g:if>
                <div class="form-group">
                    <div class="col-md-offset-7 col-md-5">
                        <button type="submit" class="btn btn-material-light-blue">Log In</button>
                    </div>
                </div>
            </g:form>
        </div>
    </div>
</div>
</body>
</html>