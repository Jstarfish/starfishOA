package cls.pilottery.oms.monitor.form;

import cls.pilottery.common.model.BaseEntity;

public class LogForm extends BaseEntity {

	private static final long serialVersionUID = -8832253657784390913L;
	private String logDate;

	private String beginDate;
	private String endDate;

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

	public String getLogDate() {
		return logDate;
	}

	public void setLogDate(String logDate) {
		this.logDate = logDate;
	}
}
