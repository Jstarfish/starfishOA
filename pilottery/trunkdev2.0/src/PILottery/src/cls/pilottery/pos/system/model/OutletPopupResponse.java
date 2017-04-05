package cls.pilottery.pos.system.model;

import java.io.Serializable;

public class OutletPopupResponse implements Serializable {
	
	/**
	 * 
	 */
	private static final long serialVersionUID = -7711783354105210283L;
	//站点编码
	private String outletCode;	
	private String outletName;
	private long topupAmount;
	private long balance;
	
	public String getOutletCode() {
		return outletCode;
	}
	public void setOutletCode(String outletCode) {
		this.outletCode = outletCode;
	}
	public String getOutletName() {
		return outletName;
	}
	public void setOutletName(String outletName) {
		this.outletName = outletName;
	}
	public long getTopupAmount() {
		return topupAmount;
	}
	public void setTopupAmount(long topupAmount) {
		this.topupAmount = topupAmount;
	}
	public long getBalance() {
		return balance;
	}
	public void setBalance(long balance) {
		this.balance = balance;
	}
	public static long getSerialversionuid() {
		return serialVersionUID;
	}

	
}
