package cls.pilottery.webncp.system.model;

import java.util.List;

import cls.pilottery.webncp.common.model.BaseResponse;

public class Response4002Model extends BaseResponse {

	private static final long serialVersionUID = -7856577542286927937L;
	private String gameCode;   //游戏编号
	private String gameName;   //游戏名称
	private String perdIssue;  //游戏期次
	private String drawCode;   //开奖号码
	private List<Response4002Record> recordList;
	
	public String getGameCode() {
		return gameCode;
	}
	public void setGameCode(String gameCode) {
		this.gameCode = gameCode;
	}
	
	public String getGameName() {
		return gameName;
	}
	public void setGameName(String gameName) {
		this.gameName = gameName;
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
	
	public List<Response4002Record> getRecordList() {
		return recordList;
	}
	public void setRecordList(List<Response4002Record> recordList) {
		this.recordList = recordList;
	}
}
