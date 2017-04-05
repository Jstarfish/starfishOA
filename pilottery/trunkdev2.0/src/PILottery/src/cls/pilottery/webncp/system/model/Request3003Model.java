package cls.pilottery.webncp.system.model;

import cls.pilottery.webncp.common.model.BaseRequest;

public class Request3003Model extends BaseRequest {

	private static final long serialVersionUID = 1L;

	private String accountDay;

	private String agencyCode;

	public String getAccountDay() {

		return accountDay;
	}

	public void setAccountDay(String accountDay) {

		this.accountDay = accountDay;
	}

	public String getAgencyCode() {

		return agencyCode;
	}

	public void setAgencyCode(String agencyCode) {

		this.agencyCode = agencyCode;
	}
}
