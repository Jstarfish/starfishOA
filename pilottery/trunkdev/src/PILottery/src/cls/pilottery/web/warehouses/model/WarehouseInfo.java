package cls.pilottery.web.warehouses.model;

import java.io.Serializable;
import java.util.Date;

/* 仓库基本信息 */
public class WarehouseInfo implements Serializable {

    private static final long serialVersionUID = 9042243856730474828L;
    
    private String warehouseCode;         //仓库编号（部门+序号）
    
    private String warehouseName;         //仓库名称
    
    private String orgCode;               //所属部门编码
    
    private String orgName;               //所属部门名称（INF_ORGS）
    
    private String address;               //仓库地址
    
    private String phone;                 //联系电话
    
    private Integer directorAdmin;        //负责人
    
    private String directorName;          //负责人姓名（ADM_INFO）
    
    private Integer status;               //状态（1-启用，2-删除，3-盘点中）
    
    private Integer createAdmin;          //创建人
    
    private Date createDate;              //创建时间
    
    private Integer stopAdmin;            //停用人
    
    private Date stopDate;                //停用时间

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

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address == null ? null : address.trim();
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone == null ? null : phone.trim();
    }

    public Integer getDirectorAdmin() {
        return directorAdmin;
    }

    public void setDirectorAdmin(Integer directorAdmin) {
        this.directorAdmin = directorAdmin;
    }

    public String getDirectorName() {
        return directorName;
    }

    public void setDirectorName(String directorName) {
        this.directorName = directorName == null ? null : directorName.trim();
    }

    public Integer getStatus() {
        return status;
    }

    public void setStatus(Integer status) {
        this.status = status;
    }

    public Integer getCreateAdmin() {
        return createAdmin;
    }

    public void setCreateAdmin(Integer createAdmin) {
        this.createAdmin = createAdmin;
    }

    public Date getCreateDate() {
        return createDate;
    }

    public void setCreateDate(Date createDate) {
        this.createDate = createDate;
    }

    public Integer getStopAdmin() {
        return stopAdmin;
    }

    public void setStopAdmin(Integer stopAdmin) {
        this.stopAdmin = stopAdmin;
    }

    public Date getStopDate() {
        return stopDate;
    }

    public void setStopDate(Date stopDate) {
        this.stopDate = stopDate;
    }
}
