package vn.chatbot.controller;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStreamWriter;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.validation.Valid;

import org.apache.http.client.ClientProtocolException;
import org.json.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.Resource;
import org.springframework.http.MediaType;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.authentication.encoding.Md5PasswordEncoder;
import org.springframework.security.authentication.encoding.PasswordEncoder;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.web.authentication.WebAuthenticationDetailsSource;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import vn.chatbot.domain.GooglePojo;
import vn.chatbot.domain.Member;
import vn.chatbot.service.GoogleAuthServiceLocal;
import vn.chatbot.service.MemberServiceLocal;
import vn.chatbot.util.EmailUtil;
import vn.chatbot.util.NumberUtil;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.HashMap;
import java.util.Map;

@SuppressWarnings("deprecation")
@Controller
public class HomeController extends BaseController {

	@Autowired
	private MemberServiceLocal memberService;
	@Autowired
	private GoogleAuthServiceLocal googleAuthService;

	@RequestMapping(value = "index")
	public String index(Model model, HttpServletRequest request) {

		String email = SecurityContextHolder.getContext().getAuthentication().getName();
		Member member = memberService.getMemberByEmail(email);

		model.addAttribute("member", member);

		return "home/index";
	}

	@RequestMapping(value = "login")
	public String login(Model model, HttpServletRequest request) {

		return "home/login";
	}

	@RequestMapping(value = "security")
	public String security(Model model, HttpServletRequest request) {

		String email = SecurityContextHolder.getContext().getAuthentication().getName();
		Member member = memberService.getMemberByEmail(email);
		if (member.getActive().intValue() == 1) {
			return "redirect:/security.jsp";
		}
		model.addAttribute("member", member);

		return "home/active";
	}

	@RequestMapping(value = "register", method = RequestMethod.GET)
	public String register(Model model, HttpServletRequest request) {

		Member member = new Member();

		model.addAttribute("member", member);

		return "home/register";
	}
	
	@RequestMapping(value = "forgetPassword", method = RequestMethod.GET)
	public String forgetPassword(@Valid Member member, BindingResult result, Model model, HttpServletRequest request)  {
		
		return "home/forgetPassword";
	}
	/*
	@RequestMapping(value = "setPassword", method = RequestMethod.POST)
	public String setPassword(@Valid Member member, BindingResult result, Model model, HttpServletRequest request)  {
		
		System.out.println("getPassword()");
		System.out.println(member.getPassword());
		System.out.println("getEmail()");
		System.out.println(member.getEmail());

		
		PasswordEncoder encoder = new Md5PasswordEncoder();
		member.setPassword(encoder.encodePassword(member.getPassword(), null));
		memberService.updatePassword(member);
		return "home/login";
	}
	
	*/
	
	//save the Password
    @RequestMapping(value = "setPassword", method = RequestMethod.POST)
    public @ResponseBody String setPassword(@RequestParam("email") String email, @RequestParam("password") String password) {
    	Member member = memberService.getMemberByEmail(email);
    	System.out.println("getPassword()");
		System.out.println(password);
		System.out.println("getEmail()");
		System.out.println(email);

		member.setEmail(email);
		member.setPassword(password);
		PasswordEncoder encoder = new Md5PasswordEncoder();
		member.setPassword(encoder.encodePassword(member.getPassword(), null));
		memberService.updatePassword(member);
		return "home/login";
    	
    }
	
	
	@RequestMapping(value = "register", method = RequestMethod.POST)
	public String registerPost(@Valid Member member, BindingResult result, Model model, HttpServletRequest request)  {

		if (result.hasErrors()) {
			saveMessage(request, "Registration failed");

			model.addAttribute("member", member);

			return "home/register";
		}
		
		/* check duplicate username */
		Member user = memberService.getMemberByEmail(member.getEmail());
		if (user != null)
		    return "home/register";
		/* check duplicate username */

		PasswordEncoder encoder = new Md5PasswordEncoder();

		member.setPassword(encoder.encodePassword(member.getPassword(), null));
		
		/*active when register*/
		member.setActiveCode(String.format("%04d", NumberUtil.random(100, 9999)));
		/*active when register*/
		
		memberService.insertSelective(member);

		model.addAttribute("member", member);
		
		/*active when register*/
		EmailUtil.send(member.getEmail(), null, "[Chatbot] Active code", "<div>Your active code: " + member.getActiveCode() + "</div>", null);
		/*active when register*/
		
		return "home/active";
	}

	@RequestMapping(value = "active", method = RequestMethod.POST)
	public String active(String email, String activeCode, Model model, HttpServletRequest request) {

		// Member member = memberService.selectByPrimaryKey(userId);

		Member member = memberService.getMemberByEmail(email);

		if (member.getActiveCode().equals(activeCode)) {
			member.setActive(1);
			memberService.updateByPrimaryKeySelective(member);

			return "redirect:/login.html?active=successful";
		}

		model.addAttribute("member", member);

		return "redirect:/active.html?active=failed";
	}

	@RequestMapping("/login-google")
	public String loginGoogle(HttpServletRequest request) throws ClientProtocolException, IOException {
		String code = request.getParameter("code");

		if (code == null || code.isEmpty()) {
			return "redirect:/login?message=google_error";
		}
		String accessToken = googleAuthService.getToken(code);
		
		GooglePojo googlePojo = googleAuthService.getUserInfo(accessToken);
		UserDetails userDetail = googleAuthService.buildUser(googlePojo);
		
		// check member in database
		Member member = memberService.getMemberByEmail(googlePojo.getEmail());
		if (member == null) {
			member = new Member();
			member.setName(googlePojo.getName());
			member.setEmail(googlePojo.getEmail());
			
			memberService.insertSelective(member);
		}
		
		// login
		UsernamePasswordAuthenticationToken authentication = new UsernamePasswordAuthenticationToken(userDetail, null,
				userDetail.getAuthorities());
		authentication.setDetails(new WebAuthenticationDetailsSource().buildDetails(request));
		SecurityContextHolder.getContext().setAuthentication(authentication);
		
		return "redirect:/security.html";
	}
	
	@RequestMapping(value = "/duplicate-account")
	public @ResponseBody
	Map<String, Object> checkDuplicateAccount(String email, HttpServletRequest request, HttpServletResponse response) {
	    Map<String, Object> data = new HashMap<String, Object>();
	    	/* check duplicate username */
	    	Member user = memberService.getMemberByEmail(email);
		if (user != null)
		    data.put("status", "failed");
		else
		    data.put("status", 	"success");

    	    	return data;
    	}
}
