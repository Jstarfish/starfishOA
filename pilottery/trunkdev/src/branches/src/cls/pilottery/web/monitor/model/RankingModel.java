package cls.pilottery.web.monitor.model;

import java.io.Serializable;

public class RankingModel implements Serializable {
	private static final long serialVersionUID = 3815068428332953779L;
	private String agencyCode;
	private String agencyName;
	private long saleAmount;
	private long cancelAmount;
	private long payAmount;
	private int saletickets;
	public String getAgencyCode() {
		return agencyCode;
	}
	public void setAgencyCode(String agencyCode) {
		this.agencyCode = agencyCode;
	}
	public String getAgencyName() {
		return agencyName;
	}
	public void setAgencyName(String agencyName) {
		this.agencyName = agencyName;
	}
	public long getSaleAmount() {
		return saleAmount;
	}
	public void setSaleAmount(long saleAmount) {
		this.saleAmount = saleAmount;
	}
	public long getCancelAmount() {
		return cancelAmount;
	}
	public void setCancelAmount(long cancelAmount) {
		this.cancelAmount = cancelAmount;
	}
	public long getPayAmount() {
		return payAmount;
	}
	public void setPayAmount(long payAmount) {
		this.payAmount = payAmount;
	}
	public int getSaletickets() {
		return saletickets;
	}
	public void setSaletickets(int saletickets) {
		this.saletickets = saletickets;
	}
}
