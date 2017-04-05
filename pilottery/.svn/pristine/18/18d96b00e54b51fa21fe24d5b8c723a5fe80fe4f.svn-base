package cls.taishan.web.model.rest;

import com.alibaba.fastjson.annotation.JSONField;

import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
public class WingValidateRes {
	private String amount;
	private String fee;
	private String total;

	@JSONField(name = "exchange_rate")
	private String rate;

	@JSONField(name = "consumer_id")
	private String reqFlow;

	@JSONField(name = "biller_name")
	private String billName;

	@JSONField(serialize = false)
	private int errorCode;

	@JSONField(serialize = false)
	private String errorMessage;

	@JSONField(serialize = false)
	private int httpStatus;
}
