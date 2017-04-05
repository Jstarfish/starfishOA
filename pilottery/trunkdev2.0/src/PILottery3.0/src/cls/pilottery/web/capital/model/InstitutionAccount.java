package cls.pilottery.web.capital.model;

import java.io.Serializable;
import java.util.List;

import cls.pilottery.web.institutions.model.InfOrgs;

public class InstitutionAccount implements Serializable {

	/**
	 * 组织机构即代理商实体类
	 */
	private static final long serialVersionUID = 2384554155230338031L;

	private List<InstitutionCommRate> institutionCommRate;

	private String orgCode;

	private String orgName;

	public String getOrgName() {
		return orgName;
	}

	public void setOrgName(String orgName) {
		this.orgName = orgName;
	}

	private Short accType;

	private String accName;

	private Short accStatus;

	private String accNo;

	private Long creditLimit;

	private Long accountBalance;

	private Long frozenBalance;

	private String checkCode;

	private List<InfOrgs> infOrgs;

	public List<InstitutionCommRate> getInstitutionCommRate() {
		return institutionCommRate;
	}

	public void setInstitutionCommRate(
			List<InstitutionCommRate> institutionCommRate) {
		this.institutionCommRate = institutionCommRate;
	}

	public List<InfOrgs> getInfOrgs() {
		return infOrgs;
	}

	public void setInfOrgs(List<InfOrgs> infOrgs) {
		this.infOrgs = infOrgs;
	}

	public String getAccNo() {
		return accNo;
	}

	public void setAccNo(String accNo) {
		this.accNo = accNo;
	}

	public String getOrgCode() {
		return orgCode;
	}

	public void setOrgCode(String orgCode) {
		this.orgCode = orgCode;
	}

	public Short getAccType() {
		return accType;
	}

	public void setAccType(Short accType) {
		this.accType = accType;
	}

	public String getAccName() {
		return accName;
	}

	public void setAccName(String accName) {
		this.accName = accName;
	}

	public Short getAccStatus() {
		return accStatus;
	}

	public void setAccStatus(Short accStatus) {
		this.accStatus = accStatus;
	}

	public Long getCreditLimit() {
		return creditLimit;
	}

	public void setCreditLimit(Long creditLimit) {
		this.creditLimit = creditLimit;
	}

	public Long getAccountBalance() {
		return accountBalance;
	}

	public void setAccountBalance(Long accountBalance) {
		this.accountBalance = accountBalance;
	}

	public Long getFrozenBalance() {
		return frozenBalance;
	}

	public void setFrozenBalance(Long frozenBalance) {
		this.frozenBalance = frozenBalance;
	}

	public String getCheckCode() {
		return checkCode;
	}

	public void setCheckCode(String checkCode) {
		this.checkCode = checkCode;
	}

	public static long getSerialversionuid() {
		return serialVersionUID;
	}

	@Override
	public String toString() {
		return "InstitutionAccount [institutionCommRate=" + institutionCommRate
				+ ", orgCode=" + orgCode + ", accType=" + accType
				+ ", accName=" + accName + ", accStatus=" + accStatus
				+ ", accNo=" + accNo + ", creditLimit=" + creditLimit
				+ ", accountBalance=" + accountBalance + ", frozenBalance="
				+ frozenBalance + ", checkCode=" + checkCode + ", infOrgs="
				+ infOrgs + "]";
	}

}
