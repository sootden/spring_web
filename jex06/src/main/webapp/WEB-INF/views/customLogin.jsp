<%--
  Created by IntelliJ IDEA.
  User: sueun
  Date: 2022/10/11
  Time: 12:37 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<html>
<head>
    <link href="/resources/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">
    <link href="/resources/vendor/metisMenu/metisMenu.min.css" rel="stylesheet">
    <link href="/resources/dist/css/sb-admin-2.css" rel="stylesheet">
    <link href="/resources/vendor/font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css">
    <title>Title</title>
</head>
<body>

<div class="container">
    <div class="row">
        <div class="col-md-4 col-md-offset-4">
            <div class="login-panel panel panel-default">
                <div class="panel-heading">
                    <h3 class="panel-title">Please Sign In</h3>
                </div>
                <div class="panel-body">
                    <form role="form" method="post" action="/login">
                        <fieldset>
                            <div class="form-group">
                                <input class="form-control" placeholder="userid" name="username" type="text" autofocus>
                            </div>
                            <div class="form-group">
                                <input class="form-control" placeholder="Password" name="password" type="password" value="">
                            </div>
                            <div class="checkbox">
                                <label>
                                    <input name="remember-me" type="checkbox">Remember Me
                                </label>
                            </div>
                            <!-- Change this to a button or input when using this as a form -->
                            <a href="index.html" class="btn btn-lg btn-success btn-block">Login</a>
                        </fieldset>
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- jQuery -->
<script src="/resources/vendor/jquery/jquery.min.js"></script>

<!-- Bootstrap Core JavaScript -->
<script src="/resources/vendor/bootstrap/js/bootstrap.min.js"></script>

<!-- Metis Menu Plugin JavaScript -->
<script src="/resources/vendor/metisMenu/metisMenu.min.js"></script>

<!-- Custom Theme JavaScript -->
<script src="/resources/dist/js/sb-admin-2.js"></script>
<script>
    $(".btn-success").on("click", function(e){
       e.preventDefault();
       $("form").submit();
    });
</script>
</body>
<%--<body>--%>
<%--    <h1>Custom Login Page</h1>--%>
<%--    <h2><c:out value="${error}"/></h2>--%>
<%--    <h2><c:out value="${logout}"/> </h2>--%>
<%--&lt;%&ndash;    로그인처리는 "/login"으로 전송. 이때 반드시 post방식이어야함&ndash;%&gt;--%>
<%--    <form method = "post" action="/login">--%>
<%--        <div>--%>
<%--            <input type="text" name="username" value="admin">--%>
<%--        </div>--%>
<%--        <div>--%>
<%--            <input type="password" name="password" value="admin">--%>
<%--        </div>--%>
<%--        <div>--%>
<%--            <input type="checkbox" name="remember-me"> Remember Me--%>
<%--        </div>--%>
<%--        <div>--%>
<%--            <input type="submit">--%>
<%--        </div>--%>
<%--&lt;%&ndash;        실제 브라우저에서는 name이 '_csrf'라는 이름으로 처리 , value는 임의의 값이 저장됨&ndash;%&gt;--%>
<%--        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>--%>
<%--    </form>--%>
<%--</body>--%>
</html>
