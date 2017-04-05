package cls.pilottery.web.inventory.model;

import java.util.Date;

public class CheckPointInfoVo {
	private String cpNo;// 盘点编号
	private String cpName;// 盘点名称
	private String planCode;
	private String planName;
	private String batchNo;	
	private String houseCode;// 仓库编号
	private String houseName;// 仓库名称
	private Date cpDate;// 盘点日期
	private Integer status;// 盘点状态
	private Integer result;// 盘点结果
	private String chName;// 盘点人
	private long chId;// 盘点人Id
	private String remark;
	
	public String getHouseCode() {
		return houseCode;
	}
	public void setHouseCode(String houseCode) {
		this.houseCode = houseCode;
	}
	public String getHouseName() {
		return houseName;
	}
	public void setHouseName(String houseName) {
		this.houseName = houseName;
	}
	public Date getCpDate() {
		return cpDate;
	}
	public void setCpDate(Date cpDate) {
		this.cpDate = cpDate;
	}
	public Integer getStatus() {
		return status;
	}
	public void setStatus(Integer status) {
		this.status = status;
	}
	public Integer getResult() {
		return result;
	}
	public void setResult(Integer result) {
		this.result = result;
	}
	public String getChName() {
		return chName;
	}
	public void setChName(String chName) {
		this.chName = chName;
	}
	public long getChId() {
		return chId;
	}
	public void setChId(long chId) {
		this.chId = chId;
	}
	
	public String getCpNo() {
		return cpNo;
	}
	public void setCpNo(String cpNo) {
		this.cpNo = cpNo;
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
	public String getCpName() {
		return cpName;
	}
	public void setCpName(String cpName) {
		this.cpName = cpName;
	}
	public String getPlanName() {
		return planName;
	}
	public void setPlanName(String planName) {
		this.planName = planName;
	}
	public String getRemark() {
		return remark;
	}
	public void setRemark(String remark) {
		this.remark = remark;
	}
	
}
