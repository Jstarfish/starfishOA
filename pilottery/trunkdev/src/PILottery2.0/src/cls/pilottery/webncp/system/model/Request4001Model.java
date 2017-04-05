package cls.pilottery.webncp.system.model;

import cls.pilottery.webncp.common.model.BaseRequest;

public class Request4001Model extends BaseRequest {

	private static final long serialVersionUID = 3819111904852666268L;
	private String gameCode;   //彩种编码
	private String perdIssue;  //期次编码
	
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
	
	@Override
	public String toString() {
		return "Request4001Model [gameCode=" + gameCode + ", perdIssue=" + perdIssue + "]";
	}
}
