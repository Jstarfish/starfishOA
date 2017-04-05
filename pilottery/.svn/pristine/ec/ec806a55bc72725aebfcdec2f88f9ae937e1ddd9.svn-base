package cls.pilottery.web.items.model;

import java.io.Serializable;

public class ItemDamage implements Serializable {

	private static final long serialVersionUID = 5254910204286332609L;

	private String idNo;             //损毁登记编号（SH12345678）//ID_NO//CHAR(10)//非空
	private String damageDate;       //损毁日期//DAMAGE_DATE//DATE//非空
	private String itemCode;         //物品编码（IT123456）//ITEM_CODE//CHAR(8)//非空
	private String itemName;         //物品名称（外表字段）
	private Integer quantity;        //损毁数量//QUANTITY//NUMBER(10)//非空
	private Integer checkAdmin;      //操作人//CHECK_ADMIN//NUMBER(4)//非空
	private String checkAdminName;   //操作人姓名（外表字段）
	private String remark;           //备注//REMARK//VARCHAR2(2000)
	private String warehouseCode;    //仓库编码//WAREHOUSE_CODE//CHAR(10)
	private String warehouseName;    //仓库名称（外表字段）
	
	public String getIdNo() {
		return idNo;
	}
	public void setIdNo(String idNo) {
		this.idNo = idNo == null ? null : idNo.trim();
	}
	
	public String getDamageDate() {
		return damageDate;
	}
	public void setDamageDate(String damageDate) {
		this.damageDate = damageDate== null ? null : damageDate.trim();
	}
	
	public String getItemCode() {
		return itemCode;
	}
	public void setItemCode(String itemCode) {
		this.itemCode = itemCode == null ? null : itemCode.trim();
	}
	
	public String getItemName() {
		return itemName;
	}
	public void setItemName(String itemName) {
		this.itemName = itemName == null ? null : itemName.trim();
	}
	
	public Integer getQuantity() {
		return quantity;
	}
	public void setQuantity(Integer quantity) {
		this.quantity = quantity;
	}
	
	public Integer getCheckAdmin() {
		return checkAdmin;
	}
	public void setCheckAdmin(Integer checkAdmin) {
		this.checkAdmin = checkAdmin;
	}
	
	public String getCheckAdminName() {
		return checkAdminName;
	}
	public void setCheckAdminName(String checkAdminName) {
		this.checkAdminName = checkAdminName == null ? null : checkAdminName.trim();
	}
	
	public String getRemark() {
		return remark;
	}
	public void setRemark(String remark) {
		this.remark = remark == null ? null : remark.trim();
	}
	
	public String getWarehouseCode() {
		return warehouseCode;
	}
	public void setWarehouseCode(String warehouseCode) {
		this.warehouseCode = warehouseCode == null ? null : warehouseCode.trim();
	}
	
	public String getWarehouseName() {
		return warehouseName;
	}
	public void setWarehouseName(String warehouseName) {
		this.warehouseName = warehouseName == null ? null : warehouseName.trim();
	}
}
