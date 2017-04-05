package cls.pilottery.oms.report.model;

import java.io.Serializable;

public class MisReport3133 implements Serializable {
	private static final long serialVersionUID = -5619979686784043440L;
	private short gameCode;
	private long issueNumber;
	private String payDate;			//兑奖日期
	private long saleAmount;		//销售总额
	private long hdPayAmount;		//高等奖兑奖注数
	private long hdPaySum;			//高等奖兑奖金额
	private long ldPaySum;			//低等级兑奖金额
	private long ldPayAmount;		//低等级兑奖注数
	private long paySum;			//兑奖合计
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
	public long getSaleAmount() {
		return saleAmount;
	}
	public void setSaleAmount(long saleAmount) {
		this.saleAmount = saleAmount;
	}
	public long getHdPayAmount() {
		return hdPayAmount;
	}
	public void setHdPayAmount(long hdPayAmount) {
		this.hdPayAmount = hdPayAmount;
	}
	public long getHdPaySum() {
		return hdPaySum;
	}
	public void setHdPaySum(long hdPaySum) {
		this.hdPaySum = hdPaySum;
	}
	public long getLdPaySum() {
		return ldPaySum;
	}
	public void setLdPaySum(long ldPaySum) {
		this.ldPaySum = ldPaySum;
	}
	public long getLdPayAmount() {
		return ldPayAmount;
	}
	public void setLdPayAmount(long ldPayAmount) {
		this.ldPayAmount = ldPayAmount;
	}
	public long getPaySum() {
		return paySum;
	}
	public void setPaySum(long paySum) {
		this.paySum = paySum;
	}
	public String getPayDate() {
		return payDate;
	}
	public void setPayDate(String payDate) {
		this.payDate = payDate;
	}
}
