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
<%!

	private String replace (String s, String oldExpr, String newExpr) {
		StringBuffer result = new StringBuffer(s);
		int index = 0;

		while ((index = result.indexOf (oldExpr, index)) != -1) {
			result.replace (index, index + oldExpr.length(), newExpr);
			index += newExpr.length();
		}

		return result.toString();
	}
%>

<jsp:useBean id="queriesList" scope="session" class="java.util.ArrayList"/>

<%
// QUERY ROW COUNT
Integer queryRowsCount;
if (request.getParameter ("queryRowsCount") != null) {
	queryRowsCount = new Integer (request.getParameter ("queryRowsCount"));
}
else if (session.getAttribute ("queryRowsCount") != null) {
	queryRowsCount = (Integer) session.getAttribute ("queryRowsCount");
}
else {
	queryRowsCount = new Integer (4);
}
session.setAttribute ("queryRowsCount", queryRowsCount);

// FORCE RESULT SET
boolean forceResultSet = (request.getParameter("forceResultSet") != null);

// CSV FORMAT
boolean csvFormat = (request.getParameter("csvFormat") != null);

// QUERY
String query = request.getParameter("query");
if (query == null) {
	query = "";
}
else {
	query = query.trim();
	if (query.endsWith(";")) {
		query = query.substring (0, query.length()-1);
	}
	if (queriesList.isEmpty() || !query.equals(queriesList.get(queriesList.size()-1))) {
		queriesList.add(query);
	}
}
%>
<META http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<META name="GENERATOR" content="IBM WebSphere Studio">
<META http-equiv="Content-Style-Type" content="text/css">
<LINK href="theme/Master.css" rel="stylesheet" type="text/css">
<TITLE>JDBC WEB CLIENT</TITLE>
<SCRIPT language="javascript">
	var queriesList;
	var iQueriesList;

	function init() {
		queriesList = new Array(<%=queriesList.size()%>);
<%
		for (int i=0 ; i<queriesList.size() ; ++i) {
			String currentQuery = (String) queriesList.get(i);
			currentQuery = replace(currentQuery, "\r\n", "\\n");
			currentQuery = replace(currentQuery, "'", "\\'");
			out.println ("queriesList[" + i + "] = '" + currentQuery + "';");
		}
%>
		if (queriesList.length > 0 && form.query.value != queriesList[queriesList.length-1]) {
			iQueriesList = queriesList.length;
			form.previousQuery.disabled = false;
		}
		else {
			iQueriesList = queriesList.length - 1;
		}
	}

	function previous() {
		if (iQueriesList > 0) {
			--iQueriesList;
			if (form.query.value == queriesList[iQueriesList] && iQueriesList > 0) {
				--iQueriesList;
			}
			form.query.value = queriesList[iQueriesList];
			form.nextQuery.disabled = false;
			if (iQueriesList >= queriesList.length-1) {
				form.nextQuery.disabled = true;
			}
			if (iQueriesList <= 0) {
				form.previousQuery.disabled = true;
			}
		}
	}

	function next() {
		if (iQueriesList < queriesList.length-1) {
			++iQueriesList;
			form.query.value = queriesList[iQueriesList];
			form.previousQuery.disabled = false;
			if (iQueriesList >= queriesList.length-1) {
				form.nextQuery.disabled = true;
			}
		}
	}

	function lessRows() {
		if (form.queryRowsCount.value > 1) {
			form.query.rows = form.query.rows - 1;
			form.queryRowsCount.value = form.query.rows;
		}
	}

	function moreRows() {
		form.query.rows = form.query.rows + 1;
		form.queryRowsCount.value = form.query.rows;
	}

	function onKeyDown (event) {
		if (event.keyCode == 33) {
			previous();
		}
		else if (event.keyCode == 34) {
			next();
		}
	}

	function onKeyUp (event) {
		if (event.keyCode == 33) {
		}
		else if (event.keyCode == 34) {
		}
		else if (queriesList.length > 0 && iQueriesList < queriesList.length && form.query.value != queriesList[iQueriesList]) {
			iQueriesList = queriesList.length;
			form.previousQuery.disabled = false;
			form.nextQuery.disabled = true;
		}
	}

	function checkCsvFormat() {
		if (form.csvFormat.checked) {
			form.action = "csvexport.jsp";
		}
		else {
			form.action = "sqlclient.jsp";
		}
	}

	function cancelQuery() {
		var popupwidth = 320;
		var popupheight = 120;
		var popupleft = (screen.width - popupwidth) / 2;
		var popuptop = (screen.height - popupheight) / 2;

		cancelWindow=window.open('cancelquery.jsp','Cancel','toolbar=no,location=no,directories=no,menubar=no,resizable=yes,scrollbars=yes,status=no,width='+popupwidth+',height='+popupheight+',left='+popupleft+',top='+popuptop);
		cancelWindow.focus();
	}

</SCRIPT>
</HEAD>
<BODY onload="init();form.query.focus()">

<jsp:include page="menu.jsp"/>

<H1 align="center">JDBC WEB CLIENT</H1>

<TABLE width="100%" align="center" >
<TR><TD width="100%" align="center">
<FORM name="form" action="sqlclient.jsp" method="post" >
	<TABLE width="100%" align="center">

		<TR>
			<TD  align="left" valign="top" >
				<INPUT name="previousQuery" type="button" value="&lt;" onclick="previous()" <%=((queriesList.size()>1)?"":"disabled")%> tabindex="1" >
			</TD>
			<TD rowspan="2" width="100%" align="center">
				<TEXTAREA style="width:100%" rows="<%=queryRowsCount%>" name="query" onkeydown="onKeyDown(event)" onKeyUp="onKeyUp(event)" tabindex="3" ><%=query%></TEXTAREA>
			</TD>
			<TD  align="right" valign="top" >
				<INPUT name="decreaseRows" type="button" value="-" onclick="lessRows()" tabindex="8" >
			</TD>
		</TR>
		<TR>
			<TD  align="left" valign="bottom" >
				<INPUT name="nextQuery" type="button" value="&gt;" onclick="next()" disabled tabindex="2" >
			</TD>
			<TD  align="right" valign="bottom" >
				<INPUT name="increaseRows" type="button" value="+" onclick="moreRows()" tabindex="9" >
			</TD>
		</TR>
		<TR>
			<TD colspan="2" align="center">
				<INPUT name="submitButton" type="submit" tabindex="4" value="Submit">
				<INPUT name="cancelButton" type="button" tabindex="5" value="Cancel" onclick="cancelQuery()">
				<INPUT type="checkbox" tabindex="6" name="forceResultSet" <%=(forceResultSet?"checked":"")%>>Force ResultSet
				<INPUT type="checkbox" tabindex="7" name="csvFormat" <%=(csvFormat?"checked":"")%> onclick="checkCsvFormat()">CSV Format
				<INPUT name="queryRowsCount" type="hidden" value="<%=queryRowsCount%>" >
			</TD>
		</TR>
	</TABLE>
</FORM>
</TD></TR></TABLE>

<%
if (!query.equals("")) {

	Connection connection = null;
	String currentQuery = null;
	int queryIndexStart = 0;
	int queryIndexEnd = 0;
	Statement st = null;
	ResultSet resultSet = null;
	int updateCount = -1;
	boolean isResultSet = false;
	long executionTime;

	try {
		connection = jdbcwebclient.ConnectionFactory.getInstance().getConnection(request);

		while (queryIndexStart < query.length()) {
			queryIndexEnd = query.indexOf("\r\ngo", queryIndexEnd);
			if (queryIndexEnd == -1) {
				currentQuery = query.substring (queryIndexStart);

				if (queryIndexStart != 0) {
					out.println ("<hr>");
					out.println (currentQuery);
					out.println ("<br clear='all'>");
				}

				queryIndexStart = query.length();
				queryIndexEnd = query.length();
			}
			else {
				currentQuery = query.substring (queryIndexStart, queryIndexEnd);
				queryIndexEnd = queryIndexEnd + "\r\ngo".length();
				while (queryIndexEnd < query.length()
					&& (query.charAt(queryIndexEnd) == ' '
					|| query.charAt(queryIndexEnd) == '\t'
					|| query.charAt(queryIndexEnd) == '\r'
					|| query.charAt(queryIndexEnd) == '\n')) {
						++queryIndexEnd;
				}
				queryIndexStart = queryIndexEnd;

				out.println ("<hr>");
				out.println (currentQuery);
				out.println ("<br clear='all'>");
			}

			try {

				executionTime = System.currentTimeMillis();

				if (currentQuery.startsWith ("exec ")) {
					st = connection.prepareStatement(currentQuery);
					session.setAttribute("currentStatement", st);
					if (forceResultSet) {
						((PreparedStatement)st).executeQuery();
						isResultSet = true;
					}
					else {
						isResultSet = ((PreparedStatement)st).execute();
					}
				}
				else {
					st = connection.createStatement();
					session.setAttribute("currentStatement", st);
					isResultSet = st.execute(currentQuery);
				}

				executionTime = System.currentTimeMillis() - executionTime;

				if (isResultSet) {
%>
<TABLE width="100%" border="1">
<TR>
<%
					resultSet = st.getResultSet();
					session.setAttribute("currentResultSet", resultSet);
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
					if (!resultSet.isAfterLast()) {
						while (resultSet.next()) {
							rowCount++;
							out.println ("<TR>");
							for (int i=1 ; i<=columnCount ; ++i) {
								out.println ("<TD>");
								String value = resultSet.getString(i);
								if (value != null) {
									value = replace (value, "<", "&lt;");
									value = replace(value, ">", "&gt;");
									if (value.trim().equals ("")) {
										value ="&nbsp;";
									}
									//value = "-" + value + "-";

								}
								out.println (value);
								out.println ("</TD>");
							}
							out.println ("</TR>");
						}
					}
%>
</TABLE>

<br>
<i><b><%=rowCount%> row(s)</b></i>
<br>
<%
				}
				else {
%>
<br>
<i><b><%=st.getUpdateCount()%> row(s) updated</b></i>
<br>

<%
				}
%>
<i><b>Execution time : <%=executionTime%> ms</b></i>
<br>
<%
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
					st.close();
				} catch (Throwable t) {}
			}
		}

	}
	catch (Throwable t) {
		out.println ("<pre>");
		t.printStackTrace(new java.io.PrintWriter(out));
		out.println ("</pre>");
		return;
	}
	finally {
		try {
			connection.close();
		} catch (Throwable t) {}
		session.removeAttribute("currentStatement");
		session.removeAttribute("currentResultSet");
	}
}
%>


</BODY>
</HTML>
