package cls.pilottery.webncp.system.model;

public class Response3001Record implements java.io.Serializable{
	private static final long serialVersionUID = -5120363155108405988L;
	private String countDate;
	private String gameName;
	private String agencyCode;
	private int saleCount;
	private long saleMoney;
	private int cancelCount;
	private long cancelMoney;
	private int balanceCount;
	private long balanceMoney;
	private int payoutCount;
	private long payoutMoney;
	public String getCountDate() {
		return countDate;
	}
	public void setCountDate(String countDate) {
		this.countDate = countDate;
	}
	public String getGameName() {
		return gameName;
	}
	public void setGameName(String gameName) {
		this.gameName = gameName;
	}
	public String getAgencyCode() {
		return agencyCode;
	}
	public void setAgencyCode(String agencyCode) {
		this.agencyCode = agencyCode;
	}
	public int getSaleCount() {
		return saleCount;
	}
	public void setSaleCount(int saleCount) {
		this.saleCount = saleCount;
	}
	public long getSaleMoney() {
		return saleMoney;
	}
	public void setSaleMoney(long saleMoney) {
		this.saleMoney = saleMoney;
	}
	public int getCancelCount() {
		return cancelCount;
	}
	public void setCancelCount(int cancelCount) {
		this.cancelCount = cancelCount;
	}
	public long getCancelMoney() {
		return cancelMoney;
	}
	public void setCancelMoney(long cancelMoney) {
		this.cancelMoney = cancelMoney;
	}
	public int getBalanceCount() {
		return balanceCount;
	}
	public void setBalanceCount(int balanceCount) {
		this.balanceCount = balanceCount;
	}
	public long getBalanceMoney() {
		return balanceMoney;
	}
	public void setBalanceMoney(long balanceMoney) {
		this.balanceMoney = balanceMoney;
	}
	public int getPayoutCount() {
		return payoutCount;
	}
	public void setPayoutCount(int payoutCount) {
		this.payoutCount = payoutCount;
	}
	public long getPayoutMoney() {
		return payoutMoney;
	}
	public void setPayoutMoney(long payoutMoney) {
		this.payoutMoney = payoutMoney;
	}
}
