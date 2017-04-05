package cls.pilottery.oms.business.model.areamodel;

import cls.pilottery.common.entity.AbstractEntity;

public class OMSArea extends AbstractEntity {

	private static final long serialVersionUID = 7841505690017165616L;
	private String areaCode;
	private String  areaName;
	private String fatherArea;
	private Integer status;
	private Integer areaType;
	private Integer agencyNumberLimit;
	private String  agencyNumberLimitString;
	private Integer tellerNumberLimit;
	private String  tellerNumberLimitString;
	private Integer terminalNumberLimit;
	private String  terminalNumberLimitString;
	
	public String getAreaCode() {
		return areaCode;
	}
	public void setAreaCode(String areaCode) {
		this.areaCode = areaCode;
	}
	public String getAreaName() {
		return areaName;
	}
	public void setAreaName(String areaName) {
		this.areaName = areaName;
	}
	public String getFatherArea() {
		return fatherArea;
	}
	public void setFatherArea(String fatherArea) {
		this.fatherArea = fatherArea;
	}
	public Integer getStatus() {
		return status;
	}
	public void setStatus(Integer status) {
		this.status = status;
	}
	public Integer getAreaType() {
		return areaType;
	}
	public void setAreaType(Integer areaType) {
		this.areaType = areaType;
	}
	public Integer getAgencyNumberLimit() {
		return agencyNumberLimit;
	}
	public void setAgencyNumberLimit(Integer agencyNumberLimit) {
		this.agencyNumberLimit = agencyNumberLimit;
	}
	public String getAgencyNumberLimitString() {
		return agencyNumberLimitString;
	}
	public void setAgencyNumberLimitString(String agencyNumberLimitString) {
		this.agencyNumberLimitString = agencyNumberLimitString;
	}
	public Integer getTellerNumberLimit() {
		return tellerNumberLimit;
	}
	public void setTellerNumberLimit(Integer tellerNumberLimit) {
		this.tellerNumberLimit = tellerNumberLimit;
	}
	public String getTellerNumberLimitString() {
		return tellerNumberLimitString;
	}
	public void setTellerNumberLimitString(String tellerNumberLimitString) {
		this.tellerNumberLimitString = tellerNumberLimitString;
	}
	public Integer getTerminalNumberLimit() {
		return terminalNumberLimit;
	}
	public void setTerminalNumberLimit(Integer terminalNumberLimit) {
		this.terminalNumberLimit = terminalNumberLimit;
	}
	public String getTerminalNumberLimitString() {
		return terminalNumberLimitString;
	}
	public void setTerminalNumberLimitString(String terminalNumberLimitString) {
		this.terminalNumberLimitString = terminalNumberLimitString;
	}
}
