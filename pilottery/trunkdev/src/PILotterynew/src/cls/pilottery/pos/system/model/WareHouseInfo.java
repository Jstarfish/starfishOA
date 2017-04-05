package cls.pilottery.pos.system.model;

import java.io.Serializable;

public class WareHouseInfo implements Serializable {
	private static final long serialVersionUID = -7558323663221091670L;
	private String whCode;
	private String whName;
	private String orgName;
	private String contactPhone;
	public String getWhCode() {
		return whCode;
	}
	public void setWhCode(String whCode) {
		this.whCode = whCode;
	}
	public String getWhName() {
		return whName;
	}
	public void setWhName(String whName) {
		this.whName = whName;
	}
	public String getOrgName() {
		return orgName;
	}
	public void setOrgName(String orgName) {
		this.orgName = orgName;
	}
	public String getContactPhone() {
		return contactPhone;
	}
	public void setContactPhone(String contactPhone) {
		this.contactPhone = contactPhone;
	}
}
