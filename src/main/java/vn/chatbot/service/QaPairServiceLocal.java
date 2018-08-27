package vn.chatbot.service;

import vn.chatbot.domain.QaPair;

public interface QaPairServiceLocal {

	int deleteByPrimaryKey(Integer id);
	
	int insert(QaPair record);
	
	int insertSelective(QaPair record);
	
	QaPair selectByPrimaryKey(Integer id);
	QaPair selectByIdSolr(String idsolr);
	int updateByPrimaryKeySelective(QaPair record);
	
	int updateByPrimaryKey(QaPair record);
}
