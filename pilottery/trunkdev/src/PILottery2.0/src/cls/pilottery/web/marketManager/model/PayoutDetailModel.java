package cls.pilottery.web.marketManager.model;

import java.io.Serializable;
import java.util.Date;

public class PayoutDetailModel implements Serializable {

	private static final long serialVersionUID = -1390066426692493669L;

	private String outletCode;
	private Date payoutDate;
	private long payoutAmount;
	private long payoutComm;

	private long levelAmount;
	private int tickets;
	private long amount;

	private int sumTickets;

	private String payoutSpecification;
	private String payoutStatus;


	public String getOutletCode() {
		return outletCode;
	}

	public void setOutletCode(String outletCode) {
		this.outletCode = outletCode;
	}

	public Date getPayoutDate() {
		return payoutDate;
	}

	public void setPayoutDate(Date payoutDate) {
		this.payoutDate = payoutDate;
	}

	public long getPayoutAmount() {
		return payoutAmount;
	}

	public void setPayoutAmount(long payoutAmount) {
		this.payoutAmount = payoutAmount;
	}

	public long getPayoutComm() {
		return payoutComm;
	}

	public void setPayoutComm(long payoutComm) {
		this.payoutComm = payoutComm;
	}

	public long getLevelAmount() {
		return levelAmount;
	}

	public void setLevelAmount(long levelAmount) {
		this.levelAmount = levelAmount;
	}

	public int getTickets() {
		return tickets;
	}

	public void setTickets(int tickets) {
		this.tickets = tickets;
	}

	public long getAmount() {
		return amount;
	}

	public void setAmount(long amount) {
		this.amount = amount;
	}

	public int getSumTickets() {
		return sumTickets;
	}

	public void setSumTickets(int sumTickets) {
		this.sumTickets = sumTickets;
	}

	public String getPayoutSpecification() {
		return payoutSpecification;
	}

	public void setPayoutSpecification(String payoutSpecification) {
		this.payoutSpecification = payoutSpecification;
	}

	public String getPayoutStatus() {
		return payoutStatus;
	}

	public void setPayoutStatus(String payoutStatus) {
		this.payoutStatus = payoutStatus;
	}

}
