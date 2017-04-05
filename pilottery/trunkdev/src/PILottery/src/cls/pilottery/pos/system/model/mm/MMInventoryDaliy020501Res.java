package cls.pilottery.pos.system.model.mm;

import java.io.Serializable;

import cls.pilottery.common.EnumConfigEN;

public class MMInventoryDaliy020501Res implements Serializable {
	private static final long serialVersionUID = 6606399212420995013L;
	private String calcDate;
	private String type;
	private String plan;
	private int tickets;
	public String getCalcDate() {
		return calcDate;
	}
	public void setCalcDate(String calcDate) {
		this.calcDate = calcDate;
	}
	public String getType() {
		return type;
	}
	public void setType(String type) {
		this.type = EnumConfigEN.mmInventoryDaliyType.get(Integer.parseInt(type));
	}
	public String getPlan() {
		return plan;
	}
	public void setPlan(String plan) {
		this.plan = plan;
	}
	public int getTickets() {
		return tickets;
	}
	public void setTickets(int tickets) {
		this.tickets = tickets;
	}
}
