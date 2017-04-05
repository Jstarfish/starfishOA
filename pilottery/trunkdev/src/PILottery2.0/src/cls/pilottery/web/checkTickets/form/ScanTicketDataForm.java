package cls.pilottery.web.checkTickets.form;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

import cls.pilottery.common.model.BaseEntity;

public class ScanTicketDataForm extends BaseEntity implements Serializable {

	private static final long serialVersionUID = -4729336262364705870L;
    private String payflow;
	private List<String> ticketData;
	private List<ScanTicketDataParamt> para= new ArrayList<ScanTicketDataParamt>();
	private Long oper;

	public List<String> getTicketData() {
		return ticketData;
	}
	public void setTicketData(List<String> ticketData) {
		this.ticketData = ticketData;
	}
	public List<ScanTicketDataParamt> getPara() {
		return para;
	}
	public void setPara(List<ScanTicketDataParamt> para) {
		this.para = para;
	}
	public Long getOper() {
		return oper;
	}
	public void setOper(Long oper) {
		this.oper = oper;
	}
	public String getPayflow() {
		return payflow;
	}
	public void setPayflow(String payflow) {
		this.payflow = payflow;
	}
	
}
