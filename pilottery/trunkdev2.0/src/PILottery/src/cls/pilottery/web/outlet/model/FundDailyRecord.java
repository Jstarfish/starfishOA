package cls.pilottery.web.outlet.model;

import java.io.Serializable;

/**
 * 
 * 资金日结表
 * 
 */
public class FundDailyRecord implements Serializable {

	private static final long serialVersionUID = 1L;

	private String dateTime;// 哪一天的日结信息

	private String outletCode;// 哪个站点

	private String fundType;// 什么日结类型

	private long account;// 某一天下的某个类型的日结金额

	public String getDateTime() {

		return dateTime;
	}

	public void setDateTime(String dateTime) {

		this.dateTime = dateTime;
	}

	public String getOutletCode() {

		return outletCode;
	}

	public void setOutletCode(String outletCode) {

		this.outletCode = outletCode;
	}

	public String getFundType() {

		return fundType;
	}

	public void setFundType(String fundType) {

		this.fundType = fundType;
	}

	public long getAccount() {

		return account;
	}

	public void setAccount(long account) {

		this.account = account;
	}
}
