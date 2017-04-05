package cls.pilottery.pos.system.model;

import java.io.Serializable;

public class OutletSalesReocrd implements Serializable {
	private static final long serialVersionUID = 6411276690798917584L;
	private String date;
	private long sale;
	private long saleCommission;
	private long payout;
	private long payoutCommission;
	private long topup;
	private long withdrawn;
	private long returned;
	private long returnCommission;
	public String getDate() {
		return date;
	}
	public void setCalDate(String date) {
		this.date = date;
	}
	public long getSale() {
		return sale;
	}
	public void setSale(long sale) {
		this.sale = sale;
	}
	public long getSaleCommission() {
		return saleCommission;
	}
	public void setSaleCommission(long saleCommission) {
		this.saleCommission = saleCommission;
	}
	public long getPayout() {
		return payout;
	}
	public void setPayout(long payout) {
		this.payout = payout;
	}
	public long getPayoutCommission() {
		return payoutCommission;
	}
	public void setPayoutCommission(long payoutCommission) {
		this.payoutCommission = payoutCommission;
	}
	public long getTopup() {
		return topup;
	}
	public void setTopup(long topup) {
		this.topup = topup;
	}
	public long getWithdrawn() {
		return withdrawn;
	}
	public void setWithdrawn(long withdrawn) {
		this.withdrawn = withdrawn;
	}
	public long getReturned() {
		return returned;
	}
	public void setReturned(long returned) {
		this.returned = returned;
	}
	public long getReturnCommission() {
		return returnCommission;
	}
	public void setReturnCommission(long returnCommission) {
		this.returnCommission = returnCommission;
	}
}
