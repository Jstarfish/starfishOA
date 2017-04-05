package cls.pilottery.web.items.model;

import java.io.Serializable;

public class ItemCheck implements Serializable {

	private static final long serialVersionUID = -5887972827789182967L;

	private String checkNo;             //盘点编号（II12345678）//CHECK_NO//CHAR(10)//非空
	private String checkName;           //盘点名称//CHECK_NAME//VARCHAR2(500)
	private String checkDate;           //盘点日期//CHECK_DATE//DATE
	private Integer checkAdmin;         //操作人//CHECK_ADMIN//NUMBER(4)//非空
	private String checkAdminName;      //操作人姓名（外表字段）
	private String checkWarehouse;      //盘点仓库//CHECK_WAREHOUSE//CHAR(4)
	private String checkWarehouseName;  //盘点仓库名称（外表字段）
	private Integer status;             //状态（1-未完成，2-已完成）//STATUS//NUMBER(1)//非空
	
	public String getCheckNo() {
		return checkNo;
	}
	public void setCheckNo(String checkNo) {
		this.checkNo = checkNo == null ? null : checkNo.trim();
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
	
	public Integer getCheckAdmin() {
		return checkAdmin;
	}
	public void setCheckAdmin(Integer checkAdmin) {
		this.checkAdmin = checkAdmin;
	}
	
	public String getCheckAdminName() {
		return checkAdminName;
	}
	public void setCheckAdminName(String checkAdminName) {
		this.checkAdminName = checkAdminName == null ? null : checkAdminName.trim();
	}
	
	public String getCheckWarehouse() {
		return checkWarehouse;
	}
	public void setCheckWarehouse(String checkWarehouse) {
		this.checkWarehouse = checkWarehouse == null ? null : checkWarehouse.trim();
	}
	
	public String getCheckWarehouseName() {
		return checkWarehouseName;
	}
	public void setCheckWarehouseName(String checkWarehouseName) {
		this.checkWarehouseName = checkWarehouseName == null ? null : checkWarehouseName.trim();
	}
	
	public Integer getStatus() {
		return status;
	}
	public void setStatus(Integer status) {
		this.status = status;
	}
}
