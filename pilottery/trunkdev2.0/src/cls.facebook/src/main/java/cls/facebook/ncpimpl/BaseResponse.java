package cls.facebook.ncpimpl;

import com.alibaba.fastjson.annotation.JSONField;



public class BaseResponse implements java.io.Serializable {
	private static final long serialVersionUID = -8162223141558562841L;
	private int CMD;
	private int errorCode = 5000;
	private String errorMesg;
	@JSONField(name="CMD")
	public int getCMD() {
		return CMD;
	}
	@JSONField(name="CMD")
	public void setCMD(int cMD) {
		CMD = cMD;
	}
	public int getErrorCode() {
		return errorCode;
	}
	public void setErrorCode(int errorCode) {
		this.errorCode = errorCode;
	}
	public String getErrorMesg() {
		return errorMesg;
	}
	public void setErrorMesg(String errorMesg) {
		this.errorMesg = errorMesg;
	}
	
	public BaseResponse() {
		this.errorCode = 5000;
		this.errorMesg = WebncpErrorMessage.getMsg(5000);
	}
	public BaseResponse(int errorCode) {
		this.errorCode = errorCode;
		this.errorMesg = WebncpErrorMessage.getMsg(errorCode);
	}
	public BaseResponse(int errorCode,String errorMsg) {
		this.errorCode = errorCode;
		this.errorMesg = errorMsg;
	}
}
