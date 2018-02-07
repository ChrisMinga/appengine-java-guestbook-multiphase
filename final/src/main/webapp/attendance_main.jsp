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
    <script type="text/javascript">
    	function display() {
    		var x = document.getElementById("tutorial_registration_form");
    		if (x.style.display === "none") {
       			 x.style.display = "block";
    		} else {
        		x.style.display = "none";
    		}
		} 
    </script>

<%
    UserService userService = UserServiceFactory.getUserService();
    User user = userService.getCurrentUser();
    
    if (user != null) 
    {
    	Student.addStudent(user);
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
		if(tutorialName == null)
		{
		    String redirectURL = "attendance_login.jsp";
    		response.sendRedirect(redirectURL);
		}
		else if(!tutorialName.equals("none"))
		{
			String redirectURL = "attendance_class.jsp?tutorialID="+tutorialName;
    		response.sendRedirect(redirectURL);
		}
		else
		{
		
%>
        <h3 align="center">Register to a tutorial:</h3></br>
<%
		List<Tutorial> tutorialsList = ObjectifyService.ofy().load().type(Tutorial.class).list();
		if(tutorialsList.isEmpty() == false)
		{
%>
			<table class="center">
			<tr>
				<th>Tutorial ID</th>
				<th>Tutor</th>
				<th>Time</th>
				<th>Day of week</th>
				<th>Place</th>
				<th>Attendance</th>
			</tr>
<%	
			for (Tutorial tutorial : tutorialsList)
			{
				pageContext.setAttribute("tutorial_identifier", tutorial.identifier);
				pageContext.setAttribute("tutorial_tutor", tutorial.tutor);
				pageContext.setAttribute("tutorial_time", tutorial.time);
				pageContext.setAttribute("tutorial_day", tutorial.day);
				pageContext.setAttribute("tutorial_place", tutorial.place);
%>
				<tr class="information">
					<td>${fn:escapeXml(tutorial_identifier)}</td>
					<td>${fn:escapeXml(tutorial_tutor)}</td>
					<td>${fn:escapeXml(tutorial_time)}</td>
					<td>${fn:escapeXml(tutorial_day)}</td>
					<td>${fn:escapeXml(tutorial_place)}</td>
					<td><a align="center" href="attendance_class.jsp?tutorialID=${fn:escapeXml(tutorial_identifier)}">Join</a></td>  
  			</tr>
<% 			}
%>
			</table>
<% 
		}

	//}
%>
</br></br>
<p align="center"><img width="40" height="40" align="middle" src="/res/plus.png" onclick="display()"> Add tutorial</p>

<form id="tutorial_registration_form" action="/register_tutorial" method="post">
    <table class="center">
    	<tr>
    		<td><label>Tutorial ID:</label></td> 
    		<td><input type="text" name="tutorialID"/></td>
    	</tr>
    	<tr>
    		<td><label>Time:</label></td> 
    		<td><input type="text" name="tutorialTime"/></td>
    	</tr>
    	<tr>
    		<td><label>Tutor:</label></td> 
    		<td><input type="text" name="tutorialTutor"/></td>
    	</tr>
    	<tr>
    		<td><label>Day of Week:</label></td> 
    		<td><input type="text" name="tutorialDay"/></td>
    	</tr>
    	<tr>
    		<td><label>Tutorial Place:</label></td> 
    		<td><input type="text" name="tutorialPlace"/></td>
    	</tr>
    	<tr>
    		<td><label></label></td> 
    		<td><input type="submit" value="Add Tutorial"/></td>
    	</tr>
    </table>
</form>
<%
}
%>
</body>
</html>
<%-- //[END all]--%>
