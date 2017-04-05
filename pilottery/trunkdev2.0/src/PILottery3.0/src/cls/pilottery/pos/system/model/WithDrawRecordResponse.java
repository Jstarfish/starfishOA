package cls.pilottery.pos.system.model;

import java.io.Serializable;

import cls.pilottery.common.EnumConfigEN;

public class WithDrawRecordResponse implements Serializable {
	private static final long serialVersionUID = -765261768876443122L;
	private String withdrawnCode;
	private String time;
	private String amount;
	private int status;
	private String statusValue;
	public int getStatus() {
		return status;
	}
	public void setStatus(int status) {
		this.status = status;
		this.statusValue = EnumConfigEN.cashWithdrawnStatus.get(status)==null ? "" : EnumConfigEN.cashWithdrawnStatus.get(status);
	}
	public String getStatusValue() {
		return statusValue;
	}
	public void setStatusValue(String statusValue) {
		this.statusValue = statusValue;
	}
	public String getWithdrawnCode() {
		return withdrawnCode;
	}
	public void setWithdrawnCode(String withdrawnCode) {
		this.withdrawnCode = withdrawnCode;
	}
	public String getTime() {
		return time;
	}
	public void setTime(String time) {
		this.time = time;
	}
	public String getAmount() {
		return amount;
	}
	public void setAmount(String amount) {
		this.amount = amount;
	}
}
