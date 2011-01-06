<%@ page
language="java"
contentType="text/csv; charset=ISO-8859-1"
pageEncoding="ISO-8859-1"
isErrorPage="false"
errorPage="/erreur.jsp"
import="java.sql.*"

%><%
response.setHeader("Content-Disposition", "attachment; filename=export.csv");


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
}

if (!query.equals("")) {

	Connection connection = null;
	String currentQuery = null;
	int queryIndexStart = 0;
	int queryIndexEnd = 0;
	Statement st = null;
	ResultSet resultSet = null;
	int updateCount = -1;
	long executionTime;

	try {
		connection = jdbcwebclient.ConnectionFactory.getInstance().getConnection(request);

		// EXECUTION DE LA REQUETE
		currentQuery = query;

		if (currentQuery.startsWith ("exec ")) {
			st = connection.prepareStatement(currentQuery);
			((PreparedStatement)st).executeQuery();
		}
		else {
			st = connection.createStatement();
			st.execute(currentQuery);
		}

		// LIGNE D''ENTETE
		resultSet = st.getResultSet();
		int columnCount = resultSet.getMetaData().getColumnCount();
		for (int i=1 ; i<=columnCount ; ++i) {
			out.print (resultSet.getMetaData().getColumnName(i));
			if (i < columnCount) {
				out.print (";");
			}
		}
		out.println();

		// LIGNES DE DONNEES
		int rowCount = 0;
		if (!resultSet.isAfterLast()) {
			while (resultSet.next()) {
				rowCount++;
				for (int i=1 ; i<=columnCount ; ++i) {
					String value = resultSet.getString(i);
					out.print (value);
					if (i < columnCount) {
						out.print (";");
					}
				}
				out.println ();
			}
		}
	}
	catch (Throwable t) {
		t.printStackTrace(new java.io.PrintWriter(out));
		return;
	}
	finally {
		try {
			resultSet.close();
		} catch (Throwable t) {}
		try {
			st.close();
		} catch (Throwable t) {}
		try {
			connection.close();
		} catch (Throwable t) {}
	}
}
%>