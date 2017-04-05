package cls.pilottery.web.sales.model;

import java.io.Serializable;

public class PlanModel implements Serializable {
	private static final long serialVersionUID = 708372137230341292L;
	private String planCode;	//方案编码
	private String planName;	//方案名称
	private int ticketAmount;	//票面金额
	private int packTickets;	//每本票数
	private long packAmount;	//每本金额
	private int trunkPacks;		//每箱本数
	private int boxPacks;		//每盒本数
	
	private int packages;
	private int tickets;
	private int amount;
	public String getPlanCode() {
		return planCode;
	}
	public void setPlanCode(String planCode) {
		this.planCode = planCode;
	}
	public String getPlanName() {
		return planName;
	}
	public int getTicketAmount() {
		return ticketAmount;
	}
	public void setTicketAmount(int ticketAmount) {
		this.ticketAmount = ticketAmount;
	}
	public void setPlanName(String planName) {
		this.planName = planName;
	}
	public int getPackTickets() {
		return packTickets;
	}
	public void setPackTickets(int packTickets) {
		this.packTickets = packTickets;
	}
	public long getPackAmount() {
		return packAmount;
	}
	public void setPackAmount(long packAmount) {
		this.packAmount = packAmount;
	}
	public int getTrunkPacks() {
		return trunkPacks;
	}
	public void setTrunkPacks(int trunkPacks) {
		this.trunkPacks = trunkPacks;
	}
	public int getBoxPacks() {
		return boxPacks;
	}
	public void setBoxPacks(int boxPacks) {
		this.boxPacks = boxPacks;
	}
	public int getPackages() {
		return packages;
	}
	public void setPackages(int packages) {
		this.packages = packages;
	}
	public int getTickets() {
		return tickets;
	}
	public void setTickets(int tickets) {
		this.tickets = tickets;
	}
	public int getAmount() {
		return amount;
	}
	public void setAmount(int amount) {
		this.amount = amount;
	}
}	
