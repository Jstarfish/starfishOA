package cls.pilottery.web.capital.form;

import cls.pilottery.common.model.BaseEntity;

public class OutletAdjustForm extends BaseEntity {
	private static final long serialVersionUID = 7429910456957197177L;
	private String agencyCode;
	private String adjustType;
	private long adjustAmount;
	private long out_fbalance;
	private long out_balance;
	private String crtUserId;
	
	public String getAgencyCode() {
		return agencyCode;
	}
	public void setAgencyCode(String agencyCode) {
		this.agencyCode = agencyCode;
	}
	public String getAdjustType() {
		return adjustType;
	}
	public void setAdjustType(String adjustType) {
		this.adjustType = adjustType;
	}
	public long getAdjustAmount() {
		return adjustAmount;
	}
	public void setAdjustAmount(long adjustAmount) {
		this.adjustAmount = adjustAmount;
	}
	public long getOut_fbalance() {
		return out_fbalance;
	}
	public void setOut_fbalance(long outFbalance) {
		out_fbalance = outFbalance;
	}
	public long getOut_balance() {
		return out_balance;
	}
	public void setOut_balance(long outBalance) {
		out_balance = outBalance;
	}
	public String getCrtUserId() {
		return crtUserId;
	}
	public void setCrtUserId(String crtUserId) {
		this.crtUserId = crtUserId;
	}
	@Override
	public String toString() {
		return "OutletAdjustForm [adjustAmount=" + adjustAmount
				+ ", adjustType=" + adjustType + ", agencyCode=" + agencyCode
				+ ", crtUserId=" + crtUserId + ", out_balance=" + out_balance
				+ ", out_fbalance=" + out_fbalance + "]";
	} 
}
