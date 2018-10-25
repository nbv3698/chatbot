package vn.chatbot.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;

import vn.chatbot.dao.MemberMapper;
import vn.chatbot.domain.Member;

public class MemberService implements MemberServiceLocal {

	@Autowired
	private MemberMapper memberMapper;
	
	@Override
	public Member getMemberByName(String username) {
		
		return memberMapper.getMemberByName(username);
	}
	
	@Override
	public Member getMemberByEmail(String email) {
		
		return memberMapper.getMemberByEmail(email);
	}

	@Override
	public void insertSelective(Member member) {
		
		memberMapper.insertSelective(member);
	}

	@Override
	public Member selectByPrimaryKey(Integer userId) {
		
		return memberMapper.selectByPrimaryKey(userId);
	}

	@Override
	public void updateByPrimaryKeySelective(Member member) {
		
		memberMapper.updateByPrimaryKeySelective(member);
	}

	@Override
	public List<Member> filter(String name, String email) {
		
		Map<String, Object> parms = new HashMap<String, Object>();
		parms.put("name", 	name);
		parms.put("email", 	email);
		
		return memberMapper.filter(parms);
	}
	
	@Override
	public void updatePassword(Member member) {
		
		memberMapper.updatePassword(member);
	}

}
