package cls.pilottery.web.items.form;

import java.io.Serializable;

import cls.pilottery.common.model.BaseEntity;

public class NewItemCheckForm extends BaseEntity implements Serializable {

	private static final long serialVersionUID = -2186058198280699301L;

	//--input params
	private String checkName;
	private String warehouseCode;
	private String checkAdmin;
	private String checkItemSet;
	
	//--output params
	private String checkCode;
	
	public String getCheckName() {
		return checkName;
	}
	public void setCheckName(String checkName) {
		this.checkName = checkName == null ? null : checkName.trim();
	}
	
	public String getWarehouseCode() {
		return warehouseCode;
	}
	public void setWarehouseCode(String warehouseCode) {
		this.warehouseCode = warehouseCode == null ? null : warehouseCode.trim();
	}
	
	public String getCheckAdmin() {
		return checkAdmin;
	}
	public void setCheckAdmin(String checkAdmin) {
		this.checkAdmin = checkAdmin == null ? null : checkAdmin.trim();
	}
	
	public String getCheckItemSet() {
		return checkItemSet;
	}
	public void setCheckItemSet(String checkItemSet) {
		this.checkItemSet = checkItemSet == null ? null : checkItemSet.trim();
	}
	
	public String getCheckCode() {
		return checkCode;
	}
	public void setCheckCode(String checkCode) {
		this.checkCode = checkCode == null ? null : checkCode.trim();
	}
}
