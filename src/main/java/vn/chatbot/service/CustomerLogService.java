package vn.chatbot.service;

import org.springframework.beans.factory.annotation.Autowired;

import vn.chatbot.dao.CustomerLogMapper;
import vn.chatbot.domain.CustomerLog;

public class CustomerLogService implements CustomerLogServiceLocal {

	@Autowired
	private CustomerLogMapper customerLogMapper;
	
	@Override
	public void insertSelective(CustomerLog customerLog) {

		customerLogMapper.insertSelective(customerLog);
	}

}
