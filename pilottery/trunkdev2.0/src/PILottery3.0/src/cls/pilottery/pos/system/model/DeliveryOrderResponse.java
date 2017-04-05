package cls.pilottery.pos.system.model;

import java.io.Serializable;
import java.util.List;

public class DeliveryOrderResponse implements Serializable {
	private static final long serialVersionUID = -3082957026454217501L;
	private String follow;
	private List<PosDeliveryOrder> deliveryList ;
	public String getFollow() {
		return follow;
	}
	public void setFollow(String follow) {
		this.follow = follow;
	}
	public List<PosDeliveryOrder> getDeliveryList() {
		return deliveryList;
	}
	public void setDeliveryList(List<PosDeliveryOrder> deliveryList) {
		this.deliveryList = deliveryList;
	}
}
