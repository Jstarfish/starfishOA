package cls.pilottery.web.outlet.model;

import java.util.Date;

public class SaleAgencyReturnVo {
	private String  arAgency;//站点编号
	private String  agencyName;//站点名称
	private Long      tickets;//张数
	private Long      amount;//退货金额
	private Date     arDate;//退货时间
	private String aiNo;
	public String getArAgency() {
		return arAgency;
	}
	public void setArAgency(String arAgency) {
		this.arAgency = arAgency;
	}
	public String getAgencyName() {
		return agencyName;
	}
	public void setAgencyName(String agencyName) {
		this.agencyName = agencyName;
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
	public Date getArDate() {
		return arDate;
	}
	public void setArDate(Date arDate) {
		this.arDate = arDate;
	}
	public String getAiNo() {
		return aiNo;
	}
	public void setAiNo(String aiNo) {
		this.aiNo = aiNo;
	}
	
}
