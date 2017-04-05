package cls.pilottery.web.capital.model;

import java.io.Serializable;

public class ManagerAccount implements Serializable {

	/**
	 * 市场管理员账户信息
	 */
	private static final long serialVersionUID = -9178442116800901107L;

	private Long marketAdmin;
	private Integer accType;
	private String accName;
	private Integer accStatus;
	private String accNo;
	private Long creditLimit;
	private Long accountBalance;
	private String checkCode;

	private String realName;
	private Integer isCollecter;

	private String transPass;

	private Long credit;  //每笔交易限额
	
	private Long maxAmountTickets;  //最大赊票金额
	private Long tickets;  //管理员持票数
	
	

	public Long getMaxAmountTickets() {
		return maxAmountTickets;
	}

	public void setMaxAmountTickets(Long maxAmountTickets) {
		this.maxAmountTickets = maxAmountTickets;
	}


	public Long getTickets() {
		return tickets;
	}

	public void setTickets(Long tickets) {
		this.tickets = tickets;
	}

	public Long getCredit() {
		return credit;
	}

	public void setCredit(Long credit) {
		this.credit = credit;
	}

	public String getTransPass() {
		return transPass;
	}

	public void setTransPass(String transPass) {
		this.transPass = transPass;
	}

	public String getRealName() {
		return realName;
	}

	public void setRealName(String realName) {
		this.realName = realName;
	}

	public Integer getIsCollecter() {
		return isCollecter;
	}

	public void setIsCollecter(Integer isCollecter) {
		this.isCollecter = isCollecter;
	}

	public Long getMarketAdmin() {
		return marketAdmin;
	}

	public void setMarketAdmin(Long marketAdmin) {
		this.marketAdmin = marketAdmin;
	}

	public Integer getAccType() {
		return accType;
	}

	public void setAccType(Integer accType) {
		this.accType = accType;
	}

	public String getAccName() {
		return accName;
	}

	public void setAccName(String accName) {
		this.accName = accName;
	}

	public Integer getAccStatus() {
		return accStatus;
	}

	public void setAccStatus(Integer accStatus) {
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

	public String getCheckCode() {
		return checkCode;
	}

	public void setCheckCode(String checkCode) {
		this.checkCode = checkCode;
	}

	public static long getSerialversionuid() {
		return serialVersionUID;
	}

}
