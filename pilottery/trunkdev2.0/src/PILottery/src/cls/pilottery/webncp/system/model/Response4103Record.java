package cls.pilottery.webncp.system.model;

public class Response4103Record implements java.io.Serializable {
	private static final long serialVersionUID = -2302427706743786883L;
	private String ticketCode;
	private String payStatus;
	private String amount;
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
