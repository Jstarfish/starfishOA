package cls.pilottery.web.marketManager.model;

import java.io.Serializable;

public class DamageSumModel implements Serializable {
	private static final long serialVersionUID = 1160657764629153183L;
	private int damagePackage;	
	private int packTickets;
	private int ticketAmount;
	public int getDamagePackage() {
		return damagePackage;
	}
	public void setDamagePackage(int damagePackage) {
		this.damagePackage = damagePackage;
	}
	public int getPackTickets() {
		return packTickets;
	}
	public void setPackTickets(int packTickets) {
		this.packTickets = packTickets;
	}
	public int getTicketAmount() {
		return ticketAmount;
	}
	public void setTicketAmount(int ticketAmount) {
		this.ticketAmount = ticketAmount;
	}
}
