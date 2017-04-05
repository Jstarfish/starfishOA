package cls.taishan.web.model.db;

import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
public class WingWithdrawDBParam {
	
	// 输入参数
	private String eTradeFlow;
	private String jsonData;
	private int restStatus;
	private String eInPostId;
	private int httpStatus;
	
	// 输出参数
	private String eOutPostId;
	private int errorCode;
	private String errorMessage;

	public WingWithdrawDBParam(String eTradeFlow, String jsonData) {
		super();
		this.eTradeFlow = eTradeFlow;
		this.jsonData = jsonData;
	}

}
