package cls.pilottery.web.report.form;

import java.io.Serializable;

public class MonthlyReportForm implements Serializable {

	private static final long serialVersionUID = 4620222852042321179L;

	private String beginDate;
	private String endDate;
	private String currentOrgCode;

	private String institutionCode;
	private String institutionName;
	private String agencyCode;
	private String agencyName;
	private String marketManagerId;
	private String realName;
	private int tjType;
	private String cuserOrg;
	private int currentUserId;

	public int getCurrentUserId() {
		return currentUserId;
	}

	public void setCurrentUserId(int currentUserId) {
		this.currentUserId = currentUserId;
	}

	public String getCuserOrg() {
		return cuserOrg;
	}

	public void setCuserOrg(String cuserOrg) {
		this.cuserOrg = cuserOrg;
	}

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

	public String getMarketManagerId() {
		return marketManagerId;
	}

	public void setMarketManagerId(String marketManagerId) {
		this.marketManagerId = marketManagerId;
	}

	public String getRealName() {
		return realName;
	}

	public void setRealName(String realName) {
		this.realName = realName;
	}

	public String getBeginDate() {
		return beginDate;
	}

	public void setBeginDate(String beginDate) {
		this.beginDate = beginDate;
	}

	public String getEndDate() {
		return endDate;
	}

	public void setEndDate(String endDate) {
		this.endDate = endDate;
	}

	public String getCurrentOrgCode() {
		return currentOrgCode;
	}

	public void setCurrentOrgCode(String currentOrgCode) {
		this.currentOrgCode = currentOrgCode;
	}

	public String getInstitutionCode() {
		return institutionCode;
	}

	public void setInstitutionCode(String institutionCode) {
		this.institutionCode = institutionCode;
	}

	public int getTjType() {
		return tjType;
	}

	public void setTjType(int tjType) {
		this.tjType = tjType;
	}

	public String getInstitutionName() {
		return institutionName;
	}

	public void setInstitutionName(String institutionName) {
		this.institutionName = institutionName;
	}

}
