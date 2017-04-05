package cls.taishan.web.model.db;

import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
public class WingLoginDBParm {

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

	public WingLoginDBParm(){
		super();
	}
	
	public WingLoginDBParm(String eTradeFlow, String jsonData) {
		super();
		this.eTradeFlow = eTradeFlow;
		this.jsonData = jsonData;
	}

	@Override
	public String toString() {
		return "WingLoginDBParm [eTradeFlow=" + eTradeFlow + ", jsonData=" + jsonData + ", restStatus=" + restStatus
				+ ", eInPostId=" + eInPostId + ", httpStatus=" + httpStatus + ", eOutPostId=" + eOutPostId
				+ ", errorCode=" + errorCode + ", errorMessage=" + errorMessage + "]";
	}

}
