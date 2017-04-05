package cls.pilottery.pos.system.model.bank;

public class BankTopupRequest {
	private String outletCode;
	private String accountID;
	private long amount;
	private String transPassword;
	private String verifyCode;

	public long getAmount() {
		return amount;
	}
	public void setAmount(long amount) {
		this.amount = amount;
	}
	public String getTransPassword() {
		return transPassword;
	}
	public void setTransPassword(String transPassword) {
		this.transPassword = transPassword;
	}
	public String getVerifyCode() {
		return verifyCode;
	}
	public void setVerifyCode(String verifyCode) {
		this.verifyCode = verifyCode;
	}
	public String getAccountID() {
		return accountID;
	}
	public void setAccountID(String accountID) {
		this.accountID = accountID;
	}
	public String getOutletCode() {
		return outletCode;
	}
	public void setOutletCode(String outletCode) {
		this.outletCode = outletCode;
	}
}
