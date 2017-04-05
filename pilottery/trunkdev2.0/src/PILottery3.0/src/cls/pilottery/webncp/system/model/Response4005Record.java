package cls.pilottery.webncp.system.model;

import java.io.Serializable;

public class Response4005Record implements Serializable {

	private static final long serialVersionUID = -687398082607164344L;
	private String gameCode;     //彩种编码
	private String perdIssue;    //期次编码
	private String drawNumber;   //开奖号码
	private String drawTime;     //开奖时间
	
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
	
	public String getDrawNumber() {
		return drawNumber;
	}
	public void setDrawNumber(String drawNumber) {
		this.drawNumber = drawNumber;
	}
	
	public String getDrawTime() {
		return drawTime;
	}
	public void setDrawTime(String drawTime) {
		this.drawTime = drawTime;
	}
}
