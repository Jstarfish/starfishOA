package cls.pilottery.web.capital.model;

import java.io.Serializable;

public class MarketManager implements Serializable {
	/**
	 * 市场管理员信息实体类
	 */
	private static final long serialVersionUID = -8623846171539189444L;

	private Long marketAdmin;

	private String transPass; // 交易密码

	private Long credit; // 每笔交易限额

	private Long maxAmountTickets; // MAX_AMOUNT_TICKETSS

	public Long getMaxAmountTickets() {
		return maxAmountTickets;
	}

	public void setMaxAmountTickets(Long maxAmountTickets) {
		this.maxAmountTickets = maxAmountTickets;
	}

	public Long getMarketAdmin() {
		return marketAdmin;
	}

	public void setMarketAdmin(Long marketAdmin) {
		this.marketAdmin = marketAdmin;
	}

	public String getTransPass() {
		return transPass;
	}

	public void setTransPass(String transPass) {
		this.transPass = transPass;
	}

	public Long getCredit() {
		return credit;
	}

	public void setCredit(Long credit) {
		this.credit = credit;
	}

}
