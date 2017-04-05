package cls.pilottery.web.marketManager.entity;

import java.io.Serializable;
import java.util.Date;

public class AccountBalance implements Serializable{

	/**
	 * 市场管理员账户余额查询实体类
	 */
	private static final long serialVersionUID = -3745593876175663355L;
	
	private String  marketAdmin; //MARKET_ADMIN
	
	private Long accountBalance;
	
	private Long creditLimit;
	
	private Long maxAmountTickets; //MAX_AMOUNT_TICKETSS
	
	private Date repayTime;    //REPAY_TIME
	
	private Long repayAmount;   //REPAY_AMOUNT

	public String getMarketAdmin() {
		return marketAdmin;
	}

	public void setMarketAdmin(String marketAdmin) {
		this.marketAdmin = marketAdmin;
	}

	public Long getAccountBalance() {
		return accountBalance;
	}

	public void setAccountBalance(Long accountBalance) {
		this.accountBalance = accountBalance;
	}

	public Long getCreditLimit() {
		return creditLimit;
	}

	public void setCreditLimit(Long creditLimit) {
		this.creditLimit = creditLimit;
	}

	public Long getMaxAmountTickets() {
		return maxAmountTickets;
	}

	public void setMaxAmountTickets(Long maxAmountTickets) {
		this.maxAmountTickets = maxAmountTickets;
	}

	public Date getRepayTime() {
		return repayTime;
	}

	public void setRepayTime(Date repayTime) {
		this.repayTime = repayTime;
	}

	public Long getRepayAmount() {
		return repayAmount;
	}

	public void setRepayAmount(Long repayAmount) {
		this.repayAmount = repayAmount;
	}
	
	

}
