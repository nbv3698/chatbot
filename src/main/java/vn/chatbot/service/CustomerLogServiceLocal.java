package vn.chatbot.service;

import vn.chatbot.domain.CustomerLog;

public interface CustomerLogServiceLocal {

	void insertSelective(CustomerLog customerLog);

}
