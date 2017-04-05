package cls.pilottery.web.items.entity;

import java.io.Serializable;

//2.1.10.4
//与数据库表字段一一对应，不在系统中使用
public class ItemReceiptDetail implements Serializable {

	private static final long serialVersionUID = -1986981128373578725L;

	private String irNo;           //入库单编号（IR12345678）//IR_NO//CHAR(10)//非空
	private String itemCode;       //物品编码（IT123456）//ITEM_CODE//CHAR(8)
	private Integer quantity;      //数量//QUANTITY//NUMBER(10)
	
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
    
    public Integer getQuantity() {
        return quantity;
    }
    public void setQuantity(Integer quantity) {
        this.quantity = quantity;
    }
}
