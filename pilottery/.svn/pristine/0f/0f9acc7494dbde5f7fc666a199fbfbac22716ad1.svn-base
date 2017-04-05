package cls.taishan.web.model.rest;

import com.alibaba.fastjson.annotation.JSONField;

import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
public class WingCommitRes {
	private String amount;
	private String total;
	private String balance;

	@JSONField(name = "exchange_rate")
	private String rate;

	@JSONField(name = "transaction_id")
	private String winTransID;

	@JSONField(name = "consumer_id", ordinal = 4)
	private String reqFlow;

	@JSONField(name = "biller_name")
	private String billName;

	@JSONField(name = "biller_code")
	private String billCode;

	@JSONField(serialize = false)
	private int errorCode;

	@JSONField(serialize = false)
	private String errorMessage;

	@JSONField(serialize = false)
	private int httpStatus;
}
