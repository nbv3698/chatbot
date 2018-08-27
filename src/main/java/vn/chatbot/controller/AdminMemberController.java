package vn.chatbot.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import vn.chatbot.domain.Member;
import vn.chatbot.service.MemberServiceLocal;
import vn.chatbot.util.EmailUtil;
import vn.chatbot.util.NumberUtil;

@Controller
public class AdminMemberController extends BaseController {

	@Autowired
	private MemberServiceLocal memberService;
	
	@RequestMapping(value = "member/list")
	public String userList(String name, String email, Model model) {
		
		List<Member> memberList = memberService.filter(name, email);
		
		model.addAttribute("memberList", memberList);

		return "member/memberList";
	}
	
	@RequestMapping(value="member/send-active-code")
    public @ResponseBody 
    Map<String, Object> delete(Integer userId, HttpServletRequest request, HttpServletResponse response) {
		
		Member member = memberService.selectByPrimaryKey(userId);
		
		Map<String, Object> data = new HashMap<String, Object>();
		
		try {
			member.setActiveCode(String.format("%04d", NumberUtil.random(100, 9999)));
			memberService.updateByPrimaryKeySelective(member);
			EmailUtil.send(member.getEmail(), null, "[Chatbot] Active code", "<div>Your active code: " + member.getActiveCode() + "</div>", null);
			
			data.put("status", 	"success");
			
		} catch(Exception ex) {
			data.put("status", "failed");
		}
		
		return data;
	}
}
