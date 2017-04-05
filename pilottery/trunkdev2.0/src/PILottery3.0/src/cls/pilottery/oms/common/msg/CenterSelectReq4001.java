package cls.pilottery.oms.common.msg;

public class CenterSelectReq4001 implements java.io.Serializable {	    
	
private static final long serialVersionUID = 4697452198441721002L;
private String rspfn_ticket;

public String getRspfn_ticket() {
	return rspfn_ticket;
}

public void setRspfn_ticket(String rspfn_ticket) {
	this.rspfn_ticket = rspfn_ticket;
}

@Override
public String toString() {
	return "CenterSelectReq4001 [rspfn_ticket=" + rspfn_ticket + "]";
}
 
}
