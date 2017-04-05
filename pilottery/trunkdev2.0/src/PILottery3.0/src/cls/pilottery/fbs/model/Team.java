package cls.pilottery.fbs.model;

import cls.pilottery.common.model.BaseEntity;

public class Team extends BaseEntity {

	private static final long serialVersionUID = 3685532341071132442L;

	private String teamCode;
	private String countryCode;
	private String countryName;
	private String fullName;
	private String shortName;
	private String remark;

	public String getTeamCode() {
		return teamCode;
	}

	public String getCountryName() {
		return countryName;
	}

	public void setCountryName(String countryName) {
		this.countryName = countryName;
	}

	public void setTeamCode(String teamCode) {
		this.teamCode = teamCode;
	}

	public String getCountryCode() {
		return countryCode;
	}

	public void setCountryCode(String countryCode) {
		this.countryCode = countryCode;
	}

	public String getFullName() {
		return fullName;
	}

	public void setFullName(String fullName) {
		this.fullName = fullName;
	}

	public String getShortName() {
		return shortName;
	}

	public void setShortName(String shortName) {
		this.shortName = shortName;
	}

	public String getRemark() {
		return remark;
	}

	public void setRemark(String remark) {
		this.remark = remark;
	}

}
