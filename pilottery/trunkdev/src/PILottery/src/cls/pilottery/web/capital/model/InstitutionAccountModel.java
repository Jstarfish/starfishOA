package cls.pilottery.web.capital.model;

import java.io.Serializable;

public class InstitutionAccountModel implements Serializable {

	private static final long serialVersionUID = 567088527399082174L;
	private String orgCode;

	private Long creditLimit;

	private String orgName;

	private String saleComm;

	private String payComm;

	private String planName;

	private String planCode;

	public Long getCreditLimit() {
		return creditLimit;
	}

	public String getOrgCode() {
		return orgCode;
	}

	public String getOrgName() {
		return orgName;
	}

	public String getPayComm() {
		return payComm;
	}

	public String getPlanCode() {
		return planCode;
	}

	public String getPlanName() {
		return planName;
	}

	public String getSaleComm() {
		return saleComm;
	}

	public void setCreditLimit(Long creditLimit) {
		this.creditLimit = creditLimit;
	}

	public void setOrgCode(String orgCode) {
		this.orgCode = orgCode;
	}

	public void setOrgName(String orgName) {
		this.orgName = orgName;
	}

	public void setPayComm(String payComm) {
		this.payComm = payComm;
	}

	public void setPlanCode(String planCode) {
		this.planCode = planCode;
	}

	public void setPlanName(String planName) {
		this.planName = planName;
	}

	public void setSaleComm(String saleComm) {
		this.saleComm = saleComm;
	}

}
