package cls.pilottery.webncp.system.model;

import cls.pilottery.webncp.common.model.BaseRequest;

public class Request4002Model extends BaseRequest {

	private static final long serialVersionUID = 5142785262565390188L;
	private String gameCode;    //彩种编码
	private String perdIssue;   //期次编码
	private String agencyCode;  //站点编号
	
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
	
	public String getAgencyCode() {
		return agencyCode;
	}
	public void setAgencyCode(String agencyCode) {
		this.agencyCode = agencyCode;
	}
	
	@Override
	public String toString() {
		return "Request4002Model [gameCode=" + gameCode + ", perdIssue=" + perdIssue + ", agencyCode=" + agencyCode + "]";
	}
}
