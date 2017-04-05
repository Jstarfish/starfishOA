package cls.pilottery.oms.report.model;

import java.io.Serializable;

public class MisReport3135 implements Serializable {
	private static final long serialVersionUID = -940427205634046163L;
	private short gameCode;
	private long issueNumber;
	private long purgedAmound;		//弃奖总额
	private long hdPurgedAmound;	//高等奖弃奖金额
	private long hdPurgedSum;		//高等奖弃奖注数
	private long ldPurgedAmound;	//低等奖弃奖金额
	private long ldPurgedSum;		//低等级弃奖注数
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
	public long getPurgedAmound() {
		return purgedAmound;
	}
	public void setPurgedAmound(long purgedAmound) {
		this.purgedAmound = purgedAmound;
	}
	public long getHdPurgedAmound() {
		return hdPurgedAmound;
	}
	public void setHdPurgedAmound(long hdPurgedAmound) {
		this.hdPurgedAmound = hdPurgedAmound;
	}
	public long getHdPurgedSum() {
		return hdPurgedSum;
	}
	public void setHdPurgedSum(long hdPurgedSum) {
		this.hdPurgedSum = hdPurgedSum;
	}
	public long getLdPurgedAmound() {
		return ldPurgedAmound;
	}
	public void setLdPurgedAmound(long ldPurgedAmound) {
		this.ldPurgedAmound = ldPurgedAmound;
	}
	public long getLdPurgedSum() {
		return ldPurgedSum;
	}
	public void setLdPurgedSum(long ldPurgedSum) {
		this.ldPurgedSum = ldPurgedSum;
	}
}
