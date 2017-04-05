package cls.pilottery.oms.business.form;

import java.util.ArrayList;
import java.util.List;

import cls.pilottery.common.entity.AbstractEntity;
import cls.pilottery.oms.business.model.AgencyStatus;

public class AgencyForm extends AbstractEntity {

	private static final long serialVersionUID = 444620900146698766L;
	private String agencyCode;
	private String agencyName;
	private AgencyStatus agencyStatus;
	private List<AgencyStatus> agencyStatuses;
	private String areaCode;
	private Long agencytype;
	// 切换城市
	private String allCities;
	private Long curCityCode;
	private String curCityName;
	private String bank;
	private String bankaccount;
	private String sqltype;

	private String cuserOrg;

	public AgencyForm() {
		agencyStatuses = new ArrayList<AgencyStatus>();
		agencyStatuses.add(new AgencyStatus(1));
		agencyStatuses.add(new AgencyStatus(2));
		agencyStatuses.add(new AgencyStatus(3));
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

	public AgencyStatus getAgencyStatus() {
		return agencyStatus;
	}

	public void setAgencyStatus(AgencyStatus agencyStatus) {
		this.agencyStatus = agencyStatus;
	}

	public List<AgencyStatus> getAgencyStatuses() {
		return agencyStatuses;
	}

	public void setAgencyStatuses(List<AgencyStatus> agencyStatuses) {
		this.agencyStatuses = agencyStatuses;
	}

	public String getAllCities() {
		return allCities;
	}

	public void setAllCities(String allCities) {
		this.allCities = allCities;
	}

	public Long getCurCityCode() {
		return curCityCode;
	}

	public void setCurCityCode(Long curCityCode) {
		this.curCityCode = curCityCode;
	}

	public String getCurCityName() {
		return curCityName;
	}

	public void setCurCityName(String curCityName) {
		this.curCityName = curCityName;
	}

	public String getAreaCode() {
		return areaCode;
	}

	public void setAreaCode(String areaCode) {
		this.areaCode = areaCode;
	}

	public Long getAgencytype() {
		return agencytype;
	}

	public void setAgencytype(Long agencytype) {
		this.agencytype = agencytype;
	}

	public String getBank() {
		return bank;
	}

	public void setBank(String bank) {
		this.bank = bank;
	}

	public String getBankaccount() {
		return bankaccount;
	}

	public void setBankaccount(String bankaccount) {
		this.bankaccount = bankaccount;
	}

	public String getSqltype() {
		return sqltype;
	}

	public void setSqltype(String sqltype) {
		this.sqltype = sqltype;
	}

	public String getCuserOrg() {
		return cuserOrg;
	}

	public void setCuserOrg(String cuserOrg) {
		this.cuserOrg = cuserOrg;
	}

}
