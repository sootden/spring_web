<%--
  Created by IntelliJ IDEA.
  User: sueun
  Date: 2022/10/11
  Time: 2:29 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<html>
<head>
    <title>Title</title>
</head>
<body>
<h1>/sample/admin page</h1>
<%--<sec:authentication property="principal"/>
    principal : loadUserByUsername()의 리턴값인 CustomUser객체를 의미한다.
    즉, 해당 태그는 UserDetailsService에서 반환된 객체를 의미하며
    우리가 직접 구현한 CustomUserDetailsService의 loadUserByUsername()의 리턴값 CustomUser을 의미하는 것

    property="principal.member" 는 CustomUser의 getMember()를 호출하는 것
--%>
<p>principal : <sec:authentication property="principal"/></p>
<p>MemberVO : <sec:authentication property="principal.member"/></p>
<p>사용자 이름 : <sec:authentication property="principal.member.userName"/></p>
<p>사용자 권한 리스트 : <sec:authentication property="principal.member.authList"/></p>

<a href ="/customLogout">Logout</a>
</body>
</html>
