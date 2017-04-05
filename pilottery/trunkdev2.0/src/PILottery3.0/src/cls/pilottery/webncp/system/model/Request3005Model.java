package cls.pilottery.webncp.system.model;

import cls.pilottery.webncp.common.model.BaseRequest;

public class Request3005Model extends BaseRequest {

	private static final long serialVersionUID = 1L;

	private String accountMonth;

	private String agencyCode;

	public String getAccountMonth() {

		return accountMonth;
	}

	public void setAccountMonth(String accountMonth) {

		this.accountMonth = accountMonth;
	}

	public String getAgencyCode() {

		return agencyCode;
	}

	public void setAgencyCode(String agencyCode) {

		this.agencyCode = agencyCode;
	}
}
