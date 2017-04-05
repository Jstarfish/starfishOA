package cls.pilottery.web.capital.form;

import java.util.Date;

import cls.pilottery.common.model.BaseEntity;

public class CashWithdrawnForm extends BaseEntity {

	private static final long serialVersionUID = -2572705597999860490L;
	private String fundNo; // 提现编号（FW12345678）
	private Integer accountType; // 账户类型（1-机构，2-站点） ACCOUNT_TYPE
	private String aoCode;
	private String aoName;
	private String accNo;
	private Long applyAmount; // 提现金额 APPLY_AMOUNT
	private Long applyAdmin;
	private String applyDate; // 提现金额 APPLY_DATE
	private int applyStatus;
	private String applyMemo; // 备注 APPLY_MEMO

	private Long accountBalance; // 账户余额 account_balance

	private Date applyCheckTime; // APPLY_CHECK_TIME 提现审核时间
	private int checkAdminId; // CHECK_ADMIN_ID 提现审核人
	
	private Integer checkResult;   //审批结果，1 通过 2 拒绝
	
	private String afterAccountBalance; // af_account_balance 为了页面显示 String型  有null的
	
	
	public String getAfterAccountBalance() {
		return afterAccountBalance;
	}

	public void setAfterAccountBalance(String afterAccountBalance) {
		this.afterAccountBalance = afterAccountBalance;
	}

	public Integer getCheckResult() {
		return checkResult;
	}

	public void setCheckResult(Integer checkResult) {
		this.checkResult = checkResult;
	}

	public Date getApplyCheckTime() {
		return applyCheckTime;
	}

	public void setApplyCheckTime(Date applyCheckTime) {
		this.applyCheckTime = applyCheckTime;
	}

	public int getCheckAdminId() {
		return checkAdminId;
	}

	public void setCheckAdminId(int checkAdminId) {
		this.checkAdminId = checkAdminId;
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

	public String getApplyDate() {
		return applyDate;
	}

	public void setApplyDate(String applyDate) {
		this.applyDate = applyDate;
	}

	public int getApplyStatus() {
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
