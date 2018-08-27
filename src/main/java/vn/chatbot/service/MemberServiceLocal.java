package vn.chatbot.service;

import java.util.List;

import vn.chatbot.domain.Member;

public interface MemberServiceLocal {

	Member getMemberByName(String username);

	void insertSelective(Member member);

	Member selectByPrimaryKey(Integer userId);

	void updateByPrimaryKeySelective(Member member);

	Member getMemberByEmail(String email);

	List<Member> filter(String name, String email);

}
