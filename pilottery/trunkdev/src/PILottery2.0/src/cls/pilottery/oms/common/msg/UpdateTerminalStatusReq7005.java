package cls.pilottery.oms.common.msg;

import cls.pilottery.oms.common.entity.BaseMessageReq;

public class UpdateTerminalStatusReq7005 extends BaseMessageReq {

	private static final long serialVersionUID = 760663814644137708L;
	private String termCode;

	private int status;
	public String getTermCode() {
		return termCode;
	}
	public void setTermCode(String termCode) {
		this.termCode = termCode;
	}
	
	public int getStatus() {
		return status;
	}
	public void setStatus(int status) {
		this.status = status;
	}
	@Override
	public String toString() {
		return "UpdateTerminalStatusReq7005 [termCode=" + termCode + ", status=" + status + "]";
	}
	

}
