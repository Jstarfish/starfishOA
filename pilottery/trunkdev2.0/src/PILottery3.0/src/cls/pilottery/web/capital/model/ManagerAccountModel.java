package cls.pilottery.web.capital.model;

import java.io.Serializable;

public class ManagerAccountModel implements Serializable {

	/**
	 * 管理员账户查询需要的实体
	 */
	private static final long serialVersionUID = 3596670367019392111L;

	private Long marketAdmin;

	private String realName;

	private Long creditLimit; // 信用额度

	private Long accountBalance;

	private String transPass;

	private Long maxAmountTickets; // 管理员赊票金额

	public Long getMarketAdmin() {
		return marketAdmin;
	}

	public void setMarketAdmin(Long marketAdmin) {
		this.marketAdmin = marketAdmin;
	}

	public Long getAccountBalance() {
		return accountBalance;
	}

	public void setAccountBalance(Long accountBalance) {
		this.accountBalance = accountBalance;
	}

	public String getRealName() {
		return realName;
	}

	public void setRealName(String realName) {
		this.realName = realName;
	}

	public Long getCreditLimit() {
		return creditLimit;
	}

	public void setCreditLimit(Long creditLimit) {
		this.creditLimit = creditLimit;
	}

	public String getTransPass() {
		return transPass;
	}

	public void setTransPass(String transPass) {
		this.transPass = transPass;
	}

	public Long getMaxAmountTickets() {
		return maxAmountTickets;
	}

	public void setMaxAmountTickets(Long maxAmountTickets) {
		this.maxAmountTickets = maxAmountTickets;
	}

}
