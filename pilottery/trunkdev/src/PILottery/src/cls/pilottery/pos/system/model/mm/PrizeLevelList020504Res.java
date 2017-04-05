package cls.pilottery.pos.system.model.mm;

import java.io.Serializable;

public class PrizeLevelList020504Res implements Serializable {
	private static final long serialVersionUID = 6199312250690818291L;
	private long levelAmount;
	private long amount;
	private int tickets;
	public long getLevelAmount() {
		return levelAmount;
	}
	public void setLevelAmount(long levelAmount) {
		this.levelAmount = levelAmount;
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
