package cls.pilottery.web.items.model;

import java.io.Serializable;

public class ItemQuantity implements Serializable {
	
	private static final long serialVersionUID = 3144995969677728671L;

	private String itemCode;           //物品编码（IT123456）//非空//主键

    private String warehouseCode;      //所在仓库编码//非空//主键
    
    private String itemName;           //物品名称//非空
    
    private String warehouseName;      //所在仓库名称（外表字段）

    private Integer quantity;          //物品数量//非空

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
    
	public String getWarehouseName() {
		return warehouseName;
	}

	public void setWarehouseName(String warehouseName) {
		this.warehouseName = warehouseName == null ? null : warehouseName.trim();
	}

    public Integer getQuantity() {
        return quantity;
    }

    public void setQuantity(Integer quantity) {
        this.quantity = quantity;
    }
}
