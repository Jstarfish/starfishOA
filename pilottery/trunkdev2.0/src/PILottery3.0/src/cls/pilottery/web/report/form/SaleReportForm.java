package cls.pilottery.web.report.form;

public class SaleReportForm implements java.io.Serializable {
	private static final long serialVersionUID = -2468299708164263284L;
	private String beginDate;
	private String endDate;
	private String planCode;
	private String institutionCode;
	private String outletCode;
	private String currentOrgCode;
	private String warehouseCode;
	private int currentUserId;
	private String cuserOrg;
	private String marketAdmin;
	private int tjType;

	public String getMarketAdmin() {
		return marketAdmin;
	}
	public void setMarketAdmin(String marketAdmin) {
		this.marketAdmin = marketAdmin;
	}
	private String marketName;

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
	public String getPlanCode() {
		return planCode;
	}
	public void setPlanCode(String planCode) {
		this.planCode = planCode;
	}
	public String getInstitutionCode() {
		return institutionCode;
	}
	public void setInstitutionCode(String institutionCode) {
		this.institutionCode = institutionCode;
	}
	public String getCurrentOrgCode() {
		return currentOrgCode;
	}
	public void setCurrentOrgCode(String currentOrgCode) {
		this.currentOrgCode = currentOrgCode;
	}
	public String getWarehouseCode() {
		return warehouseCode;
	}
	public void setWarehouseCode(String warehouseCode) {
		this.warehouseCode = warehouseCode;
	}
	public int getCurrentUserId() {
		return currentUserId;
	}
	public void setCurrentUserId(int currentUserId) {
		this.currentUserId = currentUserId;
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
	public String getMarketName() {
		return marketName;
	}
	public void setMarketName(String marketName) {
		this.marketName = marketName;
	}
	public int getTjType() {
		return tjType;
	}
	public void setTjType(int tjType) {
		this.tjType = tjType;
	}
	
}
