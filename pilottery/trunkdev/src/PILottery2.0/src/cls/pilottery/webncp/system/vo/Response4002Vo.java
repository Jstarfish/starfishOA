package cls.pilottery.webncp.system.vo;

import java.io.Serializable;

public class Response4002Vo implements Serializable {

	private static final long serialVersionUID = 5967762858414858056L;
	private String gameCode;
	private String perdIssue;
	private String drawCode;
	
	public String getGameCode() {
		return gameCode;
	}
	public void setGameCode(String gameCode) {
		this.gameCode = gameCode;
	}
	
	public String getPerdIssue() {
		return perdIssue;
	}
	public void setPerdIssue(String perdIssue) {
		this.perdIssue = perdIssue;
	}
	
	public String getDrawCode() {
		return drawCode;
	}
	public void setDrawCode(String drawCode) {
		this.drawCode = drawCode;
	}
}
