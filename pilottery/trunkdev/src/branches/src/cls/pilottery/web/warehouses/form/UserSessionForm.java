package cls.pilottery.web.warehouses.form;

import java.io.Serializable;

import cls.pilottery.common.model.BaseEntity;

public class UserSessionForm extends BaseEntity implements Serializable {

	private static final long serialVersionUID = -4574392437778052741L;

	private String sessionOrgCode;   //当前用户所属的组织机构编码
	private Integer managerId;       //仓库管理员用户编码，不用时为空
	private String warehouseCode;    //仓库编码，不用时为空

	public String getSessionOrgCode() {
		return sessionOrgCode;
	}

	public void setSessionOrgCode(String sessionOrgCode) {
		this.sessionOrgCode = sessionOrgCode == null ? null : sessionOrgCode.trim();
	}
	
	public Integer getManagerId() {
		return managerId;
	}

	public void setManagerId(Integer managerId) {
		this.managerId = managerId;
	}
	
	public String getWarehouseCode() {
		return warehouseCode;
	}

	public void setWarehouseCode(String warehouseCode) {
		this.warehouseCode = warehouseCode == null ? null : warehouseCode.trim();
	}
}
