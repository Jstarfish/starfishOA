package cls.pilottery.web.teller.form;

import cls.pilottery.common.entity.AbstractEntity;
import cls.pilottery.oms.business.model.AgencyStatus;
import cls.pilottery.web.teller.model.TellerStatus;
import cls.pilottery.web.teller.model.TellerType;

public class TellerForm  extends AbstractEntity{
	private static final long serialVersionUID = 8484879969475210428L;

	private String agencyCode;
	private String areaCode;
	private String agencyName;
	private AgencyStatus agencyStatus;
	private Long tellerCode;
	private String tellerName;
	private TellerType tellerType;
	private TellerStatus tellerStatus;
	private int queryType;
	private String tellerQueryString;
	private String cuserOrg;
	public String getAgencyCode() {
		return agencyCode;
	}
	public void setAgencyCode(String agencyCode) {
		this.agencyCode = agencyCode;
	}
	public String getAreaCode() {
		return areaCode;
	}
	public void setAreaCode(String areaCode) {
		this.areaCode = areaCode;
	}
	public String getAgencyName() {
		return agencyName;
	}
	public void setAgencyName(String agencyName) {
		this.agencyName = agencyName;
	}
	public AgencyStatus getAgencyStatus() {
		return agencyStatus;
	}
	public void setAgencyStatus(AgencyStatus agencyStatus) {
		this.agencyStatus = agencyStatus;
	}
	public Long getTellerCode() {
		return tellerCode;
	}
	public void setTellerCode(Long tellerCode) {
		this.tellerCode = tellerCode;
	}
	public String getTellerName() {
		return tellerName;
	}
	public void setTellerName(String tellerName) {
		this.tellerName = tellerName;
	}
	public TellerType getTellerType() {
		return tellerType;
	}
	public void setTellerType(TellerType tellerType) {
		this.tellerType = tellerType;
	}
	public TellerStatus getTellerStatus() {
		return tellerStatus;
	}
	public void setTellerStatus(TellerStatus tellerStatus) {
		this.tellerStatus = tellerStatus;
	}
	public int getQueryType() {
		return queryType;
	}
	public void setQueryType(int queryType) {
		this.queryType = queryType;
	}
	public String getTellerQueryString() {
		return tellerQueryString;
	}
	public void setTellerQueryString(String tellerQueryString) {
		this.tellerQueryString = tellerQueryString;
	}
	public String getCuserOrg() {
		return cuserOrg;
	}
	public void setCuserOrg(String cuserOrg) {
		this.cuserOrg = cuserOrg;
	}
}
