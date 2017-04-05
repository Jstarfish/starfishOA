package cls.pilottery.oms.common.msg;


public class DrawNumber3005Req implements java.io.Serializable {

	private static final long serialVersionUID = 1577713493743778929L;
	public short gameCode;
	public long issueNumber;
	public short drawTimes;
	public long numberCount;
	public String drawNumber;
	public long timeStamp;
	public String gameDisplay;
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
	public long getNumberCount() {
		return numberCount;
	}
	public void setNumberCount(long numberCount) {
		this.numberCount = numberCount;
	}
	public String getDrawNumber() {
		return drawNumber;
	}
	public void setDrawNumber(String drawNumber) {
		this.drawNumber = drawNumber;
	}
	public long getTimeStamp() {
		return timeStamp;
	}
	public void setTimeStamp(long timeStamp) {
		this.timeStamp = timeStamp;
	}
	public String getGameDisplay() {
		return gameDisplay;
	}
	public void setGameDisplay(String gameDisplay) {
		this.gameDisplay = gameDisplay;
	}
}
