package cls.pilottery.web.checkTickets.form;

public class CheckStatisticForm {
	private String beginDate;
	private String endDate;
	private String orgCode;

	private Integer selDate;

	public Integer getSelDate() {
		return selDate;
	}

	public void setSelDate(Integer selDate) {
		this.selDate = selDate;
	}

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

	public String getOrgCode() {
		return orgCode;
	}

	public void setOrgCode(String orgCode) {
		this.orgCode = orgCode;
	}

}
