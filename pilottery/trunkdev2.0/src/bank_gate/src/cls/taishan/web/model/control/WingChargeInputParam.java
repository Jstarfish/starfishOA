package cls.taishan.web.model.control;

import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
public class WingChargeInputParam {
	private String euser;
	private String account;
	private long amount;
	private String userAcc;
	private String otp;
	private String reqFlow;

	@Override
	public String toString() {
		return "wingChargeInput [euser=" + euser + ", account=" + account + ", amount=" + amount + ", userAcc="
				+ userAcc + ", otp=" + otp + ", reqFlow=" + reqFlow + "]";
	}

}
