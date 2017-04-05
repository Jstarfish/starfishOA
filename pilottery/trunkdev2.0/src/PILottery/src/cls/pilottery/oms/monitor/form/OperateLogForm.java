package cls.pilottery.oms.monitor.form;

import cls.pilottery.common.model.BaseEntity;

public class OperateLogForm extends BaseEntity {

	private static final long serialVersionUID = 6556135166808666829L;
	private String startTime;
	private String endTime;
	private String cuserOrg; // 当前用户所属部门
	private Long operAdmin;// 操作人
	private String operAdminName;
	private String orgCode;
	private String orgName;
	private String agencyCode;
	private String agencyName;
	private Long marketAdmin;
	private String marketAdminName;

	private Long operModeId;
	private String operModeName;

	private Long operateCode;
	private Integer operStatus;

	private Integer selType;

	public Integer getSelType() {
		return selType;
	}

	public void setSelType(Integer selType) {
		this.selType = selType;
	}

	public String getCuserOrg() {
		return cuserOrg;
	}

	public void setCuserOrg(String cuserOrg) {
		this.cuserOrg = cuserOrg;
	}

	public String getStartTime() {
		return startTime;
	}

	public String getOperAdminName() {
		return operAdminName;
	}

	public void setOperAdminName(String operAdminName) {
		this.operAdminName = operAdminName;
	}

	public void setStartTime(String startTime) {
		this.startTime = startTime;
	}

	public String getEndTime() {
		return endTime;
	}

	public void setEndTime(String endTime) {
		this.endTime = endTime;
	}

	public Long getOperAdmin() {
		return operAdmin;
	}

	public void setOperAdmin(Long operAdmin) {
		this.operAdmin = operAdmin;
	}

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

	public Long getMarketAdmin() {
		return marketAdmin;
	}

	public void setMarketAdmin(Long marketAdmin) {
		this.marketAdmin = marketAdmin;
	}

	public String getMarketAdminName() {
		return marketAdminName;
	}

	public void setMarketAdminName(String marketAdminName) {
		this.marketAdminName = marketAdminName;
	}

	public Long getOperModeId() {
		return operModeId;
	}

	public void setOperModeId(Long operModeId) {
		this.operModeId = operModeId;
	}

	public String getOperModeName() {
		return operModeName;
	}

	public void setOperModeName(String operModeName) {
		this.operModeName = operModeName;
	}

	public Long getOperateCode() {
		return operateCode;
	}

	public void setOperateCode(Long operateCode) {
		this.operateCode = operateCode;
	}

	public Integer getOperStatus() {
		return operStatus;
	}

	public void setOperStatus(Integer operStatus) {
		this.operStatus = operStatus;
	}

}
