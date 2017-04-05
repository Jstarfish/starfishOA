package cls.pilottery.web.items.model;

import java.io.Serializable;

public class ItemIssueDetail implements Serializable {

	private static final long serialVersionUID = -5964873947392751550L;
	
	private String iiNo;               //入库单编号（II12345678）//非空//主键
    
    private String itemCode;           //物品编码（IT123456）//非空//主键
    
    private String itemName;           //物品名称（外表字段）
    
    private String baseUnit;           //单位名称（外表字段）

    private Integer quantity;          //数量

	public String getIiNo() {
		return iiNo;
	}

	public void setIiNo(String iiNo) {
		this.iiNo = iiNo == null ? null : iiNo.trim();
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
