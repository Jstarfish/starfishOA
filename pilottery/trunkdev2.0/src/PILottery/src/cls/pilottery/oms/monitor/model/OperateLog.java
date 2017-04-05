package cls.pilottery.oms.monitor.model;

import java.util.Date;

public class OperateLog {

	private String operNo;// 操作日志编号
	private Integer operPrivilege;// 功能模块代码（菜单名称）
	private Integer operAdmin;// 操作人
	private String operAdminName;
	private Date operTime;// 操作时间
	private Integer operModeId;// 操作类型（1=新增；2=删除；3=更改）
	private String operModeName;
	private String operModeThreshold; // OPER_MODE_THRESHOLD 操作类型阈值
	private Integer operStatus;
	private String orgCode;
	private String orgName;
	private String agencyCode;
	private String agencyName;
	private Long marketAdmin;
	private String marketAdminName;
	private String operContents;// 操作内容

	public String getOperModeName() {
		return operModeName;
	}

	public void setOperModeName(String operModeName) {
		this.operModeName = operModeName;
	}

	public String getOperAdminName() {
		return operAdminName;
	}

	public void setOperAdminName(String operAdminName) {
		this.operAdminName = operAdminName;
	}

	public String getOperNo() {
		return operNo;
	}

	public void setOperNo(String operNo) {
		this.operNo = operNo;
	}

	public String getOrgName() {
		return orgName;
	}

	public void setOrgName(String orgName) {
		this.orgName = orgName;
	}

	public String getAgencyName() {
		return agencyName;
	}

	public void setAgencyName(String agencyName) {
		this.agencyName = agencyName;
	}

	public String getMarketAdminName() {
		return marketAdminName;
	}

	public void setMarketAdminName(String marketAdminName) {
		this.marketAdminName = marketAdminName;
	}

	public Integer getOperPrivilege() {
		return operPrivilege;
	}

	public void setOperPrivilege(Integer operPrivilege) {
		this.operPrivilege = operPrivilege;
	}

	public Integer getOperAdmin() {
		return operAdmin;
	}

	public void setOperAdmin(Integer operAdmin) {
		this.operAdmin = operAdmin;
	}

	public Date getOperTime() {
		return operTime;
	}

	public void setOperTime(Date operTime) {
		this.operTime = operTime;
	}

	public Integer getOperModeId() {
		return operModeId;
	}

	public void setOperModeId(Integer operModeId) {
		this.operModeId = operModeId;
	}

	public String getOperModeThreshold() {
		return operModeThreshold;
	}

	public void setOperModeThreshold(String operModeThreshold) {
		this.operModeThreshold = operModeThreshold;
	}

	public Integer getOperStatus() {
		return operStatus;
	}

	public void setOperStatus(Integer operStatus) {
		this.operStatus = operStatus;
	}

	public String getOrgCode() {
		return orgCode;
	}

	public void setOrgCode(String orgCode) {
		this.orgCode = orgCode;
	}

	public String getAgencyCode() {
		return agencyCode;
	}

	public void setAgencyCode(String agencyCode) {
		this.agencyCode = agencyCode;
	}

	public Long getMarketAdmin() {
		return marketAdmin;
	}

	public void setMarketAdmin(Long marketAdmin) {
		this.marketAdmin = marketAdmin;
	}

	public String getOperContents() {
		return operContents;
	}

	public void setOperContents(String operContents) {
		this.operContents = operContents;
	}

}
