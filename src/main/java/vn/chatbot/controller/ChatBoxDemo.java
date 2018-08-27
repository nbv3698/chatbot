package vn.chatbot.controller;

import java.awt.print.Printable;
import java.util.ArrayList;
import java.util.Iterator;

import org.apache.solr.client.solrj.SolrQuery;
import org.apache.solr.client.solrj.SolrServerException;
import org.apache.solr.client.solrj.impl.HttpSolrServer;
import org.apache.solr.client.solrj.impl.XMLResponseParser;
import org.apache.solr.client.solrj.response.QueryResponse;
import org.apache.solr.common.SolrDocument;
import javafx.util.*;


public class ChatBoxDemo {
	
	public static ArrayList<Conver> query(String q)
	{
		String url = "http://localhost:8983/solr/qnap_ir_test3";
		HttpSolrServer server = new HttpSolrServer(url);
		server.setMaxRetries(1); // defaults to 0. > 1 not recommended.
		server.setConnectionTimeout(5000); // 5 seconds to establish TCP
		
		// Setting the XML response parser is only required for cross
		// version compatibility and only when one side is 1.4.1 or
		// earlier and the other side is 3.1 or later.
		server.setParser(new XMLResponseParser()); // binary parser is used by
													// default
		// The following settings are provided here for completeness.
		// They will not normally be required, and should only be used
		// after consulting javadocs to know whether they are truly required.
		server.setSoTimeout(1000); // socket read timeout
		server.setDefaultMaxConnectionsPerHost(100);
		server.setMaxTotalConnections(100);
		server.setFollowRedirects(false); // defaults to false
		// allowCompression defaults to false.
		// Server side must support gzip or deflate for this to have any effect.
		server.setAllowCompression(true);
		String question = q.replace(" ", "+");
		question = question.replace("?", "\\?");
		question = question.replace(",", "\\,");
		question = question.replace("(", "\\(");
		question = question.replace(")", "\\)");
		System.out.println(question);
		SolrQuery query = new SolrQuery();
		query.setQuery("chat_q:" + question);
		SolrDocument resultDoc;
		
		ArrayList<Conver> conver = new ArrayList<>();
		
		
		int t = 0;
		// query.addSortField( "price", SolrQuery.ORDER.asc );
		try {
			QueryResponse queryResponse = server.query(query);
			Iterator<SolrDocument> iter = queryResponse.getResults().iterator();

			while (iter.hasNext()) {
				
				resultDoc = iter.next();
				System.out.println(resultDoc);
				Conver con = new Conver();
				String chat_q = (String) resultDoc.getFieldValue("chat_q");
				String chat_a = (String) resultDoc.getFieldValue("chat_a");
				String id = (String) resultDoc.getFieldValue("id"); // id is the
																	// uniqueKey
																	// field
				System.out.println("[ id= " + id + " , chat_q= " + chat_q + " ]");
				System.out.println("[ id= " + id + " , chat_a= " + chat_a + " ]");
				
				con.setQuestion(chat_q);
				con.setAnswer(chat_a);
				conver.add(con);
			}
		} catch (SolrServerException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return conver;
	}
}
