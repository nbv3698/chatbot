package vn.chatbot.domain;

public class Message {
	
	private int id;
	private String idSolr;
	

	private String question;
	
	private String answer;

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
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
}
