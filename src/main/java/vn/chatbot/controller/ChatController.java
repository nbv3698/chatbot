package vn.chatbot.controller;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.ArrayList;
import java.util.Date;
import java.util.Hashtable;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.apache.solr.client.solrj.SolrServer;
import org.apache.solr.client.solrj.SolrServerException;
import org.apache.solr.client.solrj.impl.HttpSolrServer;
import org.apache.solr.client.solrj.response.UpdateResponse;
import org.apache.solr.common.SolrInputDocument;
import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.context.request.RequestContextHolder;

import vn.chatbot.domain.CustomerLog;
import vn.chatbot.domain.Message;
import vn.chatbot.domain.QaPair;
import vn.chatbot.domain.QaSolr;
import vn.chatbot.service.CustomerLogServiceLocal;
import vn.chatbot.service.QaPairServiceLocal;
import vn.chatbot.service.QaSolrServiceLocal;


@Controller
@RequestMapping(value = "chat")
public class ChatController {

	@Autowired
	private CustomerLogServiceLocal customerLogService;
	
	@Autowired
	private QaPairServiceLocal qaPairService;
	
	@Autowired
	private QaSolrServiceLocal qaSolrService;
	
	private List<Message> messages = new ArrayList<Message>();
	private String urlSolrServer = "http://localhost:8983/solr/qnap_ir_test3";
	/**
	 * submit a question
	 * 
	 * @param question
	 * @param model
	 * @param request
	 * @return
	 */
	@RequestMapping(value = "ask")
	public @ResponseBody List<Message> ask(String question, Model model, HttpServletRequest request) {
		// Call Solr from Python through Restfull Service

		String[] arrPort = new String[] { "8085", "8089" };
//	    	String[] arrPort = new String[] { "8089" };
		String urlRest = "http://localhost:{port}/get_answers?question={question}&number={number}";
		String query = "1";
		ArrayList<Conver> lstConvert = new ArrayList<Conver>();
		URL url = null;
		int number = 2;
		int temp = 0;
		try {
			for (String port : arrPort) {
				String urlRequest = urlRest.replace("{port}", port);
				System.out.println("===> Try connect to host: " + urlRequest);
				// String question = "Hello";
				urlRequest = urlRequest.replace("{question}", question);
				urlRequest = urlRequest.replace("{number}", String.valueOf(number));
				url = new URL(urlRequest.trim().replaceAll(" ", "%20"));
				HttpURLConnection conn = (HttpURLConnection) url.openConnection();
				conn.setRequestMethod("GET");
				conn.setRequestProperty("Accept", "application/json");

				if (conn!=null && conn.getResponseCode() != 200) {
					//throw new RuntimeException("Failed : HTTP error code : " + conn.getResponseCode());
					number = 5;
					continue;
				}else {
				    System.out.println("Not connected to host by port: " + port);
				}

				BufferedReader br = new BufferedReader(new InputStreamReader((conn.getInputStream())));
				String output = br.readLine();
				System.out.println("Python:  " + port + " --> " + output);
//				JSONObject jsonObject = new JSONObject(output);
//				JSONObject jsonObjectResponse = jsonObject.getJSONObject("response");
				
				JSONArray jsonArr = new JSONArray(output);

				for (int i = 0; i < jsonArr.length(); i++) {
					// System.out.println(jsonArr.get(i));
					JSONObject jsonObject = new JSONObject(jsonArr.get(i).toString());
					String idSolr = jsonObject.get("idSolr").toString();
					String ques = jsonObject.get("question").toString();
					String answer = jsonObject.get("answer").toString();
					System.out.println("question: " + ques);
					System.out.println("answer: " + answer);
					if(answer.equalsIgnoreCase("We can't answer the question."))
						temp++;
					Conver cv = new Conver();
					cv.setIdSolr(idSolr);
					cv.setQuestion(ques);
					cv.setAnswer(answer);
					lstConvert.add(cv);
				}
				number = 5 - jsonArr.length() + temp;
				conn.disconnect();
				br.close();
			}
			
			messages = new ArrayList<Message>();
			if (messages.size() == 0) {
				createMessages(lstConvert);
			}
		} catch (MalformedURLException e) {
		    System.out.println("Error " + e.getMessage());
		    e.printStackTrace();

		} catch (IOException e) {
		    System.out.println("Error " + e.getMessage());
			e.printStackTrace();

		}finally {
			
		}

		// Call Solr from Java
		// try {
		//
		// // TODO Auto-generated catch block
		// ChatBoxDemo chat = new ChatBoxDemo();
		// ArrayList<Conver> con = chat.query(question);
		//
		// messages = new ArrayList<Message>();
		// if (messages.size() == 0) {
		// createMessages(con);
		// }
		//
		// } catch (Exception e) {
		// e.printStackTrace();
		// }

		return messages;
	}

	/**
	 * modify element in list
	 * 
	 * @param id
	 * @param answer
	 * @param model
	 * @param request
	 * @return
	 * @throws IOException 
	 * @throws SolrServerException 
	 */
	@RequestMapping(value = "modify")
	public @ResponseBody int modify(int id, String question,String orgquestion, String organswer, String answer, Model model,
			HttpServletRequest request) throws SolrServerException, IOException {
		System.out.println("orgquestion:");
		System.out.println(orgquestion);
		System.out.println("question:");
		System.out.println(question);
		System.out.println("organswer:");
		System.out.println(organswer);
		System.out.println("answer:");
		System.out.println(answer);
		Message message;
		if(id > 0) {
			for (int i = 0; i <= messages.size(); i++) {

				message = messages.get(i);
				if (message.getId() == id) {
					message.setAnswer(answer);
					messages.set(i, message);
					break;
				}
			}
		}

		// insert question into customer_log
		CustomerLog customerLog = new CustomerLog();
		customerLog.setSessionId(RequestContextHolder.getRequestAttributes().getSessionId());
		customerLog.setTimestamp(new Date());
		customerLog.setQuestion(question);
		customerLog.setOrganswer(organswer);
		customerLog.setAnswer(answer);
		customerLogService.insertSelective(customerLog);
		
			// import to Solr
		SolrServer server = new HttpSolrServer(urlSolrServer);
	        SolrInputDocument doc = new SolrInputDocument();
	        if(id==0) 
	        {
	        	doc.addField("chat_q", question);
		        doc.addField("chat_a", answer);
		        doc.addField("org_q", question);
		        doc.addField("org_a", answer);
		        String idSolr = java.util.UUID.randomUUID().toString();
		        doc.addField("id", idSolr);
		        server.add(doc);
		        UpdateResponse updateResponse = server.commit();
		        System.out.println(updateResponse.getStatus());	
	        }
	        else if((organswer!=null && answer!=null &&  orgquestion!=null && question!=null))  {
	        	//原本的答案跟輸入的答案不一樣 或 原本的問題跟輸入的問題不一樣 就 更新solr
	        	if (!organswer.trim().equalsIgnoreCase(answer.trim()) || !orgquestion.trim().equalsIgnoreCase(question) )
	        	{
		        	doc.addField("chat_q", question);
			        doc.addField("chat_a", answer);
			        doc.addField("org_q", question);
			        doc.addField("org_a", answer);
			        server.add(doc);
			        UpdateResponse updateResponse = server.commit();
			        System.out.println(updateResponse.getStatus());	
	        	}
	        }
	        else if ((question != null && answer != null && question != orgquestion && answer != organswer))
	        {
	        	doc.addField("chat_q", question);
		        doc.addField("chat_a", answer);
		        doc.addField("org_q", question);
		        doc.addField("org_a", answer);		        
		        server.add(doc);
		        UpdateResponse updateResponse = server.commit();
		        System.out.println(updateResponse.getStatus());	
	        }
        
		return 1;
	}

	
	@RequestMapping(value = "updateModifyCount")
	public @ResponseBody int updateModifyCount(int id, Model model, HttpServletRequest request) {
		String sessionId = RequestContextHolder.getRequestAttributes().getSessionId();
		String idSolr = "";
		
		Message message;
		for (int i = 0; i <= messages.size(); i++) {
			message = messages.get(i);
			if (message.getId() == id) {
				idSolr = message.getIdSolr();
				break;
			}
		}
		System.out.println(sessionId);
		System.out.println(idSolr);
		QaPair qa = qaPairService.selectByIdSolr(idSolr);
		if(qa==null){
			qa = new QaPair();
			qa.setIdsolr(idSolr);
			qa.setSessionid(sessionId);
			qa.setCountmod(1);
			qa.setCountdel(0);
			qaPairService.insertSelective(qa);
		}else{
			qa.setCountmod(qa.getCountmod() + 1);
			qa.setSessionid(sessionId);
			qa.setIdsolr(idSolr);
			qaPairService.updateByPrimaryKeySelective(qa);
		}
		
		return 1;
	}
	
	
	/**
	 * remove element in list
	 * 
	 * @param id
	 * @param model
	 * @param request
	 * @return
	 */
	@RequestMapping(value = "remove")
	public @ResponseBody int remove(int id, Model model, HttpServletRequest request) {

		String sessionId = RequestContextHolder.getRequestAttributes().getSessionId();
		String idSolr = "";
		String question = "";
		String answer = "";
		Message message;
		for (int i = 0; i <= messages.size(); i++) {
			message = messages.get(i);
			if (message.getId() == id) {
				idSolr = message.getIdSolr();
				question = message.getQuestion();
				answer = message.getAnswer();
				break;
			}
		}
		System.out.println(sessionId);
		System.out.println(idSolr);
		QaPair qa = qaPairService.selectByIdSolr(idSolr);
		if(qa==null){
			qa = new QaPair();
			qa.setIdsolr(idSolr);
			qa.setSessionid(sessionId);
			qa.setCountmod(0);
			qa.setCountdel(1);
			qaPairService.insertSelective(qa);
		}else{
			if(qa.getCountdel() >= 3) {
				QaSolr qaSolr = new QaSolr();
				qaSolr.setQuestion(question);
				qaSolr.setAnswer(answer);
				qaSolrService.insertQaSolr(qaSolr);
				//Remove question out of Solr
				SolrServer server = new HttpSolrServer(urlSolrServer);
				try {
					System.out.println("Remove Question out of Solr: (id = " + idSolr + " )");
					server.deleteById(idSolr);
					server.commit();
				} catch (SolrServerException | IOException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}else {
				qa.setCountdel(qa.getCountdel()+1);
				qa.setSessionid(sessionId);
				qa.setIdsolr(idSolr);
				qaPairService.updateByPrimaryKeySelective(qa);
			}
		}
		
		return 1;
	}

	/**
	 * init messages result
	 */
	private void createMessages(ArrayList<Conver> con) {

		Message message = new Message();

		for (int k = 0; k < con.size(); k++) {
			if(con.get(k).getAnswer().equalsIgnoreCase("We can't answer the question.")) {
				continue;
			}
			message = new Message();
			message.setId(k);
			message.setIdSolr(con.get(k).getIdSolr());
			message.setQuestion(con.get(k).getQuestion());
			message.setAnswer(con.get(k).getAnswer());
			messages.add(message);
		}
	}
}
