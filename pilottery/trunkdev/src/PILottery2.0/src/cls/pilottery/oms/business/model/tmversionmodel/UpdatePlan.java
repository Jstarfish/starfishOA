package cls.pilottery.oms.business.model.tmversionmodel;

import cls.pilottery.common.model.BaseEntity;
import cls.pilottery.oms.business.model.TerminalType;

public class UpdatePlan extends BaseEntity {

	/**
	 * 
	 */
	private static final long serialVersionUID = 147829576704534299L;
	/**
	 * 计划ID
	 */
	int planId;
	/**
	 * 计划名称
	 */
	String planName;

	/**
	 * 软件包版本号
	 * */
	String pkgVer;
	/**
	 * 
	 */
	String softNo;
	/**
	 * 终端机型
	 */
	Integer termType;
	/**
	 * 计划状态（1=计划中、2=已执行、3=已取消）
	 */
	Integer planStatus;
	/**
	 * 计划更新时间
	 */
	String updateDate;
	/**
	 * 建立时间
	 */
	String createDate;
	/**
	 * 执行时间
	 */
	String executeDate;
	/**
	 * 取消时间
	 */
	String cancelDate;

	/**
	 * 城市code
	 */
	String cityCode;

	/**
	 * 城市名称
	 */
	String cityName;
	/**
	 * 更新时间类型
	 */
	int timeType;

	//
	Integer finished;
	Integer total;

	//
	Integer province;
	Integer city;
	String termCodes;

	private TerminalType terminalTypes;

	public String getProgress() {
		return finished + "/" + total;
	}

	public Integer getFinished() {
		return finished;
	}

	public void setFinished(Integer finished) {
		this.finished = finished;
	}

	public Integer getTotal() {
		return total;
	}

	public void setTotal(Integer total) {
		this.total = total;
	}

	public Integer getProvince() {
		return province;
	}

	public void setProvince(Integer province) {
		this.province = province;
	}

	public Integer getCity() {
		return city;
	}

	public void setCity(Integer city) {
		this.city = city;
	}

	public String getTermCodes() {
		return termCodes;
	}

	public void setTermCodes(String termCodes) {
		this.termCodes = termCodes;
	}

	public String getPlanName() {
		return planName;
	}

	public void setPlanName(String planName) {
		this.planName = planName;
	}

	public String getPkgVer() {
		return pkgVer;
	}

	public void setPkgVer(String pkgVer) {
		this.pkgVer = pkgVer;
	}

	public Integer getTermType() {
		return termType;
	}

	public void setTermType(Integer termType) {
		this.termType = termType;
	}

	public Integer getPlanStatus() {
		return planStatus;
	}

	public void setPlanStatus(Integer planStatus) {
		this.planStatus = planStatus;
	}

	public String getUpdateDate() {
		return updateDate;
	}

	public void setUpdateDate(String updateDate) {
		this.updateDate = updateDate;
	}

	public String getCreateDate() {
		return createDate;
	}

	public void setCreateDate(String createDate) {
		this.createDate = createDate;
	}

	public String getExecuteDate() {
		return executeDate;
	}

	public void setExecuteDate(String executeDate) {
		this.executeDate = executeDate;
	}

	public String getCancelDate() {
		return cancelDate;
	}

	public void setCancelDate(String cancelDate) {
		this.cancelDate = cancelDate;
	}

	public String getCityCode() {
		return cityCode;
	}

	public void setCityCode(String cityCode) {
		this.cityCode = cityCode;
	}

	public String getCityName() {
		return cityName;
	}

	public void setCityName(String cityName) {
		this.cityName = cityName;
	}

	public String getSoftNo() {
		return softNo;
	}

	public void setSoftNo(String softNo) {
		this.softNo = softNo;
	}

	public int getPlanId() {
		return planId;
	}

	public void setPlanId(int planId) {
		this.planId = planId;
	}

	public int getTimeType() {
		return timeType;
	}

	public void setTimeType(int timeType) {
		this.timeType = timeType;
	}

	public TerminalType getTerminalTypes() {
		return terminalTypes;
	}

	public void setTerminalTypes(TerminalType terminalTypes) {
		this.terminalTypes = terminalTypes;
	}

}
