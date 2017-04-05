package cls.pilottery.web.sales.entity;

import java.io.Serializable;

public class DeliveryOrderRelation implements Serializable {
	private static final long serialVersionUID = 8838431310666763817L;
	private String doNo; 
	private String orderNo;
	public String getDoNo() {
		return doNo;
	}
	public void setDoNo(String doNo) {
		this.doNo = doNo;
	}
	public String getOrderNo() {
		return orderNo;
	}
	public void setOrderNo(String orderNo) {
		this.orderNo = orderNo;
	}
}
