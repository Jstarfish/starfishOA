package cls.pilottery.web.items.form;

import java.io.Serializable;

import cls.pilottery.common.model.BaseEntity;

public class ItemDamageQueryForm extends BaseEntity implements Serializable {

	private static final long serialVersionUID = 7059736741024696773L;

	private String itemCode;
	private String itemName;
	private String damageDate;
	private String sessionOrgCode;
	
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
	
	public String getDamageDate() {
		return damageDate;
	}
	public void setDamageDate(String damageDate) {
		this.damageDate = damageDate == null ? null : damageDate.trim();
	}
	
	public String getSessionOrgCode() {
		return sessionOrgCode;
	}
	public void setSessionOrgCode(String sessionOrgCode) {
		this.sessionOrgCode = sessionOrgCode == null ? null : sessionOrgCode.trim();
	}
}
