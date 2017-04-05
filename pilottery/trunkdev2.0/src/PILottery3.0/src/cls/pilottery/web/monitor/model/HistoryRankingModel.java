package cls.pilottery.web.monitor.model;

import java.io.Serializable;

public class HistoryRankingModel implements Serializable {

	private static final long serialVersionUID = -6531516365463746832L;

	private String agencyCode;
	private String agencyName;
	private String telephone;
	private String orgCode;
	private String orgName;
	private long saleAmount;
	private long payoutAmount;
	private long returnAmount;

	public String getAgencyCode() {
		return agencyCode;
	}

	public void setAgencyCode(String agencyCode) {
		this.agencyCode = agencyCode;
	}

	public String getAgencyName() {
		return agencyName;
	}

	public void setAgencyName(String agencyName) {
		this.agencyName = agencyName;
	}

	public String getTelephone() {
		return telephone;
	}

	public void setTelephone(String telephone) {
		this.telephone = telephone;
	}

	public String getOrgCode() {
		return orgCode;
	}

	public void setOrgCode(String orgCode) {
		this.orgCode = orgCode;
	}

	public String getOrgName() {
		return orgName;
	}

	public void setOrgName(String orgName) {
		this.orgName = orgName;
	}

	public long getSaleAmount() {
		return saleAmount;
	}

	public void setSaleAmount(long saleAmount) {
		this.saleAmount = saleAmount;
	}

	public long getPayoutAmount() {
		return payoutAmount;
	}

	public void setPayoutAmount(long payoutAmount) {
		this.payoutAmount = payoutAmount;
	}

	public long getReturnAmount() {
		return returnAmount;
	}

	public void setReturnAmount(long returnAmount) {
		this.returnAmount = returnAmount;
	}

}
