package cls.pilottery.web.items.entity;

import java.io.Serializable;

//2.1.10.9
//与数据库表字段一一对应，不在系统中使用
public class ItemCheckDetailAfter implements Serializable {

	private static final long serialVersionUID = -8520588150918516766L;

	private String checkNo;               //盘点编号（II12345678）//CHECK_NO//CHAR(10)//非空
	private String itemCode;              //物品编码（IT123456）//ITEM_CODE//CHAR(8)
	private Integer quantity;             //数量//QUANTITY//NUMBER(10)
	private Integer changeQuantity;       //调整量//CHANGE_QUANTITY//NUMBER(10)
	private Integer result;               //盘点结果（1-一致，2-盘亏，3-盘盈）//RESULT//NUMBER(1)//非空
	private String remark;                //备注//REMARK//VARCHAR2(4000)
	
	public String getCheckNo() {
		return checkNo;
	}
	public void setCheckNo(String checkNo) {
		this.checkNo = checkNo == null ? null : checkNo.trim();
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
	
	public Integer getChangeQuantity() {
		return changeQuantity;
	}
	public void setChangeQuantity(Integer changeQuantity) {
		this.changeQuantity = changeQuantity;
	}
	
	public Integer getResult() {
		return result;
	}
	public void setResult(Integer result) {
		this.result = result;
	}
	
	public String getRemark() {
		return remark;
	}
	public void setRemark(String remark) {
		this.remark = remark == null ? null : remark.trim();
	}
}
