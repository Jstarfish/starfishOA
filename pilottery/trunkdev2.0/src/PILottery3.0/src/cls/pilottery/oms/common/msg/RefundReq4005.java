package cls.pilottery.oms.common.msg;

public class RefundReq4005 implements java.io.Serializable {

	private static final long serialVersionUID = -6586300883503329821L;
	private String rspfn_ticket;// char[25] 彩票TSN
	private String reqfn_ticket_cancel;// char[25] 退票请求交易流水号
	private String areaCode_cancel;

	public String getRspfn_ticket() {
		return rspfn_ticket;
	}

	public void setRspfn_ticket(String rspfn_ticket) {
		this.rspfn_ticket = rspfn_ticket;
	}

	public String getReqfn_ticket_cancel() {
		return reqfn_ticket_cancel;
	}

	public void setReqfn_ticket_cancel(String reqfn_ticket_cancel) {
		this.reqfn_ticket_cancel = reqfn_ticket_cancel;
	}

	public String getAreaCode_cancel() {
		return areaCode_cancel;
	}

	public void setAreaCode_cancel(String areaCode_cancel) {
		this.areaCode_cancel = areaCode_cancel;
	}

	@Override
	public String toString() {
		return "RefundReq4005 [rspfn_ticket=" + rspfn_ticket + ", reqfn_ticket_cancel=" + reqfn_ticket_cancel
				+ ", areaCode_cancel=" + areaCode_cancel + "]";
	}

	

}
