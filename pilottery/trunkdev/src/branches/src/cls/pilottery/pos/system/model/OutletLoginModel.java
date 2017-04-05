package cls.pilottery.pos.system.model;

import java.io.Serializable;

public class OutletLoginModel implements Serializable {
	private static final long serialVersionUID = 8049431833705005290L;
	private String agencyCode;
	private String agencyName;
	private int status;
	private String orgCode;
	private String areaCode;
	private String loginPwd;
	private String transPwd;
	private String marketManageId;
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
	public int getStatus() {
		return status;
	}
	public void setStatus(int status) {
		this.status = status;
	}
	public String getOrgCode() {
		return orgCode;
	}
	public void setOrgCode(String orgCode) {
		this.orgCode = orgCode;
	}
	public String getAreaCode() {
		return areaCode;
	}
	public void setAreaCode(String areaCode) {
		this.areaCode = areaCode;
	}
	public String getLoginPwd() {
		return loginPwd;
	}
	public void setLoginPwd(String loginPwd) {
		this.loginPwd = loginPwd;
	}
	public String getTransPwd() {
		return transPwd;
	}
	public void setTransPwd(String transPwd) {
		this.transPwd = transPwd;
	}
	public String getMarketManageId() {
		return marketManageId;
	}
	public void setMarketManageId(String marketManageId) {
		this.marketManageId = marketManageId;
	}
}
