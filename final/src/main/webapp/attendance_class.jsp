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
<%
    UserService userService = UserServiceFactory.getUserService();
    User user = userService.getCurrentUser();
    
    if (user != null) 
    {
        pageContext.setAttribute("user", user);
%>
<p align="right">Logged as: ${fn:escapeXml(user.nickname)}  <a href="<%= userService.createLogoutURL("attendance_login.jsp") %>">Sign out</a>  </p>
<%
    } 
    else 
    {
    	String redirectURL = "attendance_login.jsp";
    	response.sendRedirect(redirectURL);
    }
%>
</br>
<h2 align="center">TUM Attendance System</h2>
<%
		String tutorialName = Student.getStudentsTutorial(user);
		String tutorialID = request.getParameter("tutorialID");
		pageContext.setAttribute("tutorialID", tutorialID);
		
		if(tutorialName == null)
		{
		    String redirectURL = "attendance_login.jsp";
    		response.sendRedirect(redirectURL);
		}
		else if(!tutorialName.equals("none"))
		{
			if(!tutorialName.equals(tutorialID))
			{
				String redirectURL = "attendance_main.jsp";
    			response.sendRedirect(redirectURL);
    		}
		}
		else
		{
			Student.registerToTutorial(user,tutorialID);
		}
%>

<p align="center"><b>You are registered to group ${fn:escapeXml(tutorialID)}</b></p></br>
<form action="/unsubscribe_student" method="post">
	<table class="center">
		<tr>
    		<td><input type="submit" value="Unsubscribe ${fn:escapeXml(tutorialID)}"/></td>
    	</tr>
	<input type="hidden" name="tutorialID" value="${fn:escapeXml(tutorialID)}"/>
	<input type="hidden" name="userID" value="<%=user.getUserId()%>"/>
	</table>
</form>
</body>
</html>
<%-- //[END all]--%>
