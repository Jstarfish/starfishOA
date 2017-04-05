package cls.pilottery.web.warehouses.model;

import java.io.Serializable;
import java.util.Date;

/* 仓库管理员信息 */
public class WarehouseManager implements Serializable {

    private static final long serialVersionUID = -8471186713620255306L;

    private String warehouseCode;         //仓库编号
    
    private String warehouseName;         //仓库名称
    
    private String orgCode;               //所属部门编码
    
    private String orgName;               //所属部门名称
    
    private Integer managerID;            //管理员ID
    
    private String managerName;           //管理员名称
    
    private String userName;              //登录名称
    
    private String phone;                 //联系电话
    
    private Integer isValid;              //是否有效（1-有效，0-无效）
    
    private Date startTime;               //生效时间
    
    private Date endTime;                 //停用时间

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

    public String getOrgCode() {
        return orgCode;
    }

    public void setOrgCode(String orgCode) {
        this.orgCode = orgCode == null ? null : orgCode.trim();
    }
    
	public String getOrgName() {
		return orgName;
	}

	public void setOrgName(String orgName) {
		this.orgName = orgName == null ? null : orgName.trim();
	}

    public Integer getManagerID() {
        return managerID;
    }

    public void setManagerID(Integer managerID) {
        this.managerID = managerID;
    }
    
	public String getManagerName() {
		return managerName;
	}

	public void setManagerName(String managerName) {
		this.managerName = managerName == null ? null : managerName.trim();
	}

	public String getUserName() {
		return userName;
	}

	public void setUserName(String userName) {
		this.userName = userName == null ? null : userName.trim();
	}

	public String getPhone() {
		return phone;
	}

	public void setPhone(String phone) {
		this.phone = phone == null ? null : phone.trim();
	}

    public Integer getIsValid() {
        return isValid;
    }

    public void setIsValid(Integer isValid) {
        this.isValid = isValid;
    }

    public Date getStartTime() {
        return startTime;
    }

    public void setStartTime(Date startTime) {
        this.startTime = startTime;
    }

    public Date getEndTime() {
        return endTime;
    }

    public void setEndTime(Date endTime) {
        this.endTime = endTime;
    }
}
