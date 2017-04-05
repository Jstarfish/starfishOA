package cls.pilottery.web.outlet.model;

import java.io.Serializable;

public class AreaAgencyCode implements Serializable{
	@Override
	public String toString() {
		return "AreaAgencyCode [areaCode=" + areaCode + ", orgCode=" + orgCode + "]";
	}

	private static final long serialVersionUID = 1L;
	
	private String areaCode;
	
	private String orgCode;

	public AreaAgencyCode() {
	}

	public String getAreaCode() {
		return areaCode;
	}

	public void setAreaCode(String areaCode) {
		this.areaCode = areaCode;
	}

	public String getOrgCode() {
		return orgCode;
	}

	public void setOrgCode(String orgCode) {
		this.orgCode = orgCode;
	}
}
