package cls.pilottery.web.goodsreceipts.model;

public class GameBatchParamt {
   private String planCode;//方案
   private String batchCode;//批次
   private String packUnit;//箱
   private String packUnitCode;//箱号
   private Long ticketNum;//票数
   private Long bachamount;//钱数
   private String groupCode;//奖组
   private String firstPkgCode;//手本
   private Long   userId;//创建人
   private Long warehouseId;//仓库id;
   private int packUnitValue;//
   
  

public String getPlanCode() {
	return planCode;
}
public void setPlanCode(String planCode) {
	this.planCode = planCode;
}
public String getBatchCode() {
	return batchCode;
}
public void setBatchCode(String batchCode) {
	this.batchCode = batchCode;
}
public String getPackUnit() {
	return packUnit;
}
public void setPackUnit(String packUnit) {
	this.packUnit = packUnit;
}
public String getPackUnitCode() {
	return packUnitCode;
}
public void setPackUnitCode(String packUnitCode) {
	this.packUnitCode = packUnitCode;
}
public Long getTicketNum() {
	return ticketNum;
}
public void setTicketNum(Long ticketNum) {
	this.ticketNum = ticketNum;
}
public Long getBachamount() {
	return bachamount;
}
public void setBachamount(Long bachamount) {
	this.bachamount = bachamount;
}
public String getGroupCode() {
	return groupCode;
}
public void setGroupCode(String groupCode) {
	this.groupCode = groupCode;
}
public String getFirstPkgCode() {
	return firstPkgCode;
}
public void setFirstPkgCode(String firstPkgCode) {
	this.firstPkgCode = firstPkgCode;
}
public Long getUserId() {
	return userId;
}
public void setUserId(Long userId) {
	this.userId = userId;
}
public Long getWarehouseId() {
	return warehouseId;
}
public void setWarehouseId(Long warehouseId) {
	this.warehouseId = warehouseId;
}

public int getPackUnitValue() {
	return packUnitValue;
}
public void setPackUnitValue(int packUnitValue) {
	this.packUnitValue = packUnitValue;
}



   
}
