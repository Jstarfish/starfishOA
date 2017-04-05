package cls.pilottery.pos.system.model;

import java.io.Serializable;

public class DoDetailRequest implements Serializable {
	private static final long serialVersionUID = -8143557474718310259L;
	private String deliveryOrder;

	public String getDeliveryOrder() {
		return deliveryOrder;
	}

	public void setDeliveryOrder(String deliveryOrder) {
		this.deliveryOrder = deliveryOrder;
	}
}
