package vn.chatbot.controller;

import java.util.Date;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Component;
import org.springframework.web.context.request.RequestAttributes;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;

import vn.chatbot.domain.Member;
import vn.chatbot.domain.SessionLog;
import vn.chatbot.service.MemberServiceLocal;
import vn.chatbot.service.SessionLogServiceLocal;

@Component
public class HandlerController extends HandlerInterceptorAdapter {
	
	@Autowired
	private MemberServiceLocal memberService;
	@Autowired
	private SessionLogServiceLocal sessionLogService;
	
	private static Logger logger = LoggerFactory.getLogger(HandlerController.class);
	
	
	public boolean isValidEmailAddress(String email) {
        String ePattern = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@((\\[[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\])|(([a-zA-Z\\-0-9]+\\.)+[a-zA-Z]{2,}))$";
        java.util.regex.Pattern p = java.util.regex.Pattern.compile(ePattern);
        java.util.regex.Matcher m = p.matcher(email);
        return m.matches();
	}
	
	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
		
		String email = SecurityContextHolder.getContext().getAuthentication().getName();
		Member user = memberService.getMemberByEmail(email);
		
		if (user != null) {
			boolean loginFlag = false;
			
			try {
				loginFlag = (Boolean) RequestContextHolder.currentRequestAttributes().getAttribute("_LOGIN_FLAG", RequestAttributes.SCOPE_SESSION);
			} catch (Exception ex) {
				try {
					SessionLog sessionLog = new SessionLog();
					sessionLog.setUserId(user.getUserId());
					sessionLog.setSessionId(RequestContextHolder.getRequestAttributes().getSessionId());
					sessionLog.setStartTime(new Date());
					
					sessionLogService.insertSelective(sessionLog);
					
					logger.info("INSERT LOG SUCCESS! Username: {}", email);
					

						loginFlag = true;
						RequestContextHolder.currentRequestAttributes().setAttribute("_LOGIN_FLAG", loginFlag, RequestAttributes.SCOPE_SESSION);
					
						
					
				} catch (Exception e) {
					logger.error("Error Insert log: ", e);
				}
			}
		}
		
		return super.preHandle(request, response, handler);
	}
	
	@Override
	public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler,
			ModelAndView model) throws Exception {
		
		super.postHandle(request, response, handler, model);
	}
}
