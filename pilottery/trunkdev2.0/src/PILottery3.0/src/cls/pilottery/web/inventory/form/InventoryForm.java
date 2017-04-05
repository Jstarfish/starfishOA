package cls.pilottery.web.inventory.form;

public class InventoryForm {
    private String whcode;
    private String planCode;
    private String batchNo;
    private String prizeGroup;
    private String orgCode;
	//分页参数
	private Integer beginNum;
	private Integer endNum;
	public String getWhcode() {
		return whcode;
	}
	public void setWhcode(String whcode) {
		this.whcode = whcode;
	}
	public String getPlanCode() {
		return planCode;
	}
	public void setPlanCode(String planCode) {
		this.planCode = planCode;
	}
	
	public String getBatchNo() {
		return batchNo;
	}
	public void setBatchNo(String batchNo) {
		this.batchNo = batchNo;
	}
	public String getPrizeGroup() {
		return prizeGroup;
	}
	public void setPrizeGroup(String prizeGroup) {
		this.prizeGroup = prizeGroup;
	}
	public Integer getBeginNum() {
		return beginNum;
	}
	public void setBeginNum(Integer beginNum) {
		this.beginNum = beginNum;
	}
	public Integer getEndNum() {
		return endNum;
	}
	public void setEndNum(Integer endNum) {
		this.endNum = endNum;
	}
	public String getOrgCode() {
		return orgCode;
	}
	public void setOrgCode(String orgCode) {
		this.orgCode = orgCode;
	}
    
}
