package cls.taishan.web.model.db;

import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
public class WingReceiveWDDataDBParm {
	private String eUser;
	private String account;
	private long   amount;
	private String userAcc;
	private String reqFlow;
	private String eTradeFlow;
	private String currency;
	private int    errorCode;
	private String errorMesg;
	
}
