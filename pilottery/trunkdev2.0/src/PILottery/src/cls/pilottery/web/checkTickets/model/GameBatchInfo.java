package cls.pilottery.web.checkTickets.model;

import java.io.Serializable;

public class GameBatchInfo implements Serializable {

	private static final long serialVersionUID = 7543282924059978177L;
	
	private String planCode;
	private String planName;
	private Long amount;
	private String batchNo;
	private Long ticketsEveryGroup;
	
	public String getPlanCode() {
		return planCode;
	}
	public void setPlanCode(String planCode) {
		this.planCode = planCode == null ? null : planCode.trim();
	}
	
	public String getPlanName() {
		return planName;
	}
	public void setPlanName(String planName) {
		this.planName = planName == null ? null : planName.trim();
	}
	
	public Long getAmount() {
		return amount;
	}
	public void setAmount(Long amount) {
		this.amount = amount;
	}
	
	public String getBatchNo() {
		return batchNo;
	}
	public void setBatchNo(String batchNo) {
		this.batchNo = batchNo == null ? null : batchNo.trim();
	}
	
	public Long getTicketsEveryGroup() {
		return ticketsEveryGroup;
	}
	public void setTicketsEveryGroup(Long ticketsEveryGroup) {
		this.ticketsEveryGroup = ticketsEveryGroup;
	}
}
