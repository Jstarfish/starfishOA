package cls.pilottery.web.capital.model;

import java.io.Serializable;


/*
 * 王清响为做还款加的model，主要是因为其他类似的model得不到全部需要的字段
 */
public class MarketManagerAccount implements Serializable {

	private static final long serialVersionUID = 5916866796917616629L;

	private Integer   marketAdmin;     //市场管理员编码
	private String    adminRealName;   //真实姓名（外表字段）
	private Integer   accountType;     //账户类型（1-主要账户）
	private String    accountName;     //账户名称
	private Integer   accountStatus;   //账户状态（1-可用，2-停用，3-异常）
	private String    accountNo;       //账户编码（MM+4位用户编号+6位顺序）//主键
	private Long      creditLimit;     //信用额度
	private Long      accountBalance;  //可用余额
	private String    checkCode;       //校验码（全部）
	
	public Integer getMarketAdmin() {
		return marketAdmin;
	}
	public void setMarketAdmin(Integer marketAdmin) {
		this.marketAdmin = marketAdmin;
	}
	
	public String getAdminRealName() {
		return adminRealName;
	}
	public void setAdminRealName(String adminRealName) {
		this.adminRealName = adminRealName == null ? null : adminRealName.trim();
	}
	
	public Integer getAccountType() {
		return accountType;
	}
	public void setAccountType(Integer accountType) {
		this.accountType = accountType;
	}
	
	public String getAccountName() {
		return accountName;
	}
	public void setAccountName(String accountName) {
		this.accountName = accountName == null ? null : accountName.trim();
	}
	
	public Integer getAccountStatus() {
		return accountStatus;
	}
	public void setAccountStatus(Integer accountStatus) {
		this.accountStatus = accountStatus;
	}
	
	public String getAccountNo() {
		return accountNo;
	}
	public void setAccountNo(String accountNo) {
		this.accountNo = accountNo == null ? null : accountNo.trim();
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
	
	public String getCheckCode() {
		return checkCode;
	}
	public void setCheckCode(String checkCode) {
		this.checkCode = checkCode == null ? null : checkCode.trim();
	}
}
