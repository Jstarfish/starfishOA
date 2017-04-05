package cls.pilottery.web.marketManager.model;

import java.io.Serializable;
import java.util.Date;

public class ReturnDetailModel implements Serializable {

	private static final long serialVersionUID = 391345121576759835L;

	private String outletCode;
	private Date returnlDate;
	private long returnAmount;
	private long returnComm;

	private String planCode;
	private long sumAmount;
	private String tickets;

	private String returnSpecification;
	private long amount;

	public String getOutletCode() {
		return outletCode;
	}

	public void setOutletCode(String outletCode) {
		this.outletCode = outletCode;
	}

	

	public Date getReturnlDate() {
		return returnlDate;
	}

	public void setReturnlDate(Date returnlDate) {
		this.returnlDate = returnlDate;
	}

	public long getReturnAmount() {
		return returnAmount;
	}

	public void setReturnAmount(long returnAmount) {
		this.returnAmount = returnAmount;
	}

	public long getReturnComm() {
		return returnComm;
	}

	public void setReturnComm(long returnComm) {
		this.returnComm = returnComm;
	}

	public String getPlanCode() {
		return planCode;
	}

	public void setPlanCode(String planCode) {
		this.planCode = planCode;
	}

	public long getSumAmount() {
		return sumAmount;
	}

	public void setSumAmount(long sumAmount) {
		this.sumAmount = sumAmount;
	}

	public String getTickets() {
		return tickets;
	}

	public void setTickets(String tickets) {
		this.tickets = tickets;
	}

	public String getReturnSpecification() {
		return returnSpecification;
	}

	public void setReturnSpecification(String returnSpecification) {
		this.returnSpecification = returnSpecification;
	}

	public long getAmount() {
		return amount;
	}

	public void setAmount(long amount) {
		this.amount = amount;
	}

}
