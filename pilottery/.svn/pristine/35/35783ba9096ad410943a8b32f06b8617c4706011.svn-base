package cls.taishan.web.model.rest;

import com.alibaba.fastjson.annotation.JSONField;

import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
public class WingValidateReq {
	@JSONField(name = "amount", ordinal = 3)
	private long amount;

	@JSONField(name = "wing_account", ordinal = 1)
	private String userAcc;

	@JSONField(name = "security_code", ordinal = 5)
	private String otp;

	@JSONField(name = "consumer_id", ordinal = 4)
	private String reqFlow;

	@JSONField(name = "biller_code", ordinal = 2)
	private String billCode;

}
