package vn.chatbot.service;

import org.springframework.beans.factory.annotation.Autowired;

import vn.chatbot.dao.QaPairMapper;
import vn.chatbot.domain.QaPair;

public class QaPairService implements QaPairServiceLocal {

	@Autowired
	private QaPairMapper qaPairMapper;
	
	@Override
	public int deleteByPrimaryKey(Integer id) {
		
		return qaPairMapper.deleteByPrimaryKey(id);
	}

	@Override
	public int insert(QaPair record) {
		
		return qaPairMapper.insert(record);
	}

	@Override
	public int insertSelective(QaPair record) {
		
		return qaPairMapper.insertSelective(record);
	}

	@Override
	public QaPair selectByPrimaryKey(Integer id) {
		
		return qaPairMapper.selectByPrimaryKey(id);
	}
	
	@Override
	public QaPair selectByIdSolr(String idsolr){
		return qaPairMapper.selectByIdSolr(idsolr);
	}

	@Override
	public int updateByPrimaryKeySelective(QaPair record) {
		
		return qaPairMapper.updateByPrimaryKeySelective(record);
	}

	@Override
	public int updateByPrimaryKey(QaPair record) {
		
		return qaPairMapper.updateByPrimaryKey(record);
	}

}
