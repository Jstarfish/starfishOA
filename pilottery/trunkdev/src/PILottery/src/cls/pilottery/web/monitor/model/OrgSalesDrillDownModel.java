package cls.pilottery.web.monitor.model;

import java.io.Serializable;

public class OrgSalesDrillDownModel implements Serializable {

	private static final long serialVersionUID = -388562998353531557L;

	private String planCode;
	private String fullName;
	private Long salesAmount;
	private Long income;
	
	public String getPlanCode() {
		return planCode;
	}
	public void setPlanCode(String planCode) {
		this.planCode = planCode == null ? null : planCode.trim();
	}
	
	public String getFullName() {
		return fullName;
	}
	public void setFullName(String fullName) {
		this.fullName = fullName == null ? null : fullName.trim();
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
