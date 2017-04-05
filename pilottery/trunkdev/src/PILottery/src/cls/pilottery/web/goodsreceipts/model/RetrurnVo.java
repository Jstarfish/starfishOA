package cls.pilottery.web.goodsreceipts.model;

public class RetrurnVo {
	private String marketManager;
	private String orgName;
	private String applyDate;
	private String planCode;
	private String planName;
	private Long tickets;
	private Long amount;

	public String getMarketManager() {
		return marketManager;
	}

	public void setMarketManager(String marketManager) {
		this.marketManager = marketManager;
	}

	public String getPlanCode() {
		return planCode;
	}

	public void setPlanCode(String planCode) {
		this.planCode = planCode;
	}

	public String getPlanName() {
		return planName;
	}

	public void setPlanName(String planName) {
		this.planName = planName;
	}

	public Long getTickets() {
		return tickets;
	}

	public void setTickets(Long tickets) {
		this.tickets = tickets;
	}

	public Long getAmount() {
		return amount;
	}

	public void setAmount(Long amount) {
		this.amount = amount;
	}

	public String getApplyDate() {
		return applyDate;
	}

	public void setApplyDate(String applyDate) {
		this.applyDate = applyDate;
	}

	public String getOrgName() {
		return orgName;
	}

	public void setOrgName(String orgName) {
		this.orgName = orgName;
	}

}
