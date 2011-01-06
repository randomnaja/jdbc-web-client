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

<H1 align="center">INDEXES OF TABLE <%=tableName%></H1>

<h3><a href="sqlclient.jsp?query=select%20*%20from%20<%=tableName%>">Watch Data</a></h3>
<h3><a href="table.jsp?tableName=<%=tableName%>">Table Columns</a></h3>

<TABLE width="100%" border="1">
<TR>
<%
	Connection connection = null;
	Statement st = null;
	
	ResultSet resultSet = null;
	boolean hasResults = false;
	try {
		connection = jdbcwebclient.ConnectionFactory.getInstance().getConnection(request);
		if (!jdbcwebclient.ConnectionFactory.getInstance().isSybaseConnection(connection)) {
			out.println ("<TD>This SGBD is not supported for this screen.</TD></TR></TABLE></BODY></HTML>");
			return;
		}
		st = connection.createStatement();
		try {
			resultSet = st.executeQuery ("exec sp_helpindex '" + tableName + "'");
			hasResults = true;
		}
		catch (SQLException e) {
			// cas où il n'y a pas d'indexes
			if (e.getSQLState() != null && e.getSQLState().equals("JZ0R2")) {
				out.println ("<TD>No index</TD>");
				hasResults = false;
			}
			else {
				throw e;
			}
		}
		
		if (hasResults) {
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
					out.println (value);
					out.println ("</TD>");
				}
				out.println ("</TR>");
			}
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
			st.close();
		} catch (Throwable t) {}
		try {
			connection.close();
		} catch (Throwable t) {}
	}
%>

</TABLE>


</BODY>
</HTML>
