package cls.pilottery.pos.system.model;

/*
 * 用于中奖返回中奖票信息
 * modify by dzg 2015-10-21
 * 返回完整票
 */
public class WinTicketInfo {

	private String ticketCode;
	private String payStatus;
	private String amount;
	
	
	public WinTicketInfo() {
	}

	public WinTicketInfo(String ticketCode, String payStatus, String amount) {
		super();
		this.ticketCode = ticketCode;
		this.payStatus = payStatus;
		this.amount = amount;
	}

	public String getTicketCode() {
		return ticketCode;
	}

	public void setTicketCode(String ticketCode) {
		this.ticketCode = ticketCode;
	}


	public String getPayStatus() {
		return payStatus;
	}


	public void setPayStatus(String payStatus) {
		this.payStatus = payStatus;
	}


	public String getAmount() {
		return amount;
	}


	public void setAmount(String amount) {
		this.amount = amount;
	}

	

	
}
