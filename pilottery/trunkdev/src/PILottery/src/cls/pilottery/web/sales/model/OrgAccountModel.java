package cls.pilottery.web.sales.model;

import java.io.Serializable;

public class OrgAccountModel implements Serializable {
	private static final long serialVersionUID = 3713168887445110162L;

	private String orgCode;
	private String orgName;
	private int accountType;
	private int accountStatus;
	private String accountNo;
	private long credit;
	private long balance;
	private long frozenBalance;
	private String checkCode;
	private int orgType;
	public String getOrgCode() {
		return orgCode;
	}
	public void setOrgCode(String orgCode) {
		this.orgCode = orgCode;
	}
	public String getOrgName() {
		return orgName;
	}
	public void setOrgName(String orgName) {
		this.orgName = orgName;
	}
	public long getCredit() {
		return credit;
	}
	public void setCredit(long credit) {
		this.credit = credit;
	}
	public long getBalance() {
		return balance;
	}
	public void setBalance(long balance) {
		this.balance = balance;
	}
	public long getFrozenBalance() {
		return frozenBalance;
	}
	public void setFrozenBalance(long frozenBalance) {
		this.frozenBalance = frozenBalance;
	}
	public String getCheckCode() {
		return checkCode;
	}
	public void setCheckCode(String checkCode) {
		this.checkCode = checkCode;
	}
	public int getAccountType() {
		return accountType;
	}
	public void setAccountType(int accountType) {
		this.accountType = accountType;
	}
	public int getAccountStatus() {
		return accountStatus;
	}
	public void setAccountStatus(int accountStatus) {
		this.accountStatus = accountStatus;
	}
	public String getAccountNo() {
		return accountNo;
	}
	public void setAccountNo(String accountNo) {
		this.accountNo = accountNo;
	}
	public int getOrgType() {
		return orgType;
	}
	public void setOrgType(int orgType) {
		this.orgType = orgType;
	}
}
