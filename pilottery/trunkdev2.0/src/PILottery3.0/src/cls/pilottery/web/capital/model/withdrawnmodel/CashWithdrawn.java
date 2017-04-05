package cls.pilottery.web.capital.model.withdrawnmodel;

import java.io.Serializable;
import java.util.Date;

import cls.pilottery.common.EnumConfigEN;

public class CashWithdrawn implements Serializable {

	/**
	 * 部门还款实体类
	 */
	private static final long serialVersionUID = 205891323930886772L;
	private String fundNo; // 提现编号（FW12345678）
	private Integer accountType; // 账户类型（1-机构，2-站点） ACCOUNT_TYPE
	private String aoCode;
	private String aoName;
	private String accNo;
	private Long applyAmount; // 提现金额 APPLY_AMOUNT
	private String applyAdmin;
	private Date applyDate; // 提现日期 APPLY_DATE

	private int applyStatus;

	private String applyMemo; // 备注 APPLY_MEMO

	private Integer isTerminalApply; // 是否是终端提现IS_TERMINAL_APPLY
	private Long accountBalance; // 账户余额 account_balance

	private Date applyCheckTime; // APPLY_CHECK_TIME 提现审核时间
	private Integer checkAdminId; // CHECK_ADMIN_ID 提现审核人

	private String realName;

	private String afterAccountBalance;

	public String getAfterAccountBalance() {
		return afterAccountBalance;
	}

	public void setAfterAccountBalance(String afterAccountBalance) {
		this.afterAccountBalance = afterAccountBalance;
	}

	public String getRealName() {
		return realName;
	}

	public void setRealName(String realName) {
		this.realName = realName;
	}

	public static long getSerialversionuid() {
		return serialVersionUID;
	}

	public Date getApplyCheckTime() {
		return applyCheckTime;
	}

	public void setApplyCheckTime(Date applyCheckTime) {
		this.applyCheckTime = applyCheckTime;
	}

	public Integer getCheckAdminId() {
		return checkAdminId;
	}

	public void setCheckAdminId(Integer checkAdminId) {
		this.checkAdminId = checkAdminId;
	}

	public Integer getIsTerminalApply() {
		return isTerminalApply;
	}

	public void setIsTerminalApply(Integer isTerminalApply) {
		this.isTerminalApply = isTerminalApply;
	}

	public Long getAccountBalance() {
		return accountBalance;
	}

	public void setAccountBalance(Long accountBalance) {
		this.accountBalance = accountBalance;
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

	public String getApplyAdmin() {
		return applyAdmin;
	}

	public void setApplyAdmin(String applyAdmin) {
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

	/*public void setApplyStatus(int applyStatus) {
		this.applyStatus = applyStatus;
		this.statusValue = EnumConfigEN.cashWithdrawnStatus.get(applyStatus);
	}*/
	
	

	
	public String getApplyMemo() {
		return applyMemo;
	}

	public void setApplyStatus(int applyStatus) {
		this.applyStatus = applyStatus;
	}

	public void setApplyMemo(String applyMemo) {
		this.applyMemo = applyMemo;
	}

}
