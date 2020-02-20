<%@ page import="org.springframework.security.core.Authentication" %>
<%@ page import="org.springframework.security.core.context.SecurityContextHolder" %>
<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>

<!DOCTYPE html>
<html lang="en" xmlns:th="http://www.w3.org/1999/xhtml" xmlns:sec="http://www.w3.org/1999/xhtml">
<head>
    <meta charset="UTF-8">
    <title>메인</title>
</head>
<body>
<h1>WELCOM TO GIVEANDTAKE</h1>
<hr>
<%
    Authentication auth = SecurityContextHolder.getContext().getAuthentication();
    Object principal = auth.getPrincipal();

    String name = "";

    if(principal != null) {
        name = auth.getName();
    }
%>


<sec:authorize access="isAnonymous()">

    <input type="button" value="로그인" onClick="self.location='/user/login';">
    <input type="button" value="회원가입" onClick="self.location='/user/email';">

</sec:authorize>



<sec:authorize access="isAuthenticated()">
    <h5><%=name%>님.</h5>
    <input type="button" value="로그아웃" onClick="self.location='/user/logout';">
    <input type="button" value="내정보" onClick="self.location='/user/info';">
</sec:authorize>

<input type="button" value="게시판" onClick="self.location='/board';">
<input type="button" value="어드민" onClick="self.location='/admin';">

</body>
</html>