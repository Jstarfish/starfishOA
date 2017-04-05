package cls.taishan.web.model.control;

import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
public class WingSearchOutputParam {
	private int errorCode;
	private String errorMessage;
	
	private int isSucc;
	private String failReason;
	private long balance;
	private long fee;
	private String exchange;
	private String resFlow;
	private String wingFlow;
	private String userName;

	@Override
	public String toString() {
		return "WingSearchOutputParam [errorCode=" + errorCode + ", errorMessage=" + errorMessage + ", isSucc=" + isSucc
				+ ", failReason=" + failReason + ", balance=" + balance + ", fee=" + fee + ", exchange=" + exchange
				+ ", resFlow=" + resFlow + ", wingFlow=" + wingFlow + ", userName=" + userName + "]";
	}

}
