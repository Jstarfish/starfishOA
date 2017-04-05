package cls.pilottery.oms.report.model;

import java.io.Serializable;

public class MisReport3134 implements Serializable {
	private static final long serialVersionUID = -940427205634046163L;
	private short gameCode;
	private long issueNumber;
	private String payDate; // 兑奖日期
	private long saleAmount; // 销售总额
	private long bigPayCount; // 高等奖兑奖金额
	private long bigPayAmount; // 高等奖兑奖注数
	private long midPayCount; // 大奖兑奖金额
	private long midPayAmount; // 大奖兑奖注数
	private long smallPayCount; // 小奖兑奖金额
	private long smallPayAmount; // 小奖兑奖注数
	private long paySum; // 兑奖金额合计

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

	public long getBigPayCount() {
		return bigPayCount;
	}

	public void setBigPayCount(long bigPayCount) {
		this.bigPayCount = bigPayCount;
	}

	public long getBigPayAmount() {
		return bigPayAmount;
	}

	public void setBigPayAmount(long bigPayAmount) {
		this.bigPayAmount = bigPayAmount;
	}

	public long getMidPayCount() {
		return midPayCount;
	}

	public void setMidPayCount(long midPayCount) {
		this.midPayCount = midPayCount;
	}

	public long getMidPayAmount() {
		return midPayAmount;
	}

	public void setMidPayAmount(long midPayAmount) {
		this.midPayAmount = midPayAmount;
	}

	public long getSmallPayCount() {
		return smallPayCount;
	}

	public void setSmallPayCount(long smallPayCount) {
		this.smallPayCount = smallPayCount;
	}

	public long getSmallPayAmount() {
		return smallPayAmount;
	}

	public void setSmallPayAmount(long smallPayAmount) {
		this.smallPayAmount = smallPayAmount;
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
