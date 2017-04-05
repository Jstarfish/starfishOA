package cls.pilottery.oms.report.model;

import java.io.Serializable;

public class MisReport3132 implements Serializable {
	private static final long serialVersionUID = -4648373441039684074L;
	private short gameCode;
	private long issueNumber;
	private long saleAmount;		//销售总额
	private long hdWinningSum;		//高等奖注数
	private long hdWinningAmount;	//高等奖金额
	private long ldWinningSum;		//低等级注数
	private long ldWinningAmount;	//低等级金额
	private long winningSum;		//中奖合计
	private long winningRate;		//实际中奖比例
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
	public long getHdWinningSum() {
		return hdWinningSum;
	}
	public void setHdWinningSum(long hdWinningSum) {
		this.hdWinningSum = hdWinningSum;
	}
	public long getHdWinningAmount() {
		return hdWinningAmount;
	}
	public void setHdWinningAmount(long hdWinningAmount) {
		this.hdWinningAmount = hdWinningAmount;
	}
	public long getLdWinningSum() {
		return ldWinningSum;
	}
	public void setLdWinningSum(long ldWinningSum) {
		this.ldWinningSum = ldWinningSum;
	}
	public long getLdWinningAmount() {
		return ldWinningAmount;
	}
	public void setLdWinningAmount(long ldWinningAmount) {
		this.ldWinningAmount = ldWinningAmount;
	}
	public long getWinningSum() {
		return winningSum;
	}
	public void setWinningSum(long winningSum) {
		this.winningSum = winningSum;
	}
	public long getWinningRate() {
		return winningRate;
	}
	public void setWinningRate(long winningRate) {
		this.winningRate = winningRate;
	}
}
