package cls.pilottery.webncp.system.model;

public class Response4101Record implements java.io.Serializable{
	private static final long serialVersionUID = -8185897050031454744L;
	private String time;
	private String dealtype;
	private String dealNo;
	private long amount;
	private long comm;
	private int tickets;
	public String getTime() {
		return time;
	}
	public void setTime(String time) {
		this.time = time;
	}
	public String getDealtype() {
		return dealtype;
	}
	public void setDealtype(String dealtype) {
		this.dealtype = dealtype;
	}
	public String getDealNo() {
		return dealNo;
	}
	public void setDealNo(String dealNo) {
		this.dealNo = dealNo;
	}
	public long getAmount() {
		return amount;
	}
	public void setAmount(long amount) {
		this.amount = amount;
	}
	public long getComm() {
		return comm;
	}
	public void setComm(long comm) {
		this.comm = comm;
	}
	public int getTickets() {
		return tickets;
	}
	public void setTickets(int tickets) {
		this.tickets = tickets;
	}
}
