package cls.pilottery.web.items.form;

import java.io.Serializable;

import cls.pilottery.common.model.BaseEntity;

public class ItemCheckQueryForm extends BaseEntity implements Serializable {

	private static final long serialVersionUID = -6479692355486502520L;

	private String checkCode;
	private String checkName;
	private String checkDate;
	private String warehouseCode;
	private String sessionOrgCode;         //当前登录用户所属的机构
	
	public String getCheckCode() {
		return checkCode;
	}
	public void setCheckCode(String checkCode) {
		this.checkCode = checkCode == null ? null : checkCode.trim();
	}
	
	public String getCheckName() {
		return checkName;
	}
	public void setCheckName(String checkName) {
		this.checkName = checkName == null ? null : checkName.trim();
	}
	
	public String getCheckDate() {
		return checkDate;
	}
	public void setCheckDate(String checkDate) {
		this.checkDate = checkDate == null ? null : checkDate.trim();
	}
	
	public String getWarehouseCode() {
		return warehouseCode;
	}
	public void setWarehouseCode(String warehouseCode) {
		this.warehouseCode = warehouseCode == null ? null : warehouseCode.trim();
	}
	
	public String getSessionOrgCode() {
		return sessionOrgCode;
	}
	public void setSessionOrgCode(String sessionOrgCode) {
		this.sessionOrgCode = sessionOrgCode == null ? null : sessionOrgCode.trim();
	}
}
