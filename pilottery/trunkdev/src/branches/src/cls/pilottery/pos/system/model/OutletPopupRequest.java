package cls.pilottery.pos.system.model;

import java.io.Serializable;

public class OutletPopupRequest implements Serializable {
	/**
	 * 
	 */
	private static final long serialVersionUID = 7908531116486237622L;
	//站点编码
	private String outletCode;	
	private long amount;
	private String transPassword;
	public String getOutletCode() {
		return outletCode;
	}
	public void setOutletCode(String outletCode) {
		this.outletCode = outletCode;
	}
	public long getAmount() {
		return amount;
	}
	public void setAmount(long amount) {
		this.amount = amount;
	}
	public String getTransPassword() {
		return transPassword;
	}
	public void setTransPassword(String transPassword) {
		this.transPassword = transPassword;
	}
	
	
	
}
