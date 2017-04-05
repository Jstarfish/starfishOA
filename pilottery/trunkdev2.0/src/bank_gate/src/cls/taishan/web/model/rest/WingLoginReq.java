package cls.taishan.web.model.rest;

import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
public class WingLoginReq {
	private String wingUser;
	private String wingPass;
	//private String wingBillCode;
	private String grantType;
	private String clientID;
	private String clientSecret;
	private String scope;
	private String billCode;

	@Override
	public String toString() {
		return "WingUser [wingUser=" + wingUser + ", wingPass=" + wingPass
				+ ", grantType=" + grantType + ", clientID=" + clientID + ", clientSecret=" + clientSecret + ", scope="
				+ scope + ", billcode=" + billCode + "]";
	}

	public String toReqString() {
		String rtv = "";

		rtv += "username=" + wingUser;
		rtv += "&" + "password=" + wingPass;
		rtv += "&" + "grant_type=" + grantType;
		rtv += "&" + "client_id=" + clientID;
		rtv += "&" + "client_secret=" + clientSecret;
		rtv += "&" + "scope=" + scope;
		return rtv;
	}

}
