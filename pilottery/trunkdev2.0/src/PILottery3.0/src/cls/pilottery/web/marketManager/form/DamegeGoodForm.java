package cls.pilottery.web.marketManager.form;

import java.io.Serializable;

public class DamegeGoodForm implements Serializable {
	private static final long serialVersionUID = -8536346333648281621L;
	private String planCode;
	private String batchNo;
	private int currentUserId;
	private String damageArray;	 //damageArray=#3,00001,00001-01,0000002#3,00001,00001-03,0000046#3,00001,00001-03,0000047
	private int status;		//被盗，丢失，损坏
	
	private String trunkNo;
	private String boxNo;
	private String packageNo;
	private String operateDate;
	private int totalTickets;
	private int totalPackages;
	private int totalAmount;
	private String brokenNo;
	private int packages;	
	private int amount;
	private String remark;
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
	public int getCurrentUserId() {
		return currentUserId;
	}
	public void setCurrentUserId(int currentUserId) {
		this.currentUserId = currentUserId;
	}
	public String getDamageArray() {
		return damageArray;
	}
	public void setDamageArray(String damageArray) {
		this.damageArray = damageArray;
	}
	public String getTrunkNo() {
		return trunkNo;
	}
	public void setTrunkNo(String trunkNo) {
		this.trunkNo = trunkNo;
	}
	public String getBoxNo() {
		return boxNo;
	}
	public void setBoxNo(String boxNo) {
		this.boxNo = boxNo;
	}
	public String getPackageNo() {
		return packageNo;
	}
	public void setPackageNo(String packageNo) {
		this.packageNo = packageNo;
	}
	public String getOperateDate() {
		return operateDate;
	}
	public void setOperateDate(String operateDate) {
		this.operateDate = operateDate;
	}
	public int getStatus() {
		return status;
	}
	public void setStatus(int status) {
		this.status = status;
	}
	public int getTotalTickets() {
		return totalTickets;
	}
	public void setTotalTickets(int totalTickets) {
		this.totalTickets = totalTickets;
	}
	public int getTotalAmount() {
		return totalAmount;
	}
	public void setTotalAmount(int totalAmount) {
		this.totalAmount = totalAmount;
	}
	public String getBrokenNo() {
		return brokenNo;
	}
	public void setBrokenNo(String brokenNo) {
		this.brokenNo = brokenNo;
	}
	public int getPackages() {
		return packages;
	}
	public void setPackages(int packages) {
		this.packages = packages;
	}
	public int getAmount() {
		return amount;
	}
	public void setAmount(int amount) {
		this.amount = amount;
	}
	public int getTotalPackages() {
		return totalPackages;
	}
	public void setTotalPackages(int totalPackages) {
		this.totalPackages = totalPackages;
	}
	public String getRemark() {
		return remark;
	}
	public void setRemark(String remark) {
		this.remark = remark;
	}
	@Override
	public String toString() {
		return "DamegeGoodForm [batchNo=" + batchNo + ", currentUserId=" + currentUserId + ", damageArray=" + damageArray + ", planCode=" + planCode + "]";
	}
}
