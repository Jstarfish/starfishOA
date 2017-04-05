package cls.pilottery.web.report.model;

import java.io.Serializable;

public class OutletInventoryDaliyReportVo implements Serializable{
	private static final long serialVersionUID = -6341067046254154349L;
	private String calcDate;
	private String outletCode;
	private String outletName;
	private String planCode;
	private String planName;
	private Long  receiptTickets;
	private Long  returnTickets;
	private Long  inventoryTickets;
	public String getCalcDate() {
		return calcDate;
	}
	public void setCalcDate(String calcDate) {
		this.calcDate = calcDate;
	}
	public String getOutletCode() {
		return outletCode;
	}
	public void setOutletCode(String outletCode) {
		this.outletCode = outletCode;
	}
	public String getOutletName() {
		return outletName;
	}
	public void setOutletName(String outletName) {
		this.outletName = outletName;
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
	public Long getReceiptTickets() {
		return receiptTickets;
	}
	public void setReceiptTickets(Long receiptTickets) {
		this.receiptTickets = receiptTickets;
	}
	public Long getReturnTickets() {
		return returnTickets;
	}
	public void setReturnTickets(Long returnTickets) {
		this.returnTickets = returnTickets;
	}
	public Long getInventoryTickets() {
		return inventoryTickets;
	}
	public void setInventoryTickets(Long inventoryTickets) {
		this.inventoryTickets = inventoryTickets;
	}
}
