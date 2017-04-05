package cls.pilottery.webncp.system.model;

import java.util.List;
import java.util.Map;

import cls.pilottery.webncp.common.model.BaseRequest;

public class Request4103Model extends BaseRequest {
	private static final long serialVersionUID = -2683969027124441209L;
	private String outletCode;
	private List<Map<String,String>> securityCodeList;
	public String getOutletCode() {
		return outletCode;
	}
	public void setOutletCode(String outletCode) {
		this.outletCode = outletCode;
	}
	public List<Map<String, String>> getSecurityCodeList() {
		return securityCodeList;
	}
	public void setSecurityCodeList(List<Map<String, String>> securityCodeList) {
		this.securityCodeList = securityCodeList;
	}
}
