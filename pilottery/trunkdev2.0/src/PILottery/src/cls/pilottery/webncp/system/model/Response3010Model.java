package cls.pilottery.webncp.system.model;

import cls.pilottery.webncp.common.model.BaseResponse;

public class Response3010Model extends BaseResponse {
	private static final long serialVersionUID = -3910233599797435347L;
	private long balance;
	private long credit;
	private long available;
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
	public long getAvailable() {
		return available;
	}
	public void setAvailable(long available) {
		this.available = available;
	}
}
