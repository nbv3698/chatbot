package vn.chatbot.service;

import vn.chatbot.domain.SessionLog;

public interface SessionLogServiceLocal {

	void insertSelective(SessionLog sessionLog);

}
