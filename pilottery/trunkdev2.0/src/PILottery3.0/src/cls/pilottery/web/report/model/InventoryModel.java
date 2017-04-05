package cls.pilottery.web.report.model;

import java.io.Serializable;

public class InventoryModel implements Serializable {
	private static final long serialVersionUID = 7602799814613972119L;
	private String calcDate;
	private String gameName;
	private long amount;
	private int tickets;
	public String getCalcDate() {
		return calcDate;
	}
	public void setCalcDate(String calcDate) {
		this.calcDate = calcDate;
	}
	public String getGameName() {
		return gameName;
	}
	public void setGameName(String gameName) {
		this.gameName = gameName;
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
