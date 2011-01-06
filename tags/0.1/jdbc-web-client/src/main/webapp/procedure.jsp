<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML>
<HEAD>
<%@ page 
language="java"
contentType="text/html; charset=ISO-8859-1"
pageEncoding="ISO-8859-1"
isErrorPage="false"
errorPage="/erreur.jsp"
import="java.sql.*"

%>
<%
	String procedureName = request.getParameter ("procedureName");
%>

<META http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<META name="GENERATOR" content="IBM WebSphere Studio">
<META http-equiv="Content-Style-Type" content="text/css">
<LINK href="theme/Master.css" rel="stylesheet" type="text/css">
<TITLE>JDBC WEB CLIENT</TITLE>
</HEAD>
<BODY >

<jsp:include page="menu.jsp"/>

<H1 align="center">PROCEDURE <%=procedureName%></H1>

<%
	Connection connection = null;
	Statement st = null;
	
	ResultSet resultSet = null;
	try {
		connection = jdbcwebclient.ConnectionFactory.getInstance().getConnection(request);
		st = connection.createStatement();
		resultSet = st.executeQuery ("select text, colid from sysobjects, syscomments where sysobjects.name='" + procedureName + "' and sysobjects.id=syscomments.id order by colid");

		out.println ("<pre>");

		while (resultSet.next()) {
			out.print (resultSet.getString("text"));
		}

		out.println ("</pre>");
		
	}
	catch (Throwable t) {
		out.println ("<pre>");
		t.printStackTrace(new java.io.PrintWriter(out));
		out.println ("</pre>");
	}
	finally {
		try {
			resultSet.close();
			st.close();
		} catch (Throwable t) {}
		try {
			connection.close();
		} catch (Throwable t) {}
	}
%>

</BODY>
</HTML>
