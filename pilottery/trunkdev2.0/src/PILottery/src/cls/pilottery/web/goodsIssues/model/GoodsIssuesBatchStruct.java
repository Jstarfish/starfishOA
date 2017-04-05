package cls.pilottery.web.goodsIssues.model;

public class GoodsIssuesBatchStruct {
private String planCode;//方案
private String batchNo;//批次
private Integer  validNumber;//有效位数（1-箱号、2-盒号、3-本号）
private String  trunkNo;//箱号
private String   boxNo;//盒号（箱号+盒子顺序号）
private String   boxNoe;//盒号（箱号+盒子顺序号）
private String  packageNo;//本号（当有效位数是箱和盒时，此为首本号）
private String  packageNoe;//本号（当有效位数是箱和盒时，此为首本号）
private Integer rewardGroup;//奖组
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
public Integer getValidNumber() {
	return validNumber;
}
public void setValidNumber(Integer validNumber) {
	this.validNumber = validNumber;
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
public String getBoxNoe() {
	return boxNoe;
}
public void setBoxNoe(String boxNoe) {
	this.boxNoe = boxNoe;
}
public String getPackageNo() {
	return packageNo;
}
public void setPackageNo(String packageNo) {
	this.packageNo = packageNo;
}
public String getPackageNoe() {
	return packageNoe;
}
public void setPackageNoe(String packageNoe) {
	this.packageNoe = packageNoe;
}
public Integer getRewardGroup() {
	return rewardGroup;
}
public void setRewardGroup(Integer rewardGroup) {
	this.rewardGroup = rewardGroup;
}

}
