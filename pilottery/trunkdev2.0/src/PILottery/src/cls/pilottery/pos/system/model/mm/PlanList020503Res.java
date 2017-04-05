package cls.pilottery.pos.system.model.mm;

import java.io.Serializable;

public class PlanList020503Res implements Serializable {
	private static final long serialVersionUID = -3564900656040769965L;
	private String plan;
	private long amount;
	private int tickets;
	public String getPlan() {
		return plan;
	}
	public void setPlan(String plan) {
		this.plan = plan;
	}
	public long getAmount() {
		return amount;
	}
	public void setAmount(long amount) {
		this.amount = amount;
	}
	public int getTickets() {
		return tickets;
	}
	public void setTickets(int tickets) {
		this.tickets = tickets;
	}
}
