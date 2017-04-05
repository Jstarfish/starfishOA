package cls.pilottery.web.outlet.form;

import java.util.Date;

import cls.pilottery.common.model.BaseEntity;

public class OutletCashWithdrawnForm extends BaseEntity {

	private static final long serialVersionUID = -2572705597999860490L;
	private String fundNo; // 提现编号（FW12345678）
	private Integer accountType; // 账户类型（1-机构，2-站点） ACCOUNT_TYPE
	private String aoCode;
	private String aoName;
	private String accNo;
	private Long applyAmount; // 提现金额 APPLY_AMOUNT
	private Long applyAdmin;
	private Date applyDate; // 提现日期 APPLY_DATE
	private Integer applyStatus;
	
	private String applyMemo; // 备注 APPLY_MEMO
	private Long accountBalance; // 账户余额 account_balance

	private int currentUserId; // 当前用户id

	

	public int getCurrentUserId() {
		return currentUserId;
	}

	public void setCurrentUserId(int currentUserId) {
		this.currentUserId = currentUserId;
	}

	public String getFundNo() {
		return fundNo;
	}

	public void setFundNo(String fundNo) {
		this.fundNo = fundNo;
	}

	public Integer getAccountType() {
		return accountType;
	}

	public void setAccountType(Integer accountType) {
		this.accountType = accountType;
	}

	public String getAoCode() {
		return aoCode;
	}

	public void setAoCode(String aoCode) {
		this.aoCode = aoCode;
	}

	public String getAoName() {
		return aoName;
	}

	public void setAoName(String aoName) {
		this.aoName = aoName;
	}

	public String getAccNo() {
		return accNo;
	}

	public void setAccNo(String accNo) {
		this.accNo = accNo;
	}

	public Long getApplyAmount() {
		return applyAmount;
	}

	public void setApplyAmount(Long applyAmount) {
		this.applyAmount = applyAmount;
	}

	public Long getApplyAdmin() {
		return applyAdmin;
	}

	public void setApplyAdmin(Long applyAdmin) {
		this.applyAdmin = applyAdmin;
	}

	public Date getApplyDate() {
		return applyDate;
	}

	public void setApplyDate(Date applyDate) {
		this.applyDate = applyDate;
	}

	public Integer getApplyStatus() {
		return applyStatus;
	}

	public void setApplyStatus(int applyStatus) {
		this.applyStatus = applyStatus;
	}

	public String getApplyMemo() {
		return applyMemo;
	}

	public void setApplyMemo(String applyMemo) {
		this.applyMemo = applyMemo;
	}

	public Long getAccountBalance() {
		return accountBalance;
	}

	public void setAccountBalance(Long accountBalance) {
		this.accountBalance = accountBalance;
	}

}
