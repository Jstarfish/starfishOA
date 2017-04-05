package cls.pilottery.web.report.model;

import java.io.Serializable;

public class OrgInventoryDaliyReportVo implements Serializable{
	private static final long serialVersionUID = -6341067046254154349L;
	private String calcDate;
	private String institutionCode;
	private String institutionName;
	private String planCode;
	private String planName;
	private Long beginTickets;
	private Long  receiptTickets;
	private Long  issueTickets;
	private Long  salesTickets;
	private Long  returnTickets;
	private Long  damageTickets;
	private Long  inventoryTickets;
	public String getCalcDate() {
		return calcDate;
	}
	public void setCalcDate(String calcDate) {
		this.calcDate = calcDate;
	}
	public String getInstitutionCode() {
		return institutionCode;
	}
	public void setInstitutionCode(String institutionCode) {
		this.institutionCode = institutionCode;
	}
	public String getInstitutionName() {
		return institutionName;
	}
	public void setInstitutionName(String institutionName) {
		this.institutionName = institutionName;
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
	public Long getIssueTickets() {
		return issueTickets;
	}
	public void setIssueTickets(Long issueTickets) {
		this.issueTickets = issueTickets;
	}
	public Long getSalesTickets() {
		return salesTickets;
	}
	public void setSalesTickets(Long salesTickets) {
		this.salesTickets = salesTickets;
	}
	public Long getReturnTickets() {
		return returnTickets;
	}
	public void setReturnTickets(Long returnTickets) {
		this.returnTickets = returnTickets;
	}
	public Long getDamageTickets() {
		return damageTickets;
	}
	public void setDamageTickets(Long damageTickets) {
		this.damageTickets = damageTickets;
	}
	public Long getInventoryTickets() {
		return inventoryTickets;
	}
	public void setInventoryTickets(Long inventoryTickets) {
		this.inventoryTickets = inventoryTickets;
	}
	public Long getBeginTickets() {
		return beginTickets;
	}
	public void setBeginTickets(Long beginTickets) {
		this.beginTickets = beginTickets;
	}
	
}
