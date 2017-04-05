package cls.pilottery.web.goodsIssues.model;

public class SaleDeliverOrderDetail {
	private String doNO;// 出库单
	private String planCode;// 方案
	private Long tickets;// 票数
	private Long amount;// 金额
	private Long pack;//本数
	private String planName;

	public String getDoNO() {
		return doNO;
	}

	public void setDoNO(String doNO) {
		this.doNO = doNO;
	}

	public String getPlanCode() {
		return planCode;
	}

	public void setPlanCode(String planCode) {
		this.planCode = planCode;
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

	public Long getPack() {
		return pack;
	}

	public void setPack(Long pack) {
		this.pack = pack;
	}

	public String getPlanName() {
		return planName;
	}

	public void setPlanName(String planName) {
		this.planName = planName;
	}

}
