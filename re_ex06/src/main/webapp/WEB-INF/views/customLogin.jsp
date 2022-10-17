<%--
  Created by IntelliJ IDEA.
  User: sueun
  Date: 2022/10/11
  Time: 12:37 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<html>
<head>
    <title>Title</title>
</head>
<body>
    <h1>Custom Login Page</h1>
    <h2><c:out value="${error}"/></h2>
    <h2><c:out value="${logout}"/> </h2>
<%--    로그인처리는 "/login"으로 전송. 이때 반드시 post방식이어야함--%>
    <form method = "post" action="/login">
        <div>
            <input type="text" name="username" value="admin">
        </div>
        <div>
            <input type="password" name="password" value="admin">
        </div>
        <div>
            <input type="checkbox" name="remember-me"> Remember Me
        </div>
        <div>
            <input type="submit">
        </div>
<%--        실제 브라우저에서는 name이 '_csrf'라는 이름으로 처리 , value는 임의의 값이 저장됨--%>
        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
    </form>
</body>
</html>
