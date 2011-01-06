<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML>
<HEAD>
<%@ page 
	language="java"
	contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"
	isErrorPage="true"
	import="javax.servlet.ServletException, java.io.PrintWriter"
%>

<META http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<TITLE>ERREUR</TITLE>
</HEAD>
<BODY>
<H1 align="center">ERREUR</H1>
<%
Throwable cause = exception;
if (cause != null) {
	if (cause instanceof ServletException && ((ServletException)cause).getRootCause() != null) {
		cause = ((ServletException)cause).getRootCause();
	}
	if (cause instanceof ServletException && ((ServletException)cause).getRootCause() != null) {
		cause = ((ServletException)cause).getRootCause();
	}

	out.println ("<pre>");
	cause.printStackTrace(new PrintWriter(out));
	out.println ("</pre>");
} 
else {
	out.println ("Erreur : NULL");
}
%>

</BODY>
</HTML>
