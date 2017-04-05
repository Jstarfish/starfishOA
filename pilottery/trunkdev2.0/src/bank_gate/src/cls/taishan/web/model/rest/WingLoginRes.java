package cls.taishan.web.model.rest;

import com.alibaba.fastjson.annotation.JSONField;

import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
public class WingLoginRes {
	private String access_token;
	private String token_type;
	private int expires_in;
	private String scope;
	
	@JSONField(serialize=false)
	private int errorCode;
	
	@JSONField(serialize=false)
	private String errorMessage;

	@JSONField(serialize=false)
	private int httpStatus;

	@Override
	public String toString() {
		return "WingLoginOutputParam [access_token=" + access_token + ", token_type=" + token_type + ", expires_in="
				+ expires_in + ", scope=" + scope + "]";
	}

}
