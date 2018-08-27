package vn.chatbot.controller;

public class Conver {
	
	private String idSolr;
	private String question;
	private String answer;
	
	
	public Conver(String idSolr, String question, String answer) {
		super();
		this.idSolr = idSolr;
		this.question = question;
		this.answer = answer;
	}
	
	public Conver() {
		super();
	}

	public String getIdSolr() {
		return idSolr;
	}

	public void setIdSolr(String idSolr) {
		this.idSolr = idSolr;
	}

	public String getQuestion() {
		return question;
	}
	public void setQuestion(String question) {
		this.question = question;
	}
	public String getAnswer() {
		return answer;
	}
	public void setAnswer(String answer) {
		this.answer = answer;
	}

	@Override
	public String toString() {
		return "Conver [question=" + question + ", answer=" + answer + "]";
	}
	
	
	

}
