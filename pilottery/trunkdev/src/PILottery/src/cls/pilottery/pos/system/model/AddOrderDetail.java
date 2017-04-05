package cls.pilottery.pos.system.model;

import java.io.Serializable;

public class AddOrderDetail implements Serializable {
	private static final long serialVersionUID = 179198766946655096L;
	
	private String goodsTag;
	private int tickets;
	public String getGoodsTag() {
		return goodsTag;
	}
	public void setGoodsTag(String goodsTag) {
		this.goodsTag = goodsTag;
	}
	public int getTickets() {
		return tickets;
	}
	public void setTickets(int tickets) {
		this.tickets = tickets;
	}
}
