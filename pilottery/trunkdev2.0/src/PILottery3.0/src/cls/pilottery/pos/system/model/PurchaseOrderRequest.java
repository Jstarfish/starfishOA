package cls.pilottery.pos.system.model;

import java.io.Serializable;

public class PurchaseOrderRequest implements Serializable {
	private static final long serialVersionUID = -712623737312228440L;
	private String outletCode;
	private String status;
	private String follow;
	private int count;
	public String getOutletCode() {
		return outletCode;
	}
	public void setOutletCode(String outletCode) {
		this.outletCode = outletCode;
	}
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}
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
