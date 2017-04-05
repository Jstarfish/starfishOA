package cls.taishan.web.model.rest;

import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
public class WingWithdrawReq {
	private long amount;
	private String currency;
	private String receiver_account;

	@Override
	public String toString() {
		return "WingWithdrawRes [amount=" + amount + ", currency=" + currency + ", receiver_account=" + receiver_account
				+ "]";
	}

	public WingWithdrawReq(long amount, String currency, String receiver_account) {
		super();
		this.amount = amount;
		this.currency = currency;
		this.receiver_account = receiver_account;
	}

	public WingWithdrawReq(String currency, String receiver_account) {
		super();
		this.currency = currency;
		this.receiver_account = receiver_account;
	}

	public WingWithdrawReq() {
		super();
	}
}
