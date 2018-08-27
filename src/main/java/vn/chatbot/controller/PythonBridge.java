package vn.chatbot.controller;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;

import org.json.JSONArray;
import org.json.JSONObject;

public class PythonBridge {

	
	
	
	public static void main(String[] args) throws IOException {
		String urlRest = "http://localhost:8080/get_answers/";
		String query = "1";
		try {
			String question = "Hello";
			urlRest += question;
			URL url = new URL(urlRest);
			HttpURLConnection conn = (HttpURLConnection) url.openConnection();
			conn.setRequestMethod("GET");
			conn.setRequestProperty("Accept", "application/json");

			if (conn.getResponseCode() != 200) {
				throw new RuntimeException("Failed : HTTP error code : " + conn.getResponseCode());
			}

			BufferedReader br = new BufferedReader(new InputStreamReader((conn.getInputStream())));

			String output;
			System.out.println("Output from Server .... \n");
			while ((output = br.readLine()) != null) {
				//System.out.println(output);
				JSONObject jsonObject = new JSONObject(output);
				JSONObject jsonObjectResponse = jsonObject.getJSONObject("response");
				
				JSONArray jsonArr = jsonObjectResponse.getJSONArray("docs");
				//System.out.println(jsonArr);
				
				for(int i=0; i<jsonArr.length(); i++){
					System.out.println(jsonArr.get(i));
					jsonObject = new JSONObject(jsonArr.get(i).toString());
					String ques = jsonObject.get("question").toString();
					System.out.println("question: " + ques);
					System.out.println("answer: " + jsonObject.get("answer"));
					System.out.println("id: " + jsonObject.get("question"));
					System.out.println("_version_: " + jsonObject.get("_version_"));
					System.out.println("answerScore: " + jsonObject.get("answerScore"));
					
					
					
				}
			}

			conn.disconnect();

		} catch (

		MalformedURLException e) {

			e.printStackTrace();

		} catch (IOException e) {

			e.printStackTrace();

		}
	}

}
