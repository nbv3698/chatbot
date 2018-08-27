package vn.chatbot.util;

import java.io.IOException;
import java.io.PrintWriter;
import java.io.StringWriter;

public class StringUtil {

	public static boolean compareValue(Double value1, String compare, Double value2) {
		
		if (compare == null || value1 == null || value2 == null) {
			return false;
		}
		
		if (compare.equals(">") && value1 > value2)
			return true;
		
		if (compare.equals(">=") && value1 >= value2)
			return true;
		
		if (compare.equals("<") && value1 < value2)
			return true;
		
		if (compare.equals("<=") && value1 <= value2)
			return true;
		
		if ((compare.equals("=") || compare.equals("==")) && value1 == value2)
			return true;
		
		return false;
	}
	
	public static String exceptionToString(Exception e) {

		StringWriter sw = new StringWriter();
		e.printStackTrace(new PrintWriter(sw));
		String logMsg = sw.toString();

		try {
			sw.close();
		} catch (IOException e1) {
		}

		return logMsg;
	}
}
