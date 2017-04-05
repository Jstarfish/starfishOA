package cls.pilottery.web.items.form;

import java.io.Serializable;

import cls.pilottery.common.model.BaseEntity;

public class ItemQuantityQueryForm extends BaseEntity implements Serializable {

	private static final long serialVersionUID = -1750795177971427780L;

	private String warehouseCode;
	private String itemCode;
	private String sessionOrgCode;         //当前登录用户所属的机构	
	
	public String getWarehouseCode() {
		return warehouseCode;
	}
	public void setWarehouseCode(String warehouseCode) {
		this.warehouseCode = warehouseCode == null ? null : warehouseCode.trim();
	}
	
	public String getItemCode() {
		return itemCode;
	}
	public void setItemCode(String itemCode) {
		this.itemCode = itemCode == null ? null : itemCode.trim();
	}
	
	public String getSessionOrgCode() {
		return sessionOrgCode;
	}
	public void setSessionOrgCode(String sessionOrgCode) {
		this.sessionOrgCode = sessionOrgCode == null ? null : sessionOrgCode.trim();
	}
}
