package cls.pilottery.web.institutions.model;
/**
 * 
    * @ClassName: Area
    * @Description: 区域实体类
    * @author 于元华
    * @date 2015年9月8日
    *
 */

public class Area {

	private Long areaCode; // 区域编号
	private String areaName; // 区域名称

	private Long agencyLimit; // 销售站限制
	private Long tellerLimit; // 销售员限制
	private Long terminalLimit; // 销售终端限制
	private String agencyLimitString;
	private String tellerLimitString;
	private String terminalLimitString;
	private int useDefaultGames = 0; // 默认游戏参数
	private Long agencyCode; // 中心站
	private String userCode;
	private int agencyType;
	private String areacodeformat;
	private String parentcodeformat;

	public Long getAreaCode() {
		return areaCode;
	}

	public void setAreaCode(Long areaCode) {
		this.areaCode = areaCode;
	}

	public String getAreaName() {
		return areaName;
	}

	public void setAreaName(String areaName) {
		this.areaName = areaName;
	}

	public Long getAgencyLimit() {
		return agencyLimit;
	}

	public void setAgencyLimit(Long agencyLimit) {
		this.agencyLimit = agencyLimit;
	}

	public Long getTerminalLimit() {
		return terminalLimit;
	}

	public void setTerminalLimit(Long terminalLimit) {
		this.terminalLimit = terminalLimit;
	}

	public Long getTellerLimit() {
		return tellerLimit;
	}

	public void setTellerLimit(Long tellerLimit) {
		this.tellerLimit = tellerLimit;
	}

	public int getUseDefaultGames() {
		return useDefaultGames;
	}

	public void setUseDefaultGames(int useDefaultGames) {
		this.useDefaultGames = useDefaultGames;
	}

	public String getAgencyLimitString() {
		return agencyLimitString;
	}

	public void setAgencyLimitString(String agencyLimitString) {
		this.agencyLimitString = agencyLimitString;
	}

	public String getTellerLimitString() {
		return tellerLimitString;
	}

	public void setTellerLimitString(String tellerLimitString) {
		this.tellerLimitString = tellerLimitString;
	}

	public String getTerminalLimitString() {
		return terminalLimitString;
	}

	public void setTerminalLimitString(String terminalLimitString) {
		this.terminalLimitString = terminalLimitString;
	}

	public Long getAgencyCode() {
		return agencyCode;
	}

	public void setAgencyCode(Long agencyCode) {
		this.agencyCode = agencyCode;
	}

	public String getUserCode() {
		return userCode;
	}

	public void setUserCode(String userCode) {
		this.userCode = userCode;
	}

	public int getAgencyType() {
		return agencyType;
	}

	public void setAgencyType(int agencyType) {
		this.agencyType = agencyType;
	}

	public String getAreacodeformat() {
		return areacodeformat;
	}

	public void setAreacodeformat(String areacodeformat) {
		this.areacodeformat = areacodeformat;
	}

	public String getParentcodeformat() {
		return parentcodeformat;
	}

	public void setParentcodeformat(String parentcodeformat) {
		this.parentcodeformat = parentcodeformat;
	}

}
