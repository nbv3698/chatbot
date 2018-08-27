package vn.chatbot.service;

import java.io.IOException;

import org.apache.http.client.ClientProtocolException;
import org.springframework.security.core.userdetails.UserDetails;

import vn.chatbot.domain.GooglePojo;

public interface GoogleAuthServiceLocal {

	public String getToken(final String code) throws ClientProtocolException, IOException;
	
	public GooglePojo getUserInfo(final String accessToken) throws ClientProtocolException, IOException;
	
	public UserDetails buildUser(GooglePojo googlePojo);
}
