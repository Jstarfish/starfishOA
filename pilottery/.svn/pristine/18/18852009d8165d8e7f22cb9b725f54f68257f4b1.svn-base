package cls.pilottery.oms.business.form;

import java.util.ArrayList;
import java.util.List;

import cls.pilottery.common.entity.AbstractEntity;
import cls.pilottery.common.utils.RegexUtil;
import cls.pilottery.oms.business.model.AgencyStatus;
import cls.pilottery.oms.business.model.TerminalStatus;

public class TerminalForm  extends AbstractEntity{

	private static final long serialVersionUID = -8442555131693185159L;

	
	private String agencyCode;
	private String areaCode;
	private String agencyName;
	private AgencyStatus agencyStatus;
	private String  terminalCode;
	private String terminalUniqueCode;
	private String terminalMAC;
	private TerminalStatus terminalStatus;	
	private List<AgencyStatus> agencyStatuses;	
	private List<TerminalStatus> terminalStatuses;
	
	//切换城市
	private String allCities;	
	private Long curCityCode;
	private String curCityName;
	
	//中间条件
	private TerminalQueryType terminalQueryType;
	private List<TerminalQueryType> terminalQueryTypes;
	private String terminalQueryString;
	
	private String cuserOrg;
	
	public TerminalForm(){
		agencyStatuses = new ArrayList<AgencyStatus>(3);
		agencyStatuses.add(new AgencyStatus(1));
		agencyStatuses.add(new AgencyStatus(2));
		agencyStatuses.add(new AgencyStatus(3));
		terminalStatuses = new ArrayList<TerminalStatus>(3);
		terminalStatuses.add(new TerminalStatus(1));
		terminalStatuses.add(new TerminalStatus(2));
		terminalStatuses.add(new TerminalStatus(3));
//		terminalQueryTypes = new ArrayList<TerminalQueryType>(5);
//		terminalQueryTypes.add(new TerminalQueryType(1,"销售站编码"));
//		terminalQueryTypes.add(new TerminalQueryType(2,"销售站名称"));
//		terminalQueryTypes.add(new TerminalQueryType(3,"终端编码"));
//		terminalQueryTypes.add(new TerminalQueryType(4,"终端标识码"));
//		terminalQueryTypes.add(new TerminalQueryType(5,"终端MAC"));
	}
	
	public void beforeQuery(){
		if((terminalQueryString != null)&&(!terminalQueryString.isEmpty())){
			int v = terminalQueryType.getTypeValue();
			
			switch(v){
			case 1:
				agencyCode = terminalQueryString;
				break;
			case 2:
				agencyName = RegexUtil.StringFilter(terminalQueryString);
				break;
			case 3:
				terminalCode = terminalQueryString;
				break;
			case 4:
				terminalUniqueCode = RegexUtil.StringFilter(terminalQueryString);
				break;
			case 5:
				terminalMAC = terminalQueryString.trim();
				break;
			default:
				break;
			}
		}
	}
	
	public String getTerminalCode() {
		return terminalCode;
	}
	
	public void setTerminalCode(String terminalCode) {
		this.terminalCode = terminalCode;
	}
	
	public String getTerminalUniqueCode() {
		return terminalUniqueCode;
	}
	
	public void setTerminalUniqueCode(String terminalUniqueCode) {
		this.terminalUniqueCode = terminalUniqueCode;
	}
	
	public String getTerminalMAC() {
		return terminalMAC;
	}
	
	public void setTerminalMAC(String terminalMAC) {
		this.terminalMAC = terminalMAC;
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

	public TerminalStatus getTerminalStatus() {
		return terminalStatus;
	}

	public void setTerminalStatus(TerminalStatus terminalStatus) {
		this.terminalStatus = terminalStatus;
	}

	public List<AgencyStatus> getAgencyStatuses() {
		return agencyStatuses;
	}

	public void setAgencyStatuses(List<AgencyStatus> agencyStatuses) {
		this.agencyStatuses = agencyStatuses;
	}

	public List<TerminalStatus> getTerminalStatuses() {
		return terminalStatuses;
	}

	public void setTerminalStatuses(List<TerminalStatus> terminalStatuses) {
		this.terminalStatuses = terminalStatuses;
	}
	
	public TerminalQueryType getTerminalQueryType() {
		return terminalQueryType;
	}
	
	public void setTerminalQueryType(TerminalQueryType terminalQueryType) {
		this.terminalQueryType = terminalQueryType;
	}
	
	public List<TerminalQueryType> getTerminalQueryTypes() {
		return terminalQueryTypes;
	}
	
	public void setTerminalQueryTypes(List<TerminalQueryType> terminalQueryTypes) {
		this.terminalQueryTypes = terminalQueryTypes;
	}
	
	public String getTerminalQueryString() {
		return terminalQueryString;
	}
	
	public void setTerminalQueryString(String terminalQueryString) {
		this.terminalQueryString = terminalQueryString;
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

	public String getCuserOrg() {
		return cuserOrg;
	}

	public void setCuserOrg(String cuserOrg) {
		this.cuserOrg = cuserOrg;
	}
	
}
