package cls.pilottery.pos.system.model;

import java.util.List;
import java.util.Map;

/*
 * 兑奖请求消息
 */
public class PayTicketRequest implements java.io.Serializable{
	private static final long serialVersionUID = -8604856668283593622L;
	private String outletCode;
	private List<SecurityCode> securityCodeList;

	public String getOutletCode() {
		return outletCode;
	}

	public void setOutletCode(String outletCode) {
		this.outletCode = outletCode;
	}

	public List<SecurityCode> getSecurityCodeList() {
		return securityCodeList;
	}

	public void setSecurityCodeList(List<SecurityCode> securityCodeList) {
		this.securityCodeList = securityCodeList;
	}
}
