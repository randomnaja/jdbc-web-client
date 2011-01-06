<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<HTML>
<HEAD>
<%@ page
language="java"
contentType="text/html; charset=ISO-8859-1"
pageEncoding="ISO-8859-1"
isErrorPage="false"
errorPage="/erreur.jsp"
import="java.sql.*,
		java.io.*,
		java.util.ArrayList,
		java.util.StringTokenizer"
%>
<%!
	private static String getNextToken (StringTokenizer st) {
		String token = null;
		if (st.hasMoreTokens()) {
			token = st.nextToken();
		}
		if (token != null && token.startsWith("\"")) {
			token = token.substring(1, token.length() - 1);
		}
		if (token != null && token.equals(";")) {
			token = "";
		}
		if (token != null && !token.equals("") && st.hasMoreTokens()) {
			 st.nextToken();
		}
		return token;
	}
%>


<%
// TABLE NAME
String tableName = request.getParameter("tableName");
if (tableName == null) {
	tableName = "";
}
else {
	tableName = tableName.trim();
}
// LOCAL FILE NAME
String localFileName = request.getParameter("localFileName");
if (localFileName == null) {
	localFileName = "";
}
else {
	localFileName = localFileName.trim();
}
// ONE HEADER LINE
String oneHeaderLine = request.getParameter("oneHeaderLine");
if (oneHeaderLine == null) {
	oneHeaderLine = "off";
}
%>
<META http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<META name="GENERATOR" content="IBM WebSphere Studio">
<META http-equiv="Content-Style-Type" content="text/css">
<LINK href="theme/Master.css" rel="stylesheet" type="text/css">
<TITLE>JDBC WEB CLIENT</TITLE>
</HEAD>
<BODY onload="form.tableName.focus()">

<jsp:include page="menu.jsp"/>

<H1 align="center">CSV IMPORT</H1>

<TABLE width="100%" align="center" >
<TR><TD width="100%" align="center">
<FORM name="form" action="csvimport.jsp" method="post">
	<TABLE width="100%" align="center">

		<TR>
			<TD align="left" nowrap>
				Table :
			</TD>
			<TD align="left" width="100%">
				<INPUT name="tableName" type="text" value="<%=tableName%>" style="width:100%">
			</TD>
		</TR>
		<TR>
			<TD align="left" nowrap>
				Local Input Filename :
			</TD>
			<TD align="left" width="100%">
				<INPUT name="localFileName" type="text" value="<%=localFileName%>" style="width:100%">
			</TD>
		</TR>
		<TR>
			<TD align="left">
				&nbsp;
			</TD>
			<TD align="left" width="100%">
				<INPUT name="oneHeaderLine" type="checkbox" <%=(oneHeaderLine.equals("on") ? "checked" : "")%> > The input file contains one header line
			</TD>
		</TR>
		<TR>
			<TD align="center" colspan="2">
				<INPUT type="submit" value="Submit">
			</TD>
		</TR>
	</TABLE>
</FORM>
</TD></TR></TABLE>

<!-- NOTA BENE -->
<b>Some information to know:</b><br>
- Enter the name of the destination table in the "Table" field (ex: ta_person)<br>
- Enter the full path of the CSV input file in the "Local Filename" field (ex: /home/myaccount/data.csv)<br>
- The CSV file must be on the jdbc-web-client machine, not on your client machine<br>
- The format of the file must be CSV format, with ';' as column separator<br>
- The order of the columns of the CSV file must be the same order than the columns of the table<br>
<!-- /NOTA BENE -->

<%
if (!tableName.equals("") && !localFileName.equals("")) {

	Connection connection = null;
	Statement st = null;
	String query = null;

	FileReader fr = null;
	BufferedReader br = null;
	String line = null;
	String value = null;
	int rowCount = 0;

	try {
		// Ouverture du fichier d'entrée
		fr = new FileReader (localFileName);
		br = new BufferedReader (fr);

		// Ouverture d'une connexion SQL
		connection = jdbcwebclient.ConnectionFactory.getInstance().getConnection(request);

		// Récupération des méta data des colonnes de la table
		ResultSet rs = connection.getMetaData().getColumns(null, null, tableName, null);
		ArrayList columnsList = new ArrayList();

		while (rs.next()) {
			int dataType = rs.getInt("DATA_TYPE");

			switch (dataType) {

				case Types.BIGINT:
				case Types.DECIMAL:
				case Types.DOUBLE:
				case Types.FLOAT:
				case Types.INTEGER:
				case Types.NUMERIC:
				case Types.REAL:
				case Types.SMALLINT:
				case Types.TINYINT:
					columnsList.add(Boolean.TRUE);
					break;

				default:
					columnsList.add(Boolean.FALSE);
					break;
			}
		}

		// Ligne d'entête
		if (oneHeaderLine.equals("on")) {
			br.readLine();
		}

		// Lecture du fichier ligne à ligne
		while ( (line = br.readLine()) != null) {

			// préparation de la requête d'insertion
			line = line.replaceAll("'", "''");
			query = "insert into " + tableName + " values (";
			StringTokenizer stLine = new StringTokenizer (line, ";", true);
			int columnIndex = 0;
			while (stLine.hasMoreTokens()) {
				value = getNextToken(stLine);
				if (!columnsList.get(columnIndex).equals(Boolean.TRUE)) {
					query += "'";
				}
				query += value;
				if (!columnsList.get(columnIndex).equals(Boolean.TRUE)) {
					query += "'";
				}
				if (stLine.hasMoreTokens()) {
					query += ", ";
					columnIndex++;
				}
			}
			query += ")";

			// exécution de la requete d'insertion
			st = connection.createStatement();
			st.execute(query);
			st.close();

			++rowCount;
		}

		// affichage du nombre d'enregistrements insérés
%>
		<br clear="all">
		<br clear="all">
		<i><b><%=rowCount%> row(s) inserted</b></i>
		<br clear="all">
<%
	}
	catch (Throwable t) {
		out.println ("<pre>");
		t.printStackTrace(new java.io.PrintWriter(out));
		out.println ("</pre>");
	}
	finally {
		try {
			br.close();
		} catch (Throwable t) {}
		try {
			connection.close();
		} catch (Throwable t) {}
	}
}
%>


</BODY>
</HTML>
