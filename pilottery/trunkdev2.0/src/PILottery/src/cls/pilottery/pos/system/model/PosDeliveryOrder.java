package cls.pilottery.pos.system.model;

import java.io.Serializable;

import cls.pilottery.common.EnumConfigEN;

public class PosDeliveryOrder implements Serializable {

	private static final long serialVersionUID = 6083973648513696119L;
	private String deliveryOrder;
	private String time;
	private int tickets;
	private long amount;
	private String status;

	public String getDeliveryOrder() {
		return deliveryOrder;
	}

	public void setDeliveryOrder(String deliveryOrder) {
		this.deliveryOrder = deliveryOrder;
	}

	public String getTime() {
		return time;
	}

	public void setTime(String time) {
		this.time = time;
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

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = EnumConfigEN.deliveryOrderStatus.get(Integer.parseInt(status)) == null ? "" : EnumConfigEN.deliveryOrderStatus.get(Integer.parseInt(status));
	}
}
