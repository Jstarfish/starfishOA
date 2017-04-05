package cls.pilottery.web.items.entity;

import java.io.Serializable;

//2.1.10.10
//与数据库表字段一一对应，不在系统中使用
public class ItemDamage implements Serializable {

	private static final long serialVersionUID = 3612123803620467118L;

	private String idNo;             //损毁登记编号（SH12345678）//ID_NO//CHAR(10)//非空
	private String damageDate;       //损毁日期//DAMAGE_DATE//DATE//非空
	private String itemCode;         //物品编码（IT123456）//ITEM_CODE//CHAR(8)//非空
	private Integer quantity;        //损毁数量//QUANTITY//NUMBER(10)//非空
	private Integer checkAdmin;      //操作人//CHECK_ADMIN//NUMBER(4)//非空
	private String remark;           //备注//REMARK//VARCHAR2(2000)
	
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
		this.damageDate = damageDate == null ? null : damageDate.trim();
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
	
	public Integer getCheckAdmin() {
		return checkAdmin;
	}
	public void setCheckAdmin(Integer checkAdmin) {
		this.checkAdmin = checkAdmin;
	}
	
	public String getRemark() {
		return remark;
	}
	public void setRemark(String remark) {
		this.remark = remark == null ? null : remark.trim();
	}
}
