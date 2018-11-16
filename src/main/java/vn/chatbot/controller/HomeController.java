package vn.chatbot.controller;

import java.io.IOException;
import java.io.UnsupportedEncodingException;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.validation.Valid;

import org.apache.http.client.ClientProtocolException;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.authentication.encoding.Md5PasswordEncoder;
import org.springframework.security.authentication.encoding.PasswordEncoder;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.web.authentication.WebAuthenticationDetailsSource;
import org.springframework.security.web.savedrequest.HttpSessionRequestCache;
import org.springframework.security.web.savedrequest.SavedRequest;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import com.google.gson.Gson;

import vn.chatbot.domain.GooglePojo;
import vn.chatbot.domain.Member;
import vn.chatbot.service.GoogleAuthServiceLocal;
import vn.chatbot.service.MemberServiceLocal;
import vn.chatbot.util.EmailUtil;
import vn.chatbot.util.NumberUtil;

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
	
	//Send confirm reset password mail
	@RequestMapping(value = "sendConfirmResetPasswordMail", method = RequestMethod.POST)
	public @ResponseBody String confirmResetPassword(@RequestParam("email") String email) {
		Member member = memberService.getMemberByEmail(email);
		String url = "http://122.146.88.206:8080/sendPassword.html?email="+email;
		//String url = "http://localhost:8080/sendPassword.html?email="+email;
		if(member==null){
			System.out.println("E-mail not existing.");
			return "E-mail not existing.";
		}
		else {
			EmailUtil.send(email,
							null,
							"[Chatbot]Reset password",
							"<div>Please click the link to get a new password:<br>" + 
							"<a href='"+url+"'>Click here</a><br>" +
							"We will send new password to this E-mail.<br>" +
							"If you did not reset your password. Please ingnore the mail.</div>",
							null);
			return "home/login";	    		
		}
	}
		
	//send new Password
	@RequestMapping(value = "sendPassword", method = RequestMethod.GET)
	public String sendPassword(@RequestParam("email") String email, Model model, HttpServletRequest request) {
		Member member = memberService.getMemberByEmail(email);
	    	
		if(member==null){
			System.out.println("E-mail not existing.");
			return "E-mail not existing.";
		}
		else {
	    		//System.out.println("get Email:");
	    		//System.out.println(email);
			String password = String.format("%04d", NumberUtil.random(100, 9999));
			member.setEmail(email);
			member.setPassword(password);
			EmailUtil.send(email,
	    					null,
	    					"[Chatbot]Reset password",
	    					"<div>Your new password: " + password + "<br>Please change your password after you login.</div>",
	    					null);
	    		
			PasswordEncoder encoder = new Md5PasswordEncoder();
			member.setPassword(encoder.encodePassword(member.getPassword(), null));
			memberService.updatePassword(member);
	    		//return "We will send new password to your E-mail.";
			return "redirect:/forgetPassword.html?state=sendNewPassword";
		}
	}
		
	//Show forget password page
	@RequestMapping(value = "forgetPassword", method = RequestMethod.GET)
	public String forgetPassword(@Valid Member member, BindingResult result, Model model, HttpServletRequest request)  {	
		return "home/forgetPassword";
	}
		
	//Show account setting page
	@RequestMapping(value = "account/accountSetting", method = RequestMethod.GET)
	public String accountSetting(Model model, HttpServletRequest request)  {
		return "account/accountSetting";
	}
	
	//Get account setting
	@RequestMapping(value = "account/getAccountSetting", method = RequestMethod.GET)
	public @ResponseBody String getAccountSetting(Model model, HttpServletRequest request, HttpServletResponse response)  {
		response.setCharacterEncoding("UTF-8");
		String email = SecurityContextHolder.getContext().getAuthentication().getName();
		Member member = memberService.getMemberByEmail(email);
							
		String json = new Gson().toJson(member);
			
		System.out.println("Account:\n" + json);
		return json;
	}
		
	//Save password
	@RequestMapping(value = "account/setPassword", method = RequestMethod.POST)
	public @ResponseBody String setPassword(@RequestParam("password") String password) {
		String email = SecurityContextHolder.getContext().getAuthentication().getName();
		Member member = memberService.getMemberByEmail(email);

		member.setPassword(password);
		PasswordEncoder encoder = new Md5PasswordEncoder();
		member.setPassword(encoder.encodePassword(member.getPassword(), null));
		memberService.updatePassword(member);
		return "Your password has been changed successfully!";
	}
		
	//Save the UserName
	@RequestMapping(value = "account/setUserName", method = RequestMethod.POST)
	public @ResponseBody String setUserName(@RequestParam("userName") String userName, HttpServletRequest request) {
		try {
			request.setCharacterEncoding("UTF-8");
		} catch (UnsupportedEncodingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		String email = SecurityContextHolder.getContext().getAuthentication().getName();
		Member member = memberService.getMemberByEmail(email);
		member.setName(userName);
			
		memberService.updateByPrimaryKeySelective(member);
		return "Your user name has been changed successfully!";
	}
	@Resource(name = "authenticationManager")
    private AuthenticationManager authenticationManager;
	//auto login
	@RequestMapping(value = "autoLogin", method = RequestMethod.GET)
	public @ResponseBody String autoLogin(@RequestParam("email") String email) {
		HttpServletRequest request = ((ServletRequestAttributes) RequestContextHolder.getRequestAttributes()).getRequest();
        HttpServletResponse response = ((ServletRequestAttributes) RequestContextHolder.getRequestAttributes()).getResponse();
		
        String defaultTargetUrl = "/"; // 默认登陆成功的页面
        String redirectUrl = "/account/accountSetting"; // 默认为登陆错误页面
        
        
        Member member = memberService.getMemberByEmail(email);
		Authentication auth = new UsernamePasswordAuthenticationToken(email, member.getPassword());
		auth = authenticationManager.authenticate(auth);
		SecurityContextHolder.getContext().setAuthentication(auth);
		
		System.out.println("SecurityContextHolder:\n"+SecurityContextHolder.getContext().getAuthentication().getName());
		
		SavedRequest savedRequest = new HttpSessionRequestCache().getRequest(request, response);
        redirectUrl = (savedRequest != null) ? savedRequest.getRedirectUrl() : defaultTargetUrl;
        return redirectUrl;
	}
	
	
	
}
