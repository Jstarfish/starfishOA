package cls.pilottery.pos.system.model;

import java.io.Serializable;

import cls.pilottery.common.EnumConfigEN;

public class MktFundFlowDetail implements Serializable {
	private static final long serialVersionUID = -1915327018701425665L;
	private String time;
	private String type;
	private long amount;
	private transient String accNo;
	public String getAccNo() {
		return accNo;
	}
	public void setAccNo(String accNo) {
		this.accNo = accNo;
	}
	public String getTime() {
		return time;
	}
	public void setTime(String time) {
		this.time = time;
	}
	public String getType() {
		return type;
	}
	public void setType(String type) {
		this.type = EnumConfigEN.posTransFlowType.get(Integer.parseInt(type)) == null ? "" : EnumConfigEN.posTransFlowType.get(Integer.parseInt(type));
	}
	public long getAmount() {
		return amount;
	}
	public void setAmount(long amount) {
		this.amount = amount;
	}
}
