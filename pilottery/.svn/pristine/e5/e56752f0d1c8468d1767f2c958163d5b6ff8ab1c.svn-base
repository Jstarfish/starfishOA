package cls.pilottery.pos.system.model;

import cls.pilottery.common.EnumConfigEN;

/*
 * 用于中奖返回中奖票信息
 * modify by dzg 2015-10-21
 * 返回完整票
 */
public class WinTicketInfo implements java.io.Serializable{
	private static final long serialVersionUID = 5290964828112148113L;
	private String ticketCode;
	private int payStatus;
	private String payStatusValue;
	private String amount;
	private String ticketFlag;
	public String getTicketCode() {
		return ticketCode;
	}
	public void setTicketCode(String ticketCode) {
		this.ticketCode = ticketCode;
	}
	public int getPayStatus() {
		return payStatus;
	}
	public void setPayStatus(int payStatus) {
		this.payStatus = payStatus;
		this.payStatusValue = EnumConfigEN.mmPayoutRecordStatus.get(payStatus);
	}
	public String getPayStatusValue() {
		return payStatusValue;
	}
	public void setPayStatusValue(String payStatusValue) {
		this.payStatusValue = payStatusValue;
	}
	public String getAmount() {
		return amount;
	}
	public void setAmount(String amount) {
		this.amount = amount;
	}
	public String getTicketFlag() {
		return ticketFlag;
	}
	public void setTicketFlag(String ticketFlag) {
		this.ticketFlag = ticketFlag;
	}

}
