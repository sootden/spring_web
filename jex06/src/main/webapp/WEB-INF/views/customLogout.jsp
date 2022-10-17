<%--
  Created by IntelliJ IDEA.
  User: sueun
  Date: 2022/10/11
  Time: 1:30 PM
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
                    <h3 class="panel-title">Logout Page</h3>
                </div>
                <div class="panel-body">
                    <form role="form" method="post" action="/customLogout">
                        <fieldset>
                            <!-- Change this to a button or input when using this as a form -->
                            <a href="index.html" class="btn btn-lg btn-success btn-block">Logout</a>
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
<c:if test="${param.logout != null}">
    <script>
        $(document).ready(function(){
            alert("로그아웃하였습니다.");
        });
    </script>
</c:if>
</body>
</html>
<%--<%@ page contentType="text/html;charset=UTF-8" language="java" %>--%>
<%--<html>--%>
<%--<head>--%>
<%--    <title>Title</title>--%>
<%--</head>--%>
<%--<body>--%>
<%--<h1>Logout Page</h1>--%>
<%--&lt;%&ndash;post방식으로 전송시, 시큐리티 내부적으로 로그아웃이 처리되어 자동으로 로그인페이지를 호출함--%>
<%--    직접 처리를 하고싶다면 logoutSuccessHandler를 정의하면 된다.--%>
<%--&ndash;%&gt;--%>
<%--<form action="/customLogout" method="post">--%>
<%--  <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>--%>
<%--  <button>로그아웃</button>--%>
<%--</form>--%>
<%--</body>--%>
<%--</html>--%>
