package vn.chatbot.service;

import org.springframework.beans.factory.annotation.Autowired;

import vn.chatbot.dao.SessionLogMapper;
import vn.chatbot.domain.SessionLog;

public class SessionLogService implements SessionLogServiceLocal {

	@Autowired
	private SessionLogMapper sessionLogMapper;
	
	@Override
	public void insertSelective(SessionLog sessionLog) {
		
		sessionLogMapper.insertSelective(sessionLog);
	}

}
