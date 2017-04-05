package cls.taishan.web.model.control;

import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
public class WingChargeOutputParam {
	private long balance;
	private long fee;
	private String exchange;
	private String resFlow;
	private String wingFlow;
	
	private int errorCode;
	private String errorMessage;

	@Override
	public String toString() {
		return "wingChargeOutput [balance=" + balance
				+ ", fee=" + fee + ", exchange=" + exchange + ", resFlow=" + resFlow + ", wingFlow=" + wingFlow + "]";
	}

}
