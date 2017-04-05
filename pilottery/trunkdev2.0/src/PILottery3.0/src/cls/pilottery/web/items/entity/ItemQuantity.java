package cls.pilottery.web.items.entity;

import java.io.Serializable;

//2.1.10.2
//与数据库表字段一一对应，不在系统中使用
public class ItemQuantity implements Serializable {

	private static final long serialVersionUID = 4149158411420778995L;

	private String itemCode;         //物品编码（IT123456）//ITEM_CODE//CHAR(8)//非空
	private String warehouseCode;    //所在仓库//WAREHOUSE_CODE//CHAR(4)//非空
	private String itemName;         //物品名称//ITEM_NAME//VARCHAR2(4000)//非空
	private String quantity;         //物品数量//QUANTITY//NUMBER(10)//非空
	
	public String getItemCode() {
		return itemCode;
	}
	public void setItemCode(String itemCode) {
		this.itemCode = itemCode == null ? null : itemCode.trim();
	}
	
	public String getWarehouseCode() {
		return warehouseCode;
	}
	public void setWarehouseCode(String warehouseCode) {
		this.warehouseCode = warehouseCode == null ? null : warehouseCode.trim();
	}
	
	public String getItemName() {
		return itemName;
	}
	public void setItemName(String itemName) {
		this.itemName = itemName == null ? null : itemName.trim();
	}
	
	public String getQuantity() {
		return quantity;
	}
	public void setQuantity(String quantity) {
		this.quantity = quantity == null ? null : quantity.trim();
	}
}
