package cls.pilottery.web.goodsIssues.model;

public class GoodsIssuesStockDetailVo {
	private String planCode;
	private String planName;
	private Long tickets;
	private Long amount;
	private Long tickAmount;//票面金额
    private String batchNo;
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

	public Long getTickAmount() {
		return tickAmount;
	}

	public void setTickAmount(Long tickAmount) {
		this.tickAmount = tickAmount;
	}

	public String getBatchNo() {
		return batchNo;
	}

	public void setBatchNo(String batchNo) {
		this.batchNo = batchNo;
	}

}
