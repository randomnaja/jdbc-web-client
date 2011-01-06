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
String tableName = request.getParameter("tableName");
%>
<META http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<META name="GENERATOR" content="IBM WebSphere Studio">
<META http-equiv="Content-Style-Type" content="text/css">
<LINK href="theme/Master.css" rel="stylesheet" type="text/css">
<TITLE>JDBC WEB CLIENT</TITLE>
</HEAD>
<BODY >

<jsp:include page="menu.jsp"/>

<H1 align="center">TABLE <%=tableName%></H1>

<h3><a href="sqlclient.jsp?query=select%20*%20from%20<%=tableName%>">Watch Data</a></h3>
<h3><a href="indexes.jsp?tableName=<%=tableName%>">Indexes</a></h3>

<TABLE width="100%" border="1">
<TR>
<%
	Connection connection = null;
	ResultSet resultSet = null;
	try {
		connection = jdbcwebclient.ConnectionFactory.getInstance().getConnection(request);
		String dataSourceSchema = jdbcwebclient.ConnectionFactory.getInstance().getDataSourceSchema(request);
		resultSet = connection.getMetaData().getColumns(null, dataSourceSchema, tableName, null);
		
		int columnCount = resultSet.getMetaData().getColumnCount();
		for (int i=1 ; i<=columnCount ; ++i) {
			out.println ("<TH>");
			out.println (resultSet.getMetaData().getColumnName(i));
			out.println ("</TH>");
		}
%>
</TR>
<%
		int rowCount = 0;
		while (resultSet.next()) {
			rowCount++;
			out.println ("<TR>");
			for (int i=1 ; i<=columnCount ; ++i) {
				out.println ("<TD>");
				String value = resultSet.getString(i);
				if (value != null) {
					value = value.replaceAll("<", "&lt;").replaceAll(">", "&gt;");
				}
				out.println (value);
				out.println ("</TD>");
			}
			out.println ("</TR>");
		}
	}
	catch (Throwable t) {
		out.println ("<pre>");
		t.printStackTrace(new java.io.PrintWriter(out));
		out.println ("</pre>");
	}
	finally {
		try {
			resultSet.close();
		} catch (Throwable t) {}
		try {
			connection.close();
		} catch (Throwable t) {}
	}
%>

</TABLE>

</BODY>
</HTML>
