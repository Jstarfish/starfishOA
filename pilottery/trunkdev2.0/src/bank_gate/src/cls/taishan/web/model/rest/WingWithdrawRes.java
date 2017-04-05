package cls.taishan.web.model.rest;

import com.alibaba.fastjson.annotation.JSONField;

import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
public class WingWithdrawRes {
	private String currency;
	private String amount;
	private String fee;
	private String total;
	private String balance;
	private String exchange_rate;
	private String transaction_id;
	private String account_name;

	@JSONField(serialize = false)
	private int errorCode;

	@JSONField(serialize = false)
	private String errorMessage;

	@JSONField(serialize = false)
	private int httpStatus;

	@Override
	public String toString() {
		return "WingWithdrawRes [currency=" + currency + ", amount=" + amount + ", fee=" + fee + ", total=" + total
				+ ", balance=" + balance + ", exchange_rate=" + exchange_rate + ", transaction_id=" + transaction_id
				+ ", account_name=" + account_name + "]";
	}

}
