package cls.pilottery.webncp.system.model;

import cls.pilottery.webncp.common.model.BaseResponse;

public class Response30d4Model extends BaseResponse {
	private static final long serialVersionUID = -952049089246823748L;
	private int errorCode = 5000;
	private String errorMesg;
	private int gameCode;
	private long issueNumber;
	private String resultJson;
	public int getGameCode() {
		return gameCode;
	}
	public void setGameCode(int gameCode) {
		this.gameCode = gameCode;
	}
	public long getIssueNumber() {
		return issueNumber;
	}
	public void setIssueNumber(long issueNumber) {
		this.issueNumber = issueNumber;
	}
	public String getResultJson() {
		return resultJson;
	}
	public void setResultJson(String resultJson) {
		this.resultJson = resultJson;
	}
	public int getErrorCode() {
		return errorCode;
	}
	public void setErrorCode(int errorCode) {
		this.errorCode = errorCode;
	}
	public String getErrorMesg() {
		return errorMesg;
	}
	public void setErrorMesg(String errorMesg) {
		this.errorMesg = errorMesg;
	}
	@Override
	public String toString() {
		return "Response30d4Model [errorCode=" + errorCode + ", errorMesg=" + errorMesg + ", gameCode=" + gameCode + ", issueNumber=" + issueNumber + ", resultJson=" + resultJson + "]";
	}
}
