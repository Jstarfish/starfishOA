package cls.pilottery.pos.system.model;

import java.io.Serializable;

public class OutletDaliyReportRequest implements Serializable {
	private static final long serialVersionUID = 7355371200541338247L;
	private String outletCode;
	private String follow;
	private int count;
	public String getOutletCode() {
		return outletCode;
	}
	public void setOutletCode(String outletCode) {
		this.outletCode = outletCode;
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
