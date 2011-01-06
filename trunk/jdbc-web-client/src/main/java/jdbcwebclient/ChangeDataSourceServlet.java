package jdbcwebclient;

import java.io.IOException;

import javax.naming.NamingException;
import javax.servlet.Servlet;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * @version 	1.0
 * @author
 */
public class ChangeDataSourceServlet extends HttpServlet implements Servlet {

	private static final long serialVersionUID = 1L;

	public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		try {
			String dataSourceName = request.getParameter("dataSourceName");
			String previousPage = request.getParameter("previousPage");
			
			ConnectionFactory.getInstance().changeDataSource(request, dataSourceName);
			
			response.sendRedirect(previousPage);
		}
		catch (NamingException e) {
			throw new ServletException (e.getMessage(), e);
		}
	}

	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doGet(request, response);
	}

}
