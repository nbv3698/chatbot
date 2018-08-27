package vn.chatbot.util;

import java.sql.Connection;
import java.sql.SQLException;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class DbUtil {

	private static final Logger logger = LoggerFactory.getLogger(DbUtil.class);

	public static DataSource dataSource = null;

	static {
		try {
			Context initContext = new InitialContext();
			Context envContext = (Context) initContext.lookup("java:/comp/env");
			dataSource = (DataSource) envContext.lookup("jdbc/DS");

			logger.info("Init Datasource success.");
		} catch (NamingException e) {
			logger.error("Cannot init Datasource", e);
		}
	}

	public static Connection getConnection() throws SQLException {

		return dataSource.getConnection();
	}
}
