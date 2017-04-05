package cls.pilottery.web.items.form;

import java.io.Serializable;

import cls.pilottery.common.model.BaseEntity;

public class ItemReceiptQueryForm extends BaseEntity implements Serializable {

	private static final long serialVersionUID = -3740670302635352L;

	private String receiptCode;
	private String receiptDate;
	private String warehouseCode;
	private String sessionOrgCode;         //当前登录用户所属的机构
	
	public String getReceiptCode() {
		return receiptCode;
	}
	public void setReceiptCode(String receiptCode) {
		this.receiptCode = receiptCode == null ? null : receiptCode.trim();
	}
	
	public String getReceiptDate() {
		return receiptDate;
	}
	public void setReceiptDate(String receiptDate) {
		this.receiptDate = receiptDate == null ? null : receiptDate.trim();
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
