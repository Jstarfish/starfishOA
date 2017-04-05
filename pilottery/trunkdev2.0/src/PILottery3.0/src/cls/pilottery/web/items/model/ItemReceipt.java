package cls.pilottery.web.items.model;

import java.io.Serializable;

public class ItemReceipt implements Serializable {

	private static final long serialVersionUID = -8208114117173885737L;

    private String irNo;               //入库单编号（IR12345678）//非空//主键
    private Integer createAdmin;       //建立人
    private String createAdminName;    //建立人名称（外表字段）
    private String receiveOrg;         //入库仓库所属单位
    private String receiveOrgName;     //入库仓库所属单位名称（外表字段）
	private String receiveWh;          //入库仓库
    private String receiveWhName;      //入库仓库名称（外表字段）
    private String receiveDate;        //入库时间
    private String remark;             //备注

	public String getIrNo() {
        return irNo;
    }

    public void setIrNo(String irNo) {
        this.irNo = irNo == null ? null : irNo.trim();
    }

    public Integer getCreateAdmin() {
        return createAdmin;
    }

    public void setCreateAdmin(Integer createAdmin) {
        this.createAdmin = createAdmin;
    }
    
    public String getCreateAdminName() {
    	return createAdminName;
    }
    
    public void setCreateAdminName(String createAdminName) {
    	this.createAdminName = createAdminName == null ? null : createAdminName.trim();
    }

    public String getReceiveOrg() {
        return receiveOrg;
    }

    public void setReceiveOrg(String receiveOrg) {
        this.receiveOrg = receiveOrg == null ? null : receiveOrg.trim();
    }
    
    public String getReceiveOrgName() {
		return receiveOrgName;
	}

	public void setReceiveOrgName(String receiveOrgName) {
		this.receiveOrgName = receiveOrgName == null ? null : receiveOrgName.trim();
	}

    public String getReceiveWh() {
        return receiveWh;
    }

    public void setReceiveWh(String receiveWh) {
        this.receiveWh = receiveWh == null ? null : receiveWh.trim();
    }
    
	public String getReceiveWhName() {
		return receiveWhName;
	}

	public void setReceiveWhName(String receiveWhName) {
		this.receiveWhName = receiveWhName == null ? null : receiveWhName.trim();
	}

    public String getReceiveDate() {
        return receiveDate;
    }

    public void setReceiveDate(String receiveDate) {
        this.receiveDate = receiveDate;
    }
    
    public String getRemark() {
		return remark;
	}

	public void setRemark(String remark) {
		this.remark = remark == null ? null : remark.trim();
	}
}
