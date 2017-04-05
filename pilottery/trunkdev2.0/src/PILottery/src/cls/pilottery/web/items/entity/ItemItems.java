package cls.pilottery.web.items.entity;

import java.io.Serializable;

//2.1.10.1
//与数据库表字段一一对应，不在系统中使用
public class ItemItems implements Serializable {

	private static final long serialVersionUID = -5861491473528758024L;

	private String itemCode;       //物品编码（IT123456）//ITEM_CODE//CHAR(8)//非空
	private String itemName;       //物品名称//ITEM_NAME//VARCHAR2(4000)//非空
	private String baseUnitName;   //单位名称//BASE_UNIT_NAME//VARCHAR2(500)//非空
	private Integer status;        //状态（1-启用，2-删除）//STATUS//NUMBER(1)//非空
	
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
	
	public String getBaseUnitName() {
		return baseUnitName;
	}
	public void setBaseUnitName(String baseUnitName) {
		this.baseUnitName = baseUnitName == null ? null : baseUnitName.trim();
	}
	
	public Integer getStatus() {
		return status;
	}
	public void setStatus(Integer status) {
		this.status = status;
	}
}
