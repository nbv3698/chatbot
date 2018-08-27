package vn.chatbot.validator;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import javax.validation.ConstraintValidator;
import javax.validation.ConstraintValidatorContext;

import org.apache.log4j.Logger;

import vn.chatbot.util.DbUtil;

public class MemberExistsValidator implements ConstraintValidator<MemberExists, String> {
	
	private static Logger logger = Logger.getLogger(MemberExistsValidator.class);

	@Override
	public void initialize(MemberExists constraintAnnotation) {
	}
	
	@Override
	public boolean isValid(String value, ConstraintValidatorContext context) {
		
		if (value == null) {
			return false;
		}
		
		int rowCount = -1;
		try (Connection conn = DbUtil.getConnection();
				Statement stmt = conn.createStatement();
				ResultSet rs = stmt.executeQuery("SELECT COUNT(*) FROM member WHERE upper(email)='" + value.toUpperCase() + "'");) {
			rs.next();
			rowCount = rs.getInt(1);
		} catch (NullPointerException | SQLException e) {
			logger.error("isMemberExists error" + e.toString());
		}
		
		return rowCount>0?false:true;
	}
}
