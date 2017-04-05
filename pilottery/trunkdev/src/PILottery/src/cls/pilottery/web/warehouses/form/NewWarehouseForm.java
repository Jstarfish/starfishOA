package cls.pilottery.web.warehouses.form;

import cls.pilottery.common.model.BaseEntity;

public class NewWarehouseForm extends BaseEntity {

	private static final long serialVersionUID = -8442938590061012768L;
	
	private String institutionCode;
	private String warehouseCode;
	private String warehouseName;
	private String warehouseAddress;
	private String contactPhone;
	private Integer contactPerson;
	private Integer createAdmin;
	private String warehouseManager;
	
	public String getInstitutionCode() {
		return institutionCode;
	}
	
	public void setInstitutionCode(String institutionCode) {
		this.institutionCode = institutionCode == null ? null : institutionCode.trim();
	}
	
	public String getWarehouseCode() {
		return warehouseCode;
	}
	
	public void setWarehouseCode(String warehouseCode) {
		this.warehouseCode = warehouseCode == null ? null : warehouseCode.trim();
	}
	
	public String getWarehouseName() {
		return warehouseName;
	}
	
	public void setWarehouseName(String warehouseName) {
		this.warehouseName = warehouseName == null ? null : warehouseName.trim();
	}
	
	public String getWarehouseAddress() {
		return warehouseAddress;
	}
	
	public void setWarehouseAddress(String warehouseAddress) {
		this.warehouseAddress = warehouseAddress == null ? null : warehouseAddress.trim();
	}
	
	public String getContactPhone() {
		return contactPhone;
	}
	
	public void setContactPhone(String contactPhone) {
		this.contactPhone = contactPhone == null ? null : contactPhone.trim();
	}
	
	public Integer getContactPerson() {
		return contactPerson;
	}
	
	public void setContactPerson(Integer contactPerson) {
		this.contactPerson = contactPerson;
	}
	
	public Integer getCreateAdmin() {
		return createAdmin;
	}

	public void setCreateAdmin(Integer createAdmin) {
		this.createAdmin = createAdmin;
	}
	
	public String getWarehouseManager() {
		return warehouseManager;
	}
	
	public void setWarehouseManager(String warehouseManager) {
		this.warehouseManager = warehouseManager == null ? null : warehouseManager.trim();
	}
}
