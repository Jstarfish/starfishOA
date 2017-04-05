package cls.pilottery.pos.system.model.bank;

import java.io.Serializable;

public class OutletAccoutInfo implements Serializable {
	private static final long serialVersionUID = 3991440448666482939L;
	private String accountID;
	private String accountOwner;
	public String getAccountOwner() {
		return accountOwner;
	}
	public void setAccountOwner(String accountOwner) {
		this.accountOwner = accountOwner;
	}
	public String getAccountID() {
		return accountID;
	}
	public void setAccountID(String accountID) {
		this.accountID = accountID;
	}

}
