package cls.pilottery.web.report.model;

import java.io.Serializable;

public class SalesReportModel implements Serializable {
	private static final long serialVersionUID = 3602043606038751652L;
	private String saleDate;
	private String gameName;
	private String orgName;
	private long salesAmount;
	private long salesCommission;
	private long payoutAmount;
	private long payoutCommission;
	private long returnAmount;
	private long returnCommission;
	private long cashIncome;
	private String institutionName;
	public String getSaleDate() {
		return saleDate;
	}
	public void setSaleDate(String saleDate) {
		this.saleDate = saleDate;
	}
	public String getGameName() {
		return gameName;
	}
	public void setGameName(String gameName) {
		this.gameName = gameName;
	}
	public String getOrgName() {
		return orgName;
	}
	public void setOrgName(String orgName) {
		this.orgName = orgName;
	}
	public long getSalesAmount() {
		return salesAmount;
	}
	public void setSalesAmount(long salesAmount) {
		this.salesAmount = salesAmount;
	}
	public long getSalesCommission() {
		return salesCommission;
	}
	public void setSalesCommission(long salesCommission) {
		this.salesCommission = salesCommission;
	}
	public long getPayoutAmount() {
		return payoutAmount;
	}
	public void setPayoutAmount(long payoutAmount) {
		this.payoutAmount = payoutAmount;
	}
	public long getPayoutCommission() {
		return payoutCommission;
	}
	public void setPayoutCommission(long payoutCommission) {
		this.payoutCommission = payoutCommission;
	}
	public long getCashIncome() {
		return cashIncome;
	}
	public void setCashIncome(long cashIncome) {
		this.cashIncome = cashIncome;
	}
	public String getInstitutionName() {
		return institutionName;
	}
	public void setInstitutionName(String institutionName) {
		this.institutionName = institutionName;
	}
	public long getReturnAmount() {
		return returnAmount;
	}
	public void setReturnAmount(long returnAmount) {
		this.returnAmount = returnAmount;
	}
	public long getReturnCommission() {
		return returnCommission;
	}
	public void setReturnCommission(long returnCommission) {
		this.returnCommission = returnCommission;
	}
}
