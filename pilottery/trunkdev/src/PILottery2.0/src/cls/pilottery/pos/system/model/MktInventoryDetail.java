package cls.pilottery.pos.system.model;

import java.io.Serializable;

public class MktInventoryDetail implements Serializable {
	private static final long serialVersionUID = -8177856009953039231L;
	private String planCode;
	private String planName;
	private int tickets;
	private long amount;
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
	public int getTickets() {
		return tickets;
	}
	public void setTickets(int tickets) {
		this.tickets = tickets;
	}
	public long getAmount() {
		return amount;
	}
	public void setAmount(long amount) {
		this.amount = amount;
	}
}
