package cls.pilottery.pos.system.model.mm;

import java.io.Serializable;

import cls.pilottery.common.EnumConfigEN;

public class MMDealRecordSmry020502Res implements Serializable {
	private static final long serialVersionUID = -6259721159797337732L;
	private String time;
	private String outletCode;
	private String dealtype;
	private String dealtypeValue;
	private String amount;
	private String dealNo;
	public String getTime() {
		return time;
	}
	public void setTime(String time) {
		this.time = time;
	}
	public String getOutletCode() {
		return outletCode;
	}
	public void setOutletCode(String outletCode) {
		this.outletCode = outletCode;
	}
	public String getDealtype() {
		return dealtype;
	}
	public void setDealtype(String dealtype) {
		this.dealtype = dealtype;
		this.dealtypeValue = EnumConfigEN.mmTransRecordType.get(Integer.parseInt(dealtype));
	}
	public String getAmount() {
		return amount;
	}
	public void setAmount(String amount) {
		this.amount = amount;
	}
	public String getDealNo() {
		return dealNo;
	}
	public void setDealNo(String dealNo) {
		this.dealNo = dealNo;
	}
	public String getDealtypeValue() {
		return dealtypeValue;
	}
	public void setDealtypeValue(String dealtypeValue) {
		this.dealtypeValue = dealtypeValue;
	}
}
