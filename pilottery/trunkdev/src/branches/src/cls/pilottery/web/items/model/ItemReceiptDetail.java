package cls.pilottery.web.items.model;

import java.io.Serializable;

public class ItemReceiptDetail implements Serializable {

	private static final long serialVersionUID = -3966769751256266735L;

	private String irNo;               //入库单编号（IR12345678）//非空//主键
    
    private String itemCode;           //物品编码（IT123456）//非空//主键
    
    private String itemName;           //物品名称（外表字段）
    
    private String baseUnit;           //单位名称（外表字段）

    private Integer quantity;          //数量

    public String getIrNo() {
        return irNo;
    }

    public void setIrNo(String irNo) {
        this.irNo = irNo == null ? null : irNo.trim();
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
	
	public String getBaseUnit() {
		return baseUnit;
	}

	public void setBaseUnit(String baseUnit) {
		this.baseUnit = baseUnit == null ? null : baseUnit.trim();
	}

    public Integer getQuantity() {
        return quantity;
    }

    public void setQuantity(Integer quantity) {
        this.quantity = quantity;
    }
}
