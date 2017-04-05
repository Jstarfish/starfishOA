package cls.pilottery.web.warehouses.form;

import cls.pilottery.common.model.BaseEntity;

public class WarehouseQueryForm extends BaseEntity {

    private static final long serialVersionUID = 4417592367632015217L;

    private String warehouseCodeQuery;
    private String institutionQuery;
    private String sessionOrgCode;         //当前登录用户所属的机构

	public String getWarehouseCodeQuery() {
        return warehouseCodeQuery;
    }
    
    public void setWarehouseCodeQuery(String warehouseCodeQuery) {
        this.warehouseCodeQuery = warehouseCodeQuery == null ? null : warehouseCodeQuery.trim();
    }
    
    public String getInstitutionQuery() {
        return institutionQuery;
    }
    
    public void setInstitutionQuery(String institutionQuery) {
        this.institutionQuery = institutionQuery == null ? null : institutionQuery.trim();
    }
    
	public String getSessionOrgCode() {
		return sessionOrgCode;
	}

	public void setSessionOrgCode(String sessionOrgCode) {
		this.sessionOrgCode = sessionOrgCode == null ? null : sessionOrgCode.trim();
	}
}
