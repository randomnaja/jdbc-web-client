<%@ page 
language="java"
contentType="text/html; charset=ISO-8859-1"
pageEncoding="ISO-8859-1"
isErrorPage="false"
errorPage="/erreur.jsp"
import="javax.naming.InitialContext,
		javax.sql.DataSource,
		java.sql.*,
		jdbcwebclient.ConnectionFactory"

%>

<SCRIPT language="javascript">
	function changeDataSource(newDataSourceName) {
		var previousPage = window.location.pathname + window.location.search;
		window.location = "changeDataSource?previousPage=" + previousPage + "&dataSourceName=" + newDataSourceName;
	}
</SCRIPT>
<TABLE align="right">
	<TR>
		<TD>
			<SELECT name="datasources" onchange="changeDataSource(this.options[this.selectedIndex].value)">
<%		
			jdbcwebclient.ConnectionFactory connectionFactory = jdbcwebclient.ConnectionFactory.getInstance();
			String[] dataSourcesNames = connectionFactory.getDataSourceNamesList();
			String currentDataSourceName = connectionFactory.getCurrentDataSourceName(request);
			for (int i=0 ; i<dataSourcesNames.length ; ++i) {
				String selected = dataSourcesNames[i].equals(currentDataSourceName) ? "selected" : "";
				out.print ("<OPTION value=\"" + dataSourcesNames[i] + "\" " + selected + ">");
				out.print (dataSourcesNames[i]);
				out.println ("</OPTION>");
			}
%>
			</SELECT>
		</TD>
		<TD><A href="sqlclient.jsp">Sql Client</A></TD>
		<TD><A href="tables.jsp">All Tables</A></TD>
		<TD><A href="procedures.jsp">All Procedures</A></TD>
		<TD><A href="csvimport.jsp">CSV Import</A></TD>
	</TR>
</TABLE>
<BR clear="all">