package cls.pilottery.oms.common.msg;


public class RestartDraw3015Req implements java.io.Serializable {
	private static final long serialVersionUID = -1585887316678225324L;
	public short gameCode;
    public long issueNumber;
    public short drawTimes;
	public short getGameCode() {
		return gameCode;
	}
	public void setGameCode(short gameCode) {
		this.gameCode = gameCode;
	}
	public long getIssueNumber() {
		return issueNumber;
	}
	public void setIssueNumber(long issueNumber) {
		this.issueNumber = issueNumber;
	}
	public short getDrawTimes() {
		return drawTimes;
	}
	public void setDrawTimes(short drawTimes) {
		this.drawTimes = drawTimes;
	}
}
