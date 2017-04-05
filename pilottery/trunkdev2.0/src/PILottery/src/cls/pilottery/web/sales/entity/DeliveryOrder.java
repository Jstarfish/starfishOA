package cls.pilottery.web.sales.entity;

import java.util.Date;
import java.util.List;

import cls.pilottery.common.EnumConfigEN;
import cls.pilottery.common.model.BaseEntity;

public class DeliveryOrder extends BaseEntity{
	private static final long serialVersionUID = -6050818697583691888L;

	/*
	 * 出货单编号
	 */
	private String doNo;   
	/*
	 * 申请人
	 */
    private Short applyAdmin;
    /*
     * 申请人名称
     */
    private String applyAdminName;
    /*
     * 申请时间
     */
    private Date applyDate;
    /*
     * 出货仓库编码
     */
    private String whCode;
    /*
     * 仓库名称
     */
    private String whName;
    /*
     * 仓库所属部门编码
     */
    private String org;
    /*
     * 部门名称
     */
    private String orgName;
    /*
     * 库管员
     */
    private Short managerAdmin;
    /*
     * 出库日期
     */
    private Date outDate;
    /*
     * 状态（1-已提交、2-已撤销、3-已发货、4-已收货，5-处理中）
     */
    private Integer status;
    private String statusValue;
    /*
     * 合计数量
     */
    private Long totalTickets;
    /*
     * 合计金额
     */
    private Long totalAmount;
    /*
     * 提货人ID
     */
    private Short deliveredAdm;
    /*
     * 联系方式
     */
    private String contactPhone;
    
    private String remark;
    
    private String managerAdminName;
    
    private List<DeliveryOrderDetail> deliveryDetail;
    private List<DeliveryOrderRelation> doRelation;

    public String getDoNo() {
        return doNo;
    }

    public void setDoNo(String doNo) {
        this.doNo = doNo == null ? null : doNo.trim();
    }

    public Short getApplyAdmin() {
        return applyAdmin;
    }

    public void setApplyAdmin(Short applyAdmin) {
        this.applyAdmin = applyAdmin;
    }

    public Date getApplyDate() {
        return applyDate;
    }

    public void setApplyDate(Date applyDate) {
        this.applyDate = applyDate;
    }

    public String getWhCode() {
        return whCode;
    }

    public void setWhCode(String whCode) {
        this.whCode = whCode == null ? null : whCode.trim();
    }

    public String getOrg() {
        return org;
    }

    public void setOrg(String org) {
        this.org = org == null ? null : org.trim();
    }

    public Short getManagerAdmin() {
        return managerAdmin;
    }

    public void setManagerAdmin(Short managerAdmin) {
        this.managerAdmin = managerAdmin;
    }

    public Date getOutDate() {
        return outDate;
    }

    public void setOutDate(Date outDate) {
        this.outDate = outDate;
    }

    public Integer getStatus() {
        return status;
    }

    public void setStatus(Integer status) {
    	this.status = status;
		this.statusValue=EnumConfigEN.deliveryOrderStatus.get(status);
    }

	public Long getTotalTickets() {
		return totalTickets;
	}

	public void setTotalTickets(Long totalTickets) {
		this.totalTickets = totalTickets;
	}

	public Long getTotalAmount() {
		return totalAmount;
	}

	public void setTotalAmount(Long totalAmount) {
		this.totalAmount = totalAmount;
	}

	public String getApplyAdminName() {
		return applyAdminName;
	}

	public void setApplyAdminName(String applyAdminName) {
		this.applyAdminName = applyAdminName;
	}

	public String getWhName() {
		return whName;
	}

	public void setWhName(String whName) {
		this.whName = whName;
	}

	public String getOrgName() {
		return orgName;
	}

	public void setOrgName(String orgName) {
		this.orgName = orgName;
	}

	public Short getDeliveredAdm() {
		return deliveredAdm;
	}

	public void setDeliveredAdm(Short deliveredAdm) {
		this.deliveredAdm = deliveredAdm;
	}

	public String getContactPhone() {
		return contactPhone;
	}

	public void setContactPhone(String contactPhone) {
		this.contactPhone = contactPhone;
	}

	public List<DeliveryOrderDetail> getDeliveryDetail() {
		return deliveryDetail;
	}

	public void setDeliveryDetail(List<DeliveryOrderDetail> deliveryDetail) {
		this.deliveryDetail = deliveryDetail;
	}

	public List<DeliveryOrderRelation> getDoRelation() {
		return doRelation;
	}

	public void setDoRelation(List<DeliveryOrderRelation> doRelation) {
		this.doRelation = doRelation;
	}

	public String getStatusValue() {
		return statusValue;
	}

	public void setStatusValue(String statusValue) {
		this.statusValue = statusValue;
	}

	public String getRemark() {
		return remark;
	}

	public void setRemark(String remark) {
		this.remark = remark;
	}

	public String getManagerAdminName() {
		return managerAdminName;
	}

	public void setManagerAdminName(String managerAdminName) {
		this.managerAdminName = managerAdminName;
	}
}