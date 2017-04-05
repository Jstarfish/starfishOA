package cls.pilottery.pos.system.model.bank;

public class PayCenterQueryRespone extends BasePayCenterMessage {

	private int isSucc;
	private String failReason;
	private long balance;
	private long fee;
	private String exchange;
	private String resFlow;
	private String wingFlow;
	private String userName;
	
	public int getIsSucc() {
		return isSucc;
	}
	public void setIsSucc(int isSucc) {
		this.isSucc = isSucc;
	}
	public String getFailReason() {
		return failReason;
	}
	public long getBalance() {
		return balance;
	}
	public void setBalance(long balance) {
		this.balance = balance;
	}
	public long getFee() {
		return fee;
	}
	public void setFee(long fee) {
		this.fee = fee;
	}
	public String getExchange() {
		return exchange;
	}
	public void setExchange(String exchange) {
		this.exchange = exchange;
	}
	public String getResFlow() {
		return resFlow;
	}
	public void setResFlow(String resFlow) {
		this.resFlow = resFlow;
	}
	public String getWingFlow() {
		return wingFlow;
	}
	public void setWingFlow(String wingFlow) {
		this.wingFlow = wingFlow;
	}
	public String getUserName() {
		return userName;
	}
	public void setUserName(String userName) {
		this.userName = userName;
	}
	public void setFailReason(String failReason) {
		this.failReason = failReason;
	}
	
}
