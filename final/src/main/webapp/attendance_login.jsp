<%-- //[START all]--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.google.appengine.api.users.User" %>
<%@ page import="com.google.appengine.api.users.UserService" %>
<%@ page import="com.google.appengine.api.users.UserServiceFactory" %>

<%-- //[START imports]--%>
<%@ page import="com.example.guestbook.Student" %>
<%@ page import="com.example.guestbook.Tutorial" %>
<%@ page import="com.googlecode.objectify.Key" %>
<%@ page import="com.googlecode.objectify.ObjectifyService" %>
<%-- //[END imports]--%>

<%@ page import="java.util.List" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<html>
<head>
    <link type="text/css" rel="stylesheet" href="/stylesheets/main.css"/>
</head>

<body>
</br></br>
<h2 align="center">TUM Attendance System</h2>
</br></br>
<%
    UserService userService = UserServiceFactory.getUserService();
    User user = userService.getCurrentUser();
    if (user != null) {
%>
<p align="center">Welcome back, ${fn:escapeXml(user.nickname)}!</br></p>
<%
    	String redirectURL = "attendance_main.jsp";
    	response.sendRedirect(redirectURL);
    } else {
%>
<h3 align="center">You are not signed in / registered:</br></br>
     <a align="center" href="<%= userService.createLoginURL("attendance_main.jsp") %>"><img width="100" height="100" src="/res/account.png"></br>Sign in</a></h3>
<%
    }
%>
</body>
</html>
<%-- //[END all]--%>
