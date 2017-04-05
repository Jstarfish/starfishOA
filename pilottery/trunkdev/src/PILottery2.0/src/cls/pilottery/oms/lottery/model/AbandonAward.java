package cls.pilottery.oms.lottery.model;

import cls.pilottery.common.model.BaseEntity;

public class AbandonAward extends BaseEntity {

	private static final long serialVersionUID = 1L;

	private String payDate;// 弃奖日期

	private String payDateStart;// 弃奖日期开始

	private String payDateEnd;// 弃奖日期结束

	private int gameCode;// 游戏

	private String issueNumber;// 游戏期次

	private String issueNumberStart;// 游戏期次开始

	private String issueNumberEnd;// 游戏期次结束

	private int prizeLevel;// 奖等

	private int prizeBetCount;// 弃奖注数

	private int prizeTicketCount;// 弃奖票数

	private int isHdPrize;// 是否高等奖

	private int winningAmountTax;// 弃奖金额(税前)

	private int winningAmount;// 弃奖金额(税后)

	private int taxAmount;// 税额

	public int getGameCode() {
		return gameCode;
	}

	public void setGameCode(int gameCode) {
		this.gameCode = gameCode;
	}

	public int getPrizeLevel() {
		return prizeLevel;
	}

	public void setPrizeLevel(int prizeLevel) {
		this.prizeLevel = prizeLevel;
	}

	public int getPrizeBetCount() {
		return prizeBetCount;
	}

	public void setPrizeBetCount(int prizeBetCount) {
		this.prizeBetCount = prizeBetCount;
	}

	public int getPrizeTicketCount() {
		return prizeTicketCount;
	}

	public void setPrizeTicketCount(int prizeTicketCount) {
		this.prizeTicketCount = prizeTicketCount;
	}

	public int getIsHdPrize() {
		return isHdPrize;
	}

	public void setIsHdPrize(int isHdPrize) {
		this.isHdPrize = isHdPrize;
	}

	public int getWinningAmountTax() {
		return winningAmountTax;
	}

	public void setWinningAmountTax(int winningAmountTax) {
		this.winningAmountTax = winningAmountTax;
	}

	public int getWinningAmount() {
		return winningAmount;
	}

	public void setWinningAmount(int winningAmount) {
		this.winningAmount = winningAmount;
	}

	public int getTaxAmount() {
		return taxAmount;
	}

	public void setTaxAmount(int taxAmount) {
		this.taxAmount = taxAmount;
	}

	public String getPayDateStart() {
		return payDateStart;
	}

	public void setPayDateStart(String payDateStart) {
		this.payDateStart = payDateStart;
	}

	public String getPayDateEnd() {
		return payDateEnd;
	}

	public void setPayDateEnd(String payDateEnd) {
		this.payDateEnd = payDateEnd;
	}

	public String getIssueNumberStart() {
		return issueNumberStart;
	}

	public void setIssueNumberStart(String issueNumberStart) {
		this.issueNumberStart = issueNumberStart;
	}

	public String getIssueNumberEnd() {
		return issueNumberEnd;
	}

	public void setIssueNumberEnd(String issueNumberEnd) {
		this.issueNumberEnd = issueNumberEnd;
	}

	public String getPayDate() {
		return payDate;
	}

	public void setPayDate(String payDate) {
		this.payDate = payDate;
	}

	public String getIssueNumber() {
		return issueNumber;
	}

	public void setIssueNumber(String issueNumber) {
		this.issueNumber = issueNumber;
	}

}
