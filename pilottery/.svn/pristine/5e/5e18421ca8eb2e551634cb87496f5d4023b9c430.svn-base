package cls.pilottery.oms.business.form.tmversionform;

import cls.pilottery.common.model.BaseEntity;
import cls.pilottery.oms.business.model.tmversionmodel.UpdatePlan;

public class PlanQueryForm extends BaseEntity {

	/**
	 * 
	 */
	private static final long serialVersionUID = -8442995131693185989L;

	// 中间条件
	private Integer planQueryType;
	private String planQueryString;

	private String fromDateString;
	private String toDateString;
	// 软件包版本号
	private String packageVersion;
	// 计划状态
	private Integer planState;
	// 终端机编码
	private String terminalCode;

	private UpdatePlan updatePlan;
	private String areaCode;

	public Integer getPlanQueryType() {
		return planQueryType;
	}

	public UpdatePlan getUpdatePlan() {
		return updatePlan;
	}

	public void setUpdatePlan(UpdatePlan updatePlan) {
		this.updatePlan = updatePlan;
	}

	public void setPlanQueryType(Integer planQueryType) {
		this.planQueryType = planQueryType;
	}

	public String getPlanQueryString() {
		return planQueryString;
	}

	public void setPlanQueryString(String planQueryString) {
		this.planQueryString = planQueryString;
	}

	public String getFromDateString() {
		return fromDateString;
	}

	public void setFromDateString(String fromDateString) {
		this.fromDateString = fromDateString;
	}

	public String getToDateString() {
		return toDateString;
	}

	public void setToDateString(String toDateString) {
		this.toDateString = toDateString;
	}

	public String getPackageVersion() {
		return packageVersion;
	}

	public void setPackageVersion(String packageVersion) {
		this.packageVersion = packageVersion;
	}

	public Integer getPlanState() {
		return planState;
	}

	public void setPlanState(Integer planState) {
		this.planState = planState;
	}

	public String getTerminalCode() {
		return terminalCode;
	}

	public void setTerminalCode(String terminalCode) {
		this.terminalCode = terminalCode;
	}

	public String getAreaCode() {
		return areaCode;
	}

	public void setAreaCode(String areaCode) {
		this.areaCode = areaCode;
	}

	public void beforeQuery() {
		if ((planQueryString != null) && (!planQueryString.isEmpty())) {
			int v = planQueryType;
			switch (v) {
			case 1:
				packageVersion = planQueryString;
				break;
			case 2:
				planState = Integer.parseInt(planQueryString);
				;
				break;
			case 3:
				terminalCode = planQueryString;
				break;

			default:
				break;
			}
		}
	}
}
