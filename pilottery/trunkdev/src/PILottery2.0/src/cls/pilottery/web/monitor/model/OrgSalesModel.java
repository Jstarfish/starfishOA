package cls.pilottery.web.monitor.model;

import java.io.Serializable;

public class OrgSalesModel implements Serializable {

	private static final long serialVersionUID = -5801982947249199077L;

	private String orgCode;
	private String orgName;
	private Long salesAmount;
	private Long income;
	
	public String getOrgCode() {
		return orgCode;
	}
	public void setOrgCode(String orgCode) {
		this.orgCode = orgCode == null ? null : orgCode.trim();
	}
	
	public String getOrgName() {
		return orgName;
	}
	public void setOrgName(String orgName) {
		this.orgName = orgName == null ? null : orgName.trim();
	}
	
	public Long getSalesAmount() {
		return salesAmount;
	}
	public void setSalesAmount(Long salesAmount) {
		this.salesAmount = salesAmount;
	}
	
	public Long getIncome() {
		return income;
	}
	public void setIncome(Long income) {
		this.income = income;
	}
}
