package cls.pilottery.web.capital.form;

import cls.pilottery.common.model.BaseEntity;

public class CapitalRecordForm extends BaseEntity {
	private static final long serialVersionUID = -3953744345802860769L;
	private String beginDate;
	private String endDate;
	private String type;
	private String flowNo;
	private String crtorg;
	public String getBeginDate() {
		return beginDate;
	}
	public void setBeginDate(String beginDate) {
		this.beginDate = beginDate;
	}
	public String getEndDate() {
		return endDate;
	}
	public void setEndDate(String endDate) {
		this.endDate = endDate;
	}
	public String getType() {
		return type;
	}
	public void setType(String type) {
		this.type = type;
	}
	public String getFlowNo() {
		return flowNo;
	}
	public void setFlowNo(String flowNo) {
		this.flowNo = flowNo;
	}
	public String getCrtorg() {
		return crtorg;
	}
	public void setCrtorg(String crtorg) {
		this.crtorg = crtorg;
	}
}
