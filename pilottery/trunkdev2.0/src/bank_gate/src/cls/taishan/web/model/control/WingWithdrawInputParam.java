package cls.taishan.web.model.control;

import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
public class WingWithdrawInputParam {
	private String euser;
	private String account;
	private long amount;
	private String userAcc;
	private String reqFlow;
}
