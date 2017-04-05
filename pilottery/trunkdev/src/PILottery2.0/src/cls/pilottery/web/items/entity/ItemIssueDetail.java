package cls.pilottery.web.items.entity;

import java.io.Serializable;

//2.1.10.6
//与数据库表字段一一对应，不在系统中使用
public class ItemIssueDetail implements Serializable {

	private static final long serialVersionUID = -6933889108852375220L;

	private String iiNo;                  //出库单编号（II12345678）//II_NO//CHAR(10)//非空
	private String itemCode;              //物品编码（IT123456）//ITEM_CODE//CHAR(8)
	private Integer quantity;             //数量//QUANTITY//NUMBER(10)
	
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
	
	public Integer getQuantity() {
		return quantity;
	}
	public void setQuantity(Integer quantity) {
		this.quantity = quantity;
	}
}
