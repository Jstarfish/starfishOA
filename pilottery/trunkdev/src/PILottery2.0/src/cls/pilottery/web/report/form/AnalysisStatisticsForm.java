package cls.pilottery.web.report.form;

public class AnalysisStatisticsForm implements java.io.Serializable{
	private static final long serialVersionUID = 4759828330297297514L;
	private String institutionCode;
	private String beginDate;
	private String endDate;
	private String cuserOrg;
	private String outletCode;
	private String status;
	public String getInstitutionCode() {
		return institutionCode;
	}
	public void setInstitutionCode(String institutionCode) {
		this.institutionCode = institutionCode;
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
	public String getCuserOrg() {
		return cuserOrg;
	}
	public void setCuserOrg(String cuserOrg) {
		this.cuserOrg = cuserOrg;
	}
	public String getOutletCode() {
		return outletCode;
	}
	public void setOutletCode(String outletCode) {
		this.outletCode = outletCode;
	}
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}
}