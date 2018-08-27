package vn.chatbot.service;

import org.springframework.beans.factory.annotation.Autowired;
import vn.chatbot.dao.QaSolrMapper;
import vn.chatbot.domain.QaSolr;

public class QaSolrService implements QaSolrServiceLocal{
	@Autowired
	private QaSolrMapper qaSolrMapper;
	
	@Override
	public int insertQaSolr(QaSolr qaSolr) {
		return qaSolrMapper.insert(qaSolr);
	}
	
}
