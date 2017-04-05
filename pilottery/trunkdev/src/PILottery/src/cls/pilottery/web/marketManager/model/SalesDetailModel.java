package cls.pilottery.web.marketManager.model;

import java.io.Serializable;
import java.util.Date;

public class SalesDetailModel implements Serializable {

	private static final long serialVersionUID = 1033654900369018955L;

	private String outletCode;
	private Date saleDate;
	private Long saleAmount;
	private Long saleComm;

	private String planCode;
	private String planName;
	private String tickets;
	private long sumAmount; // 方案销售的总金额

	private String saleSpecification; // 详情规格
	private long amount; // 对应的金额

	public String getOutletCode() {
		return outletCode;
	}

	public void setOutletCode(String outletCode) {
		this.outletCode = outletCode;
	}

	public Date getSaleDate() {
		return saleDate;
	}

	public void setSaleDate(Date saleDate) {
		this.saleDate = saleDate;
	}

	public Long getSaleAmount() {
		return saleAmount;
	}

	public void setSaleAmount(Long saleAmount) {
		this.saleAmount = saleAmount;
	}

	public Long getSaleComm() {
		return saleComm;
	}

	public void setSaleComm(Long saleComm) {
		this.saleComm = saleComm;
	}

	public String getPlanCode() {
		return planCode;
	}

	public void setPlanCode(String planCode) {
		this.planCode = planCode;
	}

	public String getPlanName() {
		return planName;
	}

	public void setPlanName(String planName) {
		this.planName = planName;
	}

	public String getTickets() {
		return tickets;
	}

	public void setTickets(String tickets) {
		this.tickets = tickets;
	}

	public long getSumAmount() {
		return sumAmount;
	}

	public void setSumAmount(long sumAmount) {
		this.sumAmount = sumAmount;
	}

	public String getSaleSpecification() {
		return saleSpecification;
	}

	public void setSaleSpecification(String saleSpecification) {
		this.saleSpecification = saleSpecification;
	}

	public long getAmount() {
		return amount;
	}

	public void setAmount(long amount) {
		this.amount = amount;
	}

}
