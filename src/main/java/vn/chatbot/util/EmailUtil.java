package vn.chatbot.util;

import java.util.List;
import java.util.Properties;

import javax.activation.DataHandler;
import javax.activation.FileDataSource;
import javax.mail.Message.RecipientType;
import javax.mail.MessagingException;
import javax.mail.Multipart;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.AddressException;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeBodyPart;
import javax.mail.internet.MimeMessage;
import javax.mail.internet.MimeMultipart;

import org.json.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import vn.chatbot.controller.SMTPSettingController;

public class EmailUtil {

	private static Logger logger = LoggerFactory.getLogger(EmailUtil.class.getName());
	
	/**
	 * send email
	 * 
	 * @return
	 */
	public static String send(Properties props, String to, String cc, String subject, String text,
			List<String> filePath) {

		String host = props.getProperty("mail.smtp.host");
//		int port = Integer.parseInt(props.getProperty("mail.smtp.port"));

		final String user = props.getProperty("mail.smtp.user");
		final String pass = props.getProperty("mail.smtp.pass");

		Session session = null;
		Transport transport = null;

		if (session == null) {
			session = Session.getInstance(props, new javax.mail.Authenticator() {
				protected PasswordAuthentication getPasswordAuthentication() {
					return new PasswordAuthentication(user, pass);
				}
			});
		}

		if (transport == null || !transport.isConnected()) {
			try {
				transport = session.getTransport(props.getProperty("mail.transport.protocol"));
				
				
//				transport.connect(host, port, user, pass);
				transport.connect(host, user, pass);

			} catch (MessagingException e) {
				logger.warn("error send email", e);

				return StringUtil.exceptionToString(e);
			}
		}

		// get message content
		MimeMessage message = getMessage(session, user, to, cc, subject, text, filePath);

		try {
			transport.sendMessage(message, message.getAllRecipients());
		} catch (MessagingException e) {
			logger.warn("error send message", e);
			return StringUtil.exceptionToString(e);
		}

		try {
			transport.close();
		} catch (MessagingException e) {
			logger.warn("error close transport", e);

			return StringUtil.exceptionToString(e);
		}

		return null;
	}

	/**
	 * Get message
	 * 
	 * @param from
	 * @param to
	 * @param cc
	 * @param subject
	 * @param text
	 * @return
	 */
	private static MimeMessage getMessage(Session session, String from, String to, String cc, String subject,
			String text, List<String> filePath) {

		try {
			InternetAddress fromAddress = null;

			MimeMessage message = new MimeMessage(session);

			try {
				fromAddress = new InternetAddress(from);
			} catch (AddressException e) {
				logger.warn("error parse from addresses", e);

				return null;
			}

			message.setHeader("Content-Type", "text/plain; charset=UTF-8"); // set message
			message.setFrom(fromAddress);

			// recipient type to
			if (to.indexOf(',') > 0) {
				message.setRecipients(RecipientType.TO, InternetAddress.parse(to));
			} else {
				message.setRecipient(RecipientType.TO, new InternetAddress(to));
			}

			// recipient type cc
			if (cc != null && !cc.equals("")) {
				if (cc.indexOf(',') > 0) {
					message.setRecipients(RecipientType.CC, InternetAddress.parse(cc));
				} else {
					message.setRecipient(RecipientType.CC, new InternetAddress(cc));
				}
			}

			// Set the email message text.
			message.setSubject(subject, "UTF-8");

			MimeBodyPart messagePart = new MimeBodyPart();
			messagePart.setHeader("Content-Type", "text/plain; charset=UTF-8");
			messagePart.setContent(text, "text/html; charset=utf-8");

			// Set the email attachment file
			Multipart multipart = new MimeMultipart();
			multipart.addBodyPart(messagePart);

			try {
				if (filePath != null) {
					for (String itemFile : filePath) {
						MimeBodyPart attachmentPart = new MimeBodyPart();
						FileDataSource fileDataSource = new FileDataSource(itemFile) {
							@Override
							public String getContentType() {
								return "application/octet-stream";
							}
						};
	
						// check exists file
						if (fileDataSource.getFile().exists()) {
							attachmentPart.setDataHandler(new DataHandler(fileDataSource));
							attachmentPart.setFileName(fileDataSource.getName());
	
							multipart.addBodyPart(attachmentPart);
						}
					}
				}
			} catch (Exception ex) {
				logger.warn("error file attach", ex);
			}

			message.setContent(multipart);

			return message;

		} catch (MessagingException e) {
			logger.warn("error", e.toString());

			return null;
		}
	}
	//要擴充	
	public static String send(String to, String cc, String subject, String text,
			List<String> filePath) {
		//read SMTP Setting from file
		JSONObject SMTPJSONObject = SMTPSettingController.readSMTPSettingFile();
		if(SMTPJSONObject==null){
			System.out.println("傳送前讀取檔案失敗");
		}
		else{
			System.out.println("傳送前讀取檔案成功");
			System.out.println(SMTPJSONObject.get("host"));
		}
		
		Properties properties = new Properties();
		//設定mail Server
		properties.put("mail.smtp.host", 				SMTPJSONObject.get("host"));	//yahoo:"smtp.mail.yahoo.com" //outlook:"smtp-mail.outlook.com"
		properties.put("mail.smtp.port", 				SMTPJSONObject.get("port"));
		properties.put("mail.smtp.auth", 				SMTPJSONObject.get("auth"));	//需要驗證帳號密碼
		properties.put("mail.smtp.user", 				SMTPJSONObject.get("user"));	//寄件者信箱
		properties.put("mail.smtp.pass", 				SMTPJSONObject.get("pass"));	//寄件者密碼？
		properties.put("mail.transport.protocol", 		SMTPJSONObject.get("protocol"));//傳輸協定為smtp
		properties.put("mail.smtp.starttls.enable", 	SMTPJSONObject.get("starttls"));//
		properties.put("mail.debug", 					SMTPJSONObject.get("debug"));	//測試用
			
		/*
		properties.put("mail.smtp.host", 				"smtp.gmail.com");
		properties.put("mail.smtp.port", 				"465");
		properties.put("mail.smtp.auth", 				"true");
		properties.put("mail.smtp.user", 				"chatbot.api.active@gmail.com");
		properties.put("mail.smtp.pass", 				"conga@123");
		properties.put("mail.transport.protocol", 		"smtps");
		properties.put("mail.smtp.starttls.enable", 	"true");
		properties.put("mail.debug", 					"true");
		*/
//		properties.put("mail.smtp.socketFactory.class", "javax.net.ssl.SSLSocketFactory");
		
		return send(properties, to, cc, subject, text, filePath);
	}
}
