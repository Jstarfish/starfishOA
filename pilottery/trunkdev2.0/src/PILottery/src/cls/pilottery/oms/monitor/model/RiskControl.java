package cls.pilottery.oms.monitor.model;

public class RiskControl {

	private int gameCode; // GAME_CODE 游戏编码
	private long issueNumber; // ISSUE_NUMBER 期次序号

	private long issueRickAmount; // ISSUE_RICK_AMOUNT 风控拒绝金额
	private long issueRickTickets; // ISSUE_RICK_TICKETS 风控拒绝票数/风控拒绝次数

	private String timePoint; // TIME_POINT 时间点
	private String timePointText;

	private String riskValues; // RISK_VALUES 风控赔付字符串

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

	public long getIssueRickAmount() {
		return issueRickAmount;
	}

	public void setIssueRickAmount(long issueRickAmount) {
		this.issueRickAmount = issueRickAmount;
	}

	public long getIssueRickTickets() {
		return issueRickTickets;
	}

	public void setIssueRickTickets(long issueRickTickets) {
		this.issueRickTickets = issueRickTickets;
	}

	public String getTimePoint() {
		return timePoint;
	}

	public void setTimePoint(String timePoint) {
		this.timePoint = timePoint;
	}

	public String getTimePointText() {
		if (gameCode == 6) {
			timePointText = timePoint.substring(11, 16);
		} else if (gameCode == 9) {
			timePointText = timePoint.substring(11, timePoint.length());
		}
		return timePointText;
	}

	public void setRiskValues(String riskValues) {
		this.riskValues = riskValues;
	}

	public String getRiskValues() {
		return riskValues;
	}

}
