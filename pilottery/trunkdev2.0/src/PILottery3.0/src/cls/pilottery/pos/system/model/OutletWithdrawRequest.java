package cls.pilottery.pos.system.model;

import java.io.Serializable;

public class OutletWithdrawRequest implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 321457718854670701L;
	//站点编码
	private String outletCode;	
	private long amount;
	private String password;
	
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
	public String getPassword() {
		return password;
	}
	public void setPassword(String password) {
		this.password = password;
	}
		
}
