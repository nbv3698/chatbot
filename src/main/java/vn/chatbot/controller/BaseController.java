package vn.chatbot.controller;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;
import org.springframework.beans.propertyeditors.CustomDateEditor;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.InitBinder;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.NoHandlerFoundException;

@Controller
@ControllerAdvice
public class BaseController {

	private static Logger logger = Logger
			.getLogger(BaseController.class.getName());
	
	@ExceptionHandler({
		Exception.class, 
		IOException.class, 
		NullPointerException.class 
	})
	public ModelAndView exceptionHandler(Exception e) {
		
		logger.error("An error has occurred - " + e.getMessage(), e);
		ModelAndView mav = new ModelAndView("error/exception");
		
		mav.addObject("showTrace", false);
		mav.addObject("exception", e);
		return mav;
	}
	
	@ExceptionHandler(NoHandlerFoundException.class)
	public ModelAndView handleError404(HttpServletRequest request, Exception e)   {
		
		ModelAndView mav = new ModelAndView("error/exception");
		mav.addObject("exception", e);
		mav.addObject("errorCode", "404");
		return mav;
    }
	
	public static final String MESSAGES_KEY = "successMessagesKey";
	
	public static final String MESSAGES_TITLE = "successMessagesTitle";

	@SuppressWarnings({ "unchecked", "rawtypes" })
	public void saveError(HttpServletRequest request, String error) {
		List errors = (List) request.getSession().getAttribute("errors");
		if (errors == null) {
			errors = new ArrayList();
		}
		errors.add(error);
		request.getSession().setAttribute("errors", errors);
	}

	@SuppressWarnings({ "unchecked", "rawtypes" })
	public void saveMessageKey(HttpServletRequest request, String msg) {
		List messages = (List) request.getSession().getAttribute(MESSAGES_KEY);

		if (messages == null) {
			messages = new ArrayList();
		}

		messages.add(msg);
		request.getSession().setAttribute(MESSAGES_KEY, messages);
	}
	
	@SuppressWarnings({ "unchecked", "rawtypes" })
	public void saveMessage(HttpServletRequest request, String msg) {
		List messages = (List) request.getSession().getAttribute(MESSAGES_TITLE);

		if (messages == null) {
			messages = new ArrayList();
		}

		messages.add(msg);
		request.getSession().setAttribute(MESSAGES_TITLE, messages);
	}
	
	@InitBinder
	public void initBinder(WebDataBinder binder) {
		SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");
		binder.registerCustomEditor(Date.class, null, new CustomDateEditor(dateFormat, true));
	}
	
}
