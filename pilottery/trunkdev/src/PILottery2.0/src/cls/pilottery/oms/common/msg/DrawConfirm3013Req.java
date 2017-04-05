package cls.pilottery.oms.common.msg;


public class DrawConfirm3013Req implements java.io.Serializable {

	private static final long serialVersionUID = 9015574610161226722L;
	private short gameCode;
	private long issueNumber;
	private short drawTimes;
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
