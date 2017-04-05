package cls.pilottery.pos.system.model;

import java.io.Serializable;

public class BalanceInfo implements Serializable {

	private static final long serialVersionUID = -794715201685842160L;
	
	private long balance;
	private long credit;
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
