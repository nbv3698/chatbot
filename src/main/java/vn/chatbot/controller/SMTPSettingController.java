package vn.chatbot.controller;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.util.Locale;

import org.json.JSONObject;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.Resource;
import org.springframework.core.io.ResourceLoader;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
public class SMTPSettingController{
	@Autowired
	private ResourceLoader loader;
	public static JSONObject SMTPJSONObject;
	
	//Show the SMTP setting page 
    @RequestMapping(value = "smtp/SMTPSetting", method = RequestMethod.GET)
    public String showSMTPSettingPage(Locale locale, Model model) {	
        return"smtp/SMTPSetting";
    }
    
    public static JSONObject readSMTPSettingFile(){
    	return SMTPJSONObject;
    }
    
    //read file    
    @RequestMapping(value = "smtp/getSMTPJosnString", method = RequestMethod.GET)
    public @ResponseBody
    String getSMTPSetting() {   	
    	Resource resource = loader.getResource("classpath:");
    	  
    	BufferedReader reader = null;
    	
    	String SMTPJosnString = "";
    	JSONObject SMTPJSONObject = new JSONObject();	
        
        String line = "";
        String path = "";    

        try {
        	path = resource.getFile().getPath()+"/static/SMTPsetting.txt";
        	//System.out.println("讀檔路徑："+path);
        	//Check weather file exist
        	if(new File(path).exists()){   //read file        	
            	reader = new BufferedReader(new InputStreamReader(new FileInputStream(path)));
            	while ((line = reader.readLine()) != null) {
            		//System.out.println("讀檔內容："+line);
            		SMTPJosnString += line;   			
            	}
            	reader.close();
        	}
        	else{	//create new file
        		try{   
        			File file = new File(path);
    				File parentFile = file.getParentFile();
        			if (file.getParentFile() != null) {
    					parentFile.mkdirs();
    				}
        			file.createNewFile();
        			//System.out.println("建立新檔:");
        			//System.out.println("新檔路徑:"+path);
        			
        			//generate Default setting
        			SMTPJSONObject.put("host", "smtp.gmail.com");
        	    	SMTPJSONObject.put("auth", "true");
        	    	SMTPJSONObject.put("port", "465");
        	    	SMTPJSONObject.put("user", "chatbot.api.active@gmail.com");
        	    	SMTPJSONObject.put("pass", "conga@123");
        	    	SMTPJSONObject.put("protocol", "smtps");
        	    	SMTPJSONObject.put("starttls", "true");
        	    	SMTPJSONObject.put("debug", "true");
        	        SMTPJosnString = SMTPJSONObject.toString();
        			
        	        //write text to file
        			BufferedWriter bufWriter = new BufferedWriter(new OutputStreamWriter(new FileOutputStream(file),"utf8"));
                    bufWriter.write(SMTPJosnString);
                    bufWriter.close();
        			
        		}catch(IOException e){
        			//System.out.println("建立新檔失敗");
        			e.printStackTrace();
        		}
        	}
        }catch (IOException e) {
        	//System.out.println("取得讀檔路徑失敗");
        	e.printStackTrace();
        }finally{
        	if(reader!=null){
            	try {
					reader.close();
				} catch (IOException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}

        	}
        }
        
        //System.out.println("檔案內容：");
		//System.out.println(SMTPJosnString);
		//convert text to JSONObject
		SMTPJSONObject = new JSONObject(SMTPJosnString);
		
		SMTPJosnString = SMTPJSONObject.toString();
		System.out.println("SMTPJosnString :");
		System.out.println(SMTPJosnString);
		
		this.SMTPJSONObject = SMTPJSONObject;
        return SMTPJosnString;
    }
    
    //save the change to text file
    @RequestMapping(value = "smtp/editSMTP", method = RequestMethod.POST,produces = MediaType.APPLICATION_JSON_VALUE)
    public @ResponseBody void editSMTP(
    		@RequestParam("host") String host, 
    		@RequestParam("auth") String auth, 
    		@RequestParam("port") String port, 
    		@RequestParam("user") String user, 
    		@RequestParam("pass") String pass, 
    		@RequestParam("protocol") String protocol, 
    		@RequestParam("starttls") String starttls, 
    		@RequestParam("debug") String debug) {
    	Resource resource = loader.getResource("classpath:/static/SMTPsetting.txt");
    	try {
			
			String SMTPJosnString = "";
	    	JSONObject SMTPJSONObject = new JSONObject();
			SMTPJSONObject.put("host", host);
	    	SMTPJSONObject.put("auth", auth);
	    	SMTPJSONObject.put("port", port);
	    	SMTPJSONObject.put("user", user);
	    	SMTPJSONObject.put("pass", pass);
	    	SMTPJSONObject.put("protocol", protocol);
	    	SMTPJSONObject.put("starttls", starttls);
	    	SMTPJSONObject.put("debug", debug);
	        SMTPJosnString = SMTPJSONObject.toString();
			
	        File file = resource.getFile();
			//System.out.println("儲存檔案路徑："+file.getPath());
			BufferedWriter bufWriter = new BufferedWriter(new OutputStreamWriter(new FileOutputStream(file,false),"utf8"));
            bufWriter.write(SMTPJosnString);
            bufWriter.close();
		} catch (IOException e) {
			//System.out.println("儲存檔案失敗");
			e.printStackTrace();
		}
    }
}