package cls.taishan.common.model;

import cls.taishan.common.constant.ErrorCodeConstant;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Setter
@Getter
@ToString
public class BaseResponse implements java.io.Serializable{
	private static final long serialVersionUID = 7095588008215552042L;
	private int responseCode;
	private String responseMsg;
	
	public BaseResponse(){
		this.responseCode = 0;
		this.responseMsg = ErrorCodeConstant.getMsg(0);		
	}
	public BaseResponse(int responseCode){
		this.responseCode = responseCode;
		this.responseMsg = ErrorCodeConstant.getMsg(responseCode);
	}
}
