package cls.pilottery.web.monitor.model;

import java.io.Serializable;

public class SummaryStatisticsModel implements Serializable {
	private static final long serialVersionUID = 8506107747934641677L;
	private float perOfsale;
	private String planName;
	private String orgName;
	private String agencyCode;
	private String outletName;
	public float getPerOfsale() {
		return perOfsale;
	}
	public void setPerOfsale(float perOfsale) {
		this.perOfsale = perOfsale;
	}
	public String getPlanName() {
		return planName;
	}
	public void setPlanName(String planName) {
		this.planName = planName;
	}
	public String getOrgName() {
		return orgName;
	}
	public void setOrgName(String orgName) {
		this.orgName = orgName;
	}
	public String getOutletName() {
		return outletName;
	}
	public void setOutletName(String outletName) {
		this.outletName = outletName;
	}
	public String getAgencyCode() {
		return agencyCode;
	}
	public void setAgencyCode(String agencyCode) {
		this.agencyCode = agencyCode;
	}
}
