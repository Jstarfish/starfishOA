package cls.pilottery.web.items.model;

import java.io.Serializable;

public class ItemCheckDetail implements Serializable {

	private static final long serialVersionUID = 7455519053508620149L;

	private String checkNo;             //盘点编码
	private String itemCode;            //物品编码
	private String itemName;            //物品名称
	private Integer beforeQuantity;     //盘点前数量
	private Integer checkQuantity;      //盘点数量

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
	
	public String getItemName() {
		return itemName;
	}
	public void setItemName(String itemName) {
		this.itemName = itemName == null ? null : itemName.trim();
	}
	
	public Integer getBeforeQuantity() {
		return beforeQuantity;
	}
	public void setBeforeQuantity(Integer beforeQuantity) {
		this.beforeQuantity = beforeQuantity;
	}
	
	public Integer getCheckQuantity() {
		return checkQuantity;
	}
	public void setCheckQuantity(Integer checkQuantity) {
		this.checkQuantity = checkQuantity;
	}
}
