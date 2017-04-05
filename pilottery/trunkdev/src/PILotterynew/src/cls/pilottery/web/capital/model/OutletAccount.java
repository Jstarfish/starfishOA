package cls.pilottery.web.capital.model;

import java.io.Serializable;
import java.util.List;

import cls.pilottery.common.model.BaseEntity;

public class OutletAccount extends BaseEntity implements Serializable   {
	/**
	 * 站点账户信息实体类
	 */
	private static final long serialVersionUID = -4353487619826457471L;

	private List<OutletCommRate> outletCommRate;
	
	private String agencyCode;

	private String agencyName;
	
	private Short accType;

	private String accName;

	private Short accStatus;

	private String accNo;

	private Long creditLimit;

	private Long accountBalance;

	private Long frozenBalance;

	private String checkCode;

	public String getAgencyCode() {
		return agencyCode;
	}

	public void setAgencyCode(String agencyCode) {
		this.agencyCode = agencyCode;
	}

	public Short getAccType() {
		return accType;
	}

	
	public String getAgencyName() {
		return agencyName;
	}

	public void setAgencyName(String agencyName) {
		this.agencyName = agencyName;
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

	public String getAccNo() {
		return accNo;
	}

	public void setAccNo(String accNo) {
		this.accNo = accNo;
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

	public List<OutletCommRate> getOutletCommRate() {
		return outletCommRate;
	}

	public void setOutletCommRate(List<OutletCommRate> outletCommRate) {
		this.outletCommRate = outletCommRate;
	}

}
