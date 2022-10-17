<%--
  Created by IntelliJ IDEA.
  User: sueun
  Date: 2022/10/11
  Time: 1:30 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Title</title>
</head>
<body>
<h1>Logout Page</h1>
<%--post방식으로 전송시, 시큐리티 내부적으로 로그아웃이 처리되어 자동으로 로그인페이지를 호출함
    직접 처리를 하고싶다면 logoutSuccessHandler를 정의하면 된다.
--%>
<form action="/customLogout" method="post">
  <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
  <button>로그아웃</button>
</form>
</body>
</html>
