package cls.pilottery.pos.system.model.mm;

import java.io.Serializable;

import cls.pilottery.common.EnumConfigEN;

public class TagList020504Res implements Serializable {
	private static final long serialVersionUID = 699529635818672120L;
	private String tagNo;
	private String payStatus;
	private String payStatusValue;
	private String ticketFlag;
	private long amount;
	public String getPayStatus() {
		return payStatus;
	}
	public void setPayStatus(String payStatus) {
		this.payStatus = payStatus;
		this.payStatusValue = EnumConfigEN.mmPayoutRecordStatus.get(Integer.parseInt(payStatus));
	}
	public String getPayStatusValue() {
		return payStatusValue;
	}
	public void setPayStatusValue(String payStatusValue) {
		this.payStatusValue = payStatusValue;
	}
	public String getTagNo() {
		return tagNo;
	}
	public void setTagNo(String tagNo) {
		this.tagNo = tagNo;
	}
	public String getTicketFlag() {
		return ticketFlag;
	}
	public void setTicketFlag(String ticketFlag) {
		this.ticketFlag = ticketFlag;
	}
	public long getAmount() {
		return amount;
	}
	public void setAmount(long amount) {
		this.amount = amount;
	}
}
