/*
 * Créé le 15 juil. 05
 *
 * Pour changer le modèle de ce fichier généré, allez à :
 * Fenêtre&gt;Préférences&gt;Java&gt;Génération de code&gt;Code et commentaires
 */
package jdbcwebclient;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.Map;
import java.util.TreeMap;

import javax.naming.Binding;
import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingEnumeration;
import javax.naming.NamingException;
import javax.naming.Reference;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import javax.sql.DataSource;

/**
 * @author baligand
 *
 */
public class ConnectionFactory {
	
	private static ConnectionFactory sInstance = null;
	
	private Map mDatasources = new TreeMap();
	private Map mDatasourceSchemas = new TreeMap();
	private String mDefaultDataSourceName = null;
	
	private void initDataSources(Context context, String prefix) throws NamingException {
		NamingEnumeration names = context.listBindings("");
		while (names.hasMoreElements()) {
			Binding binding = (Binding) names.nextElement();
			if (binding.getObject() instanceof Context) {
				Context newContext = (Context)binding.getObject();
				String newPrefix = prefix.concat(binding.getName()).concat("/");
				initDataSources (newContext, newPrefix);
			}
			else if (binding.getObject() instanceof DataSource) {
				String key = prefix.concat(binding.getName());
				DataSource dataSource = (DataSource)binding.getObject();
				mDatasources.put(key, dataSource);
				defineDataSourceSchema(key);
			}
			else if (binding.getObject() instanceof Reference) { 
				Object bindingObject = context.lookup(binding.getName());
				if (bindingObject instanceof DataSource) {
					String key = prefix.concat(binding.getName());
					mDatasources.put(key, bindingObject);
					defineDataSourceSchema(key);
				}
			}
		}
		names.close();
	}
	
	private ConnectionFactory () throws NamingException {
		
		InitialContext initialContext = new InitialContext();
		Context jdbcContext = (Context) initialContext.lookup("java:comp/env/jdbc");
		initDataSources (jdbcContext, "");
		mDefaultDataSourceName = getDataSourceNamesList()[0];
	}
	
	public static ConnectionFactory getInstance() throws NamingException {
		if (sInstance == null)  {
			synchronized (ConnectionFactory.class) {
				if (sInstance == null)  {
					sInstance = new ConnectionFactory();
				}
			}
		}
		return sInstance;
	}
	
	public Connection getConnection (HttpServletRequest request) throws SQLException {
		String currentDatasourceName = getCurrentDataSourceName(request);
		DataSource dataSource = (DataSource) mDatasources.get(currentDatasourceName);
		return dataSource.getConnection();
	}
	
	public String getDataSourceSchema (HttpServletRequest request) throws SQLException {
		String currentDatasourceName = getCurrentDataSourceName(request);
		String dataSourceSchema = (String) mDatasourceSchemas.get(currentDatasourceName);
		return dataSourceSchema;
	}
	
	public String[] getDataSourceNamesList() {
		String[] dataSourceNamesList = new String[mDatasources.size()];
		mDatasources.keySet().toArray(dataSourceNamesList);
		return dataSourceNamesList;
	}

	public String getCurrentDataSourceName(HttpServletRequest request) {
		String currentDatasourceName = null;
		HttpSession session = request.getSession(false);
		if (session != null) {
			currentDatasourceName = (String) session.getAttribute("datasourceName");
		}
		if (currentDatasourceName == null) {
			currentDatasourceName = mDefaultDataSourceName;
		}
		return currentDatasourceName;
	}
	
	public boolean isSybaseDataSource(HttpServletRequest request) {
		Connection connection = null;
		try {
			connection = getConnection(request);
			return isSybaseConnection(connection);
		}
		catch (SQLException e) {
			return false;
		}
		finally {
			try {
				if (connection != null) {
					connection.close();
				}
			}
			catch (SQLException e) {}
		}
	}
	
	public boolean isSybaseConnection(Connection connection) {
		return (connection.getClass().getName().indexOf("sybase") != -1);
	}
	
	void changeDataSource(HttpServletRequest request, String newDataSourceName) {
		HttpSession session = request.getSession(true);
		session.setAttribute("datasourceName", newDataSourceName);
	}
	
	private void defineDataSourceSchema(String key) {
		String schema = null;
		try {
			InitialContext initialContext = new InitialContext();
			schema = (String) initialContext.lookup("java:comp/env/schema/" + key);
		}
		catch (NamingException e) {
			// pas de schéma associé
		}
		mDatasourceSchemas.put(key, schema);
	}
}
