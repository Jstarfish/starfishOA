package cls.pilottery.oms.business.model;

public class OrgInfo implements java.io.Serializable{
	private static final long serialVersionUID = -1765203177638432162L;
	private String orgCode;
	private String orgName;
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
}
