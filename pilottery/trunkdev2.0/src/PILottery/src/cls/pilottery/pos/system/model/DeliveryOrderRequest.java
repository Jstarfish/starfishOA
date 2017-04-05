package cls.pilottery.pos.system.model;

import java.io.Serializable;

public class DeliveryOrderRequest implements Serializable {
	private static final long serialVersionUID = 6496282190334145025L;
	private String follow;
	private int count = 30;
	public String getFollow() {
		return follow;
	}
	public void setFollow(String follow) {
		this.follow = follow;
	}
	public int getCount() {
		return count;
	}
	public void setCount(int count) {
		this.count = count;
	}
}
