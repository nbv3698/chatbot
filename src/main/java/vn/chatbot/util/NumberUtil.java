package vn.chatbot.util;

import java.util.Random;

public class NumberUtil {

	public static int random(int low, int high) {
		
		Random r = new Random();
		int result = r.nextInt(high-low) + low;
		
		return result;
	}
}
