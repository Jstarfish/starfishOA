package cls.pilottery.pos.system.model;

import java.io.Serializable;

public class OutletWithdrawConRequest implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = -4716955498790117259L;
	//站点编码
	private String outletCode;	
	private String password;
	private String withdrawnCode;
	public String getOutletCode() {
		return outletCode;
	}
	public void setOutletCode(String outletCode) {
		this.outletCode = outletCode;
	}
	public String getPassword() {
		return password;
	}
	public void setPassword(String password) {
		this.password = password;
	}
	public String getWithdrawnCode() {
		return withdrawnCode;
	}
	public void setWithdrawnCode(String withdrawnCode) {
		this.withdrawnCode = withdrawnCode;
	}
	
		
}
