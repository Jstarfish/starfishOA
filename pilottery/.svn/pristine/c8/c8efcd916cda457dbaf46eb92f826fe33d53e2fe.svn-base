package cls.pilottery.pos.system.model.mm;

import java.io.Serializable;

import cls.pilottery.common.EnumConfigEN;

public class MMCapitalDaliy020508Res implements Serializable {
	private static final long serialVersionUID = -4077685806453285291L;
	private String calcDate;
	private String dealtype;
	private long amount;
	public String getCalcDate() {
		return calcDate;
	}
	public void setCalcDate(String calcDate) {
		this.calcDate = calcDate;
	}
	public String getDealtype() {
		return dealtype;
	}
	public void setDealtype(String dealtype) {
		this.dealtype = EnumConfigEN.mmCapitalDaliyType.get(Integer.parseInt(dealtype));
	}
	public long getAmount() {
		return amount;
	}
	public void setAmount(long amount) {
		this.amount = amount;
	}
	
}
