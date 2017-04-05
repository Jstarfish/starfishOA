package cls.taishan.web.model.db;

import lombok.Getter;
import lombok.Setter;

@Setter
@Getter
public class WingValidateDBParam {

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

}
