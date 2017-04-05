package cls.pilottery.web.report.model;

import java.io.Serializable;
import java.util.Date;

public class GoodsReceiptsReportVo implements Serializable {
	private static final long serialVersionUID = 1L;
	private String sqe;//主键  
	private String deliverName;//出库人
	private Date rereceiptTime;
	private String whouseName;
	private String whouseCode;
	private String insName;
	private Long tickets;
	private Long amount;
	private Long amountDollar;
	private String planName;
	private String planCode;
	private Long sumamount;
	public String getWhouseCode() {
		return whouseCode;
	}
	public void setWhouseCode(String whouseCode) {
		this.whouseCode = whouseCode;
	}
	public String getPlanCode() {
		return planCode;
	}
	public void setPlanCode(String planCode) {
		this.planCode = planCode;
	}
	public Date getRereceiptTime() {
		return rereceiptTime;
	}
	public void setRereceiptTime(Date rereceiptTime) {
		this.rereceiptTime = rereceiptTime;
	}
	public String getWhouseName() {
		return whouseName;
	}
	public void setWhouseName(String whouseName) {
		this.whouseName = whouseName;
	}
	public Long getTickets() {
		return tickets;
	}
	
	public Long getAmountDollar() {
	
		return amountDollar;
	}
	
	public void setAmountDollar(Long amountDollar) {
	
		this.amountDollar = amountDollar;
	}
	public void setTickets(Long tickets) {
		this.tickets = tickets;
	}
	public Long getAmount() {
		return amount;
	}
	public void setAmount(Long amount) {
		this.amount = amount;
	}
	public String getPlanName() {
		return planName;
	}
	public void setPlanName(String planName) {
		this.planName = planName;
	}
	
	public String getInsName() {
	
		return insName;
	}
	
	public void setInsName(String insName) {
	
		this.insName = insName;
	}
	
	public String getSqe() {
	
		return sqe;
	}
	
	public void setSqe(String sqe) {
	
		this.sqe = sqe;
	}
	
	public String getDeliverName() {
	
		return deliverName;
	}
	
	public void setDeliverName(String deliverName) {
	
		this.deliverName = deliverName;
	}
	public Long getSumamount() {
		return sumamount;
	}
	public void setSumamount(Long sumamount) {
		this.sumamount = sumamount;
	}
 
}
