package cls.pilottery.oms.common.msg;

public class LotteryReq4003 implements java.io.Serializable {    
	private static final long serialVersionUID = 3485866145459042970L;
	private String rspfn_ticket;
	private String reqfn_ticket_pay;
	private String areaCode_pay;
	public String getRspfn_ticket() {
		return rspfn_ticket;
	}
	public void setRspfn_ticket(String rspfn_ticket) {
		this.rspfn_ticket = rspfn_ticket;
	}
	public String getReqfn_ticket_pay() {
		return reqfn_ticket_pay;
	}
	public void setReqfn_ticket_pay(String reqfn_ticket_pay) {
		this.reqfn_ticket_pay = reqfn_ticket_pay;
	}
	public String getAreaCode_pay() {
		return areaCode_pay;
	}
	public void setAreaCode_pay(String areaCode_pay) {
		this.areaCode_pay = areaCode_pay;
	}

}
