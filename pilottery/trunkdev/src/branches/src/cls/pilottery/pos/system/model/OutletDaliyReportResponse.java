package cls.pilottery.pos.system.model;

import java.io.Serializable;
import java.util.List;

public class OutletDaliyReportResponse implements Serializable {
	private static final long serialVersionUID = 4783052918824618698L;
	private List<OutletSalesReocrd> salesList;
	private String outletCode;
	private String follow;
	private long balance;
	private long credit;
	public List<OutletSalesReocrd> getSalesList() {
		return salesList;
	}
	public void setSalesList(List<OutletSalesReocrd> salesList) {
		this.salesList = salesList;
	}
	public String getOutletCode() {
		return outletCode;
	}
	public void setOutletCode(String outletCode) {
		this.outletCode = outletCode;
	}
	public String getFollow() {
		return follow;
	}
	public void setFollow(String follow) {
		this.follow = follow;
	}
	public long getBalance() {
		return balance;
	}
	public void setBalance(long balance) {
		this.balance = balance;
	}
	public long getCredit() {
		return credit;
	}
	public void setCredit(long credit) {
		this.credit = credit;
	}
}
