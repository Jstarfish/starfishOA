package cls.pilottery.web.items.form;

import java.io.Serializable;

import cls.pilottery.common.model.BaseEntity;

public class ItemIssueQueryForm extends BaseEntity implements Serializable {

	private static final long serialVersionUID = -1799563824943261330L;

	private String issueCode;
	private String issueDate;
	private String warehouseCode;
	private String sessionOrgCode;         //当前登录用户所属的机构
	
	public String getIssueCode() {
		return issueCode;
	}
	public void setIssueCode(String issueCode) {
		this.issueCode = issueCode == null ? null : issueCode.trim();
	}
	
	public String getIssueDate() {
		return issueDate;
	}
	public void setIssueDate(String issueDate) {
		this.issueDate = issueDate == null ? null : issueDate.trim();
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
