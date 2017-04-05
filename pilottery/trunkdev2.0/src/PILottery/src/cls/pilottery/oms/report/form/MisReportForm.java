package cls.pilottery.oms.report.form;

public class MisReportForm implements java.io.Serializable {
	private static final long serialVersionUID = -4579482966418482322L;
	
	private String beginIssue;	//起始期次
	private String endIssue;	//终止期次
	private String gameCode;	//游戏代码
	private String gameName;	//游戏名称
	private String startDate;	//开始日期
	private String endDate;		//结束日期
	private String reportTitle;
	public String getBeginIssue() {
		return beginIssue;
	}
	public void setBeginIssue(String beginIssue) {
		this.beginIssue = beginIssue;
	}
	public String getEndIssue() {
		return endIssue;
	}
	public void setEndIssue(String endIssue) {
		this.endIssue = endIssue;
	}
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
	public String getStartDate() {
		return startDate;
	}
	public void setStartDate(String startDate) {
		this.startDate = startDate;
	}
	public String getEndDate() {
		return endDate;
	}
	public void setEndDate(String endDate) {
		this.endDate = endDate;
	}
	public String getReportTitle() {
		return reportTitle;
	}
	public void setReportTitle(String reportTitle) {
		this.reportTitle = reportTitle;
	}
	
}
