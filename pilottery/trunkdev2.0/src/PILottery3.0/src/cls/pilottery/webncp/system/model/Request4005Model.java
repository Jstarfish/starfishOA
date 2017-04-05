package cls.pilottery.webncp.system.model;

import cls.pilottery.webncp.common.model.BaseRequest;

public class Request4005Model extends BaseRequest {

	private static final long serialVersionUID = 7448294799911065812L;
	private String  gameCode;   //彩种编码
	private String  perdIssue;  //期次编码
	private Integer pageSize;   //每页记录数
	private Integer pageIndex;  //页面序号
	
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
	
	public Integer getPageSize() {
		return pageSize;
	}
	public void setPageSize(Integer pageSize) {
		this.pageSize = pageSize;
	}
	
	public Integer getPageIndex() {
		return pageIndex;
	}
	public void setPageIndex(Integer pageIndex) {
		this.pageIndex = pageIndex;
	}
	
	@Override
	public String toString() {
		return "Request4005Model [gameCode=" + gameCode + ", perdIssue=" + perdIssue + ", pageSize=" + pageSize + ", pageIndex=" + pageIndex + "]";
	}
}
