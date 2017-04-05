package cls.pilottery.web.capital.model.balancemodel;

import java.io.Serializable;
import java.util.Date;

public class Balance implements Serializable {

	private static final long serialVersionUID = -4440915141038412982L;
	private String orgCode; // ORG_CODE
	private Long creditLimit; // ACCOUNT_BALANCE
	private Long accountBalance; // CREDIT_LIMIT

	private Long applyAmount; // APPLY_AMOUNT
	private Date applyDate; // APPLY_DATE

	public String getOrgCode() {
		return orgCode;
	}

	public void setOrgCode(String orgCode) {
		this.orgCode = orgCode;
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

	public Long getApplyAmount() {
		return applyAmount;
	}

	public void setApplyAmount(Long applyAmount) {
		this.applyAmount = applyAmount;
	}

	public Date getApplyDate() {
		return applyDate;
	}

	public void setApplyDate(Date applyDate) {
		this.applyDate = applyDate;
	}

}
