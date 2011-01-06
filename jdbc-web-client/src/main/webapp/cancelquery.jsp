<%@ page
language="java"
contentType="text/html; charset=ISO-8859-1"
pageEncoding="ISO-8859-1"
isErrorPage="false"
errorPage="/erreur.jsp"
import="java.sql.*"
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML>
<HEAD>
<META http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<META name="GENERATOR" content="IBM WebSphere Studio">
<META http-equiv="Content-Style-Type" content="text/css">
<LINK href="theme/Master.css" rel="stylesheet" type="text/css">
<TITLE>QUERY CANCELLED</TITLE>
</HEAD>
<BODY >

<TABLE border="0" width="100%" height="100%"><TR><TD align="center" valign="middle">
<%
	try {
		Statement statement = (Statement) session.getAttribute("currentStatement");
		if (statement != null) {
			try {
				statement.close();
			}
			catch (Throwable t) {}
			ResultSet resultSet = (ResultSet) session.getAttribute("currentResultSet");
			if (resultSet != null) {
				try {
					resultSet.close();
				}
				catch (Throwable t) {}
			}
			out.println ("Query cancelled successfully !");
		}
		else {
			out.println ("No query to cancel.");
		}
	}
	catch (Throwable t) {
		out.println ("<pre>");
		t.printStackTrace(new java.io.PrintWriter(out));
		out.println ("</pre>");
	}
%>
</TD></TR></TABLE>

</BODY>
</HTML>
