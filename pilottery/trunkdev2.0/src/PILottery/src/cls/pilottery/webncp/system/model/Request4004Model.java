package cls.pilottery.webncp.system.model;

import cls.pilottery.webncp.common.model.BaseRequest;

public class Request4004Model extends BaseRequest {

	private static final long serialVersionUID = -7464708220972211967L;
	private String notCode;  //通知序号
	
	public String getNotCode() {
		return notCode;
	}
	public void setNotCode(String notCode) {
		this.notCode = notCode;
	}
	
	@Override
	public String toString() {
		return "Request4004Model [notCode=" + notCode + "]";
	}
}
