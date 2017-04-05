package cls.pilottery.web.report.form;

public class GoodsReceiptsReportForm implements java.io.Serializable {

	private static final long serialVersionUID = 8523551347635937570L;
	private String whouseCode;
	private String insCode;
	private String begDate;
	private String endDate;

	public String getWhouseCode() {
		return whouseCode;
	}

	public void setWhouseCode(String whouseCode) {
		this.whouseCode = whouseCode;
	}

	public String getBegDate() {
		return begDate;
	}

	public void setBegDate(String begDate) {
		this.begDate = begDate;
	}

	public String getEndDate() {
		return endDate;
	}

	public void setEndDate(String endDate) {
		this.endDate = endDate;
	}

	public String getInsCode() {
		return insCode;
	}

	public void setInsCode(String insCode) {
		this.insCode = insCode;
	}

}
