package cls.pilottery.web.monitor.form;

import cls.pilottery.common.model.BaseEntity;

public class HistoryForm extends BaseEntity {

	private static final long serialVersionUID = 4084673340944545718L;

	private String orgCode;
	private String orgName;
	private String beginDate;
	private String endDate;

	private String cuserOrg;
	private int tjType;

	public int getTjType() {
		return tjType;
	}

	public void setTjType(int tjType) {
		this.tjType = tjType;
	}

	public String getCuserOrg() {
		return cuserOrg;
	}

	public void setCuserOrg(String cuserOrg) {
		this.cuserOrg = cuserOrg;
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

}
