package cls.pilottery.web.sales.entity;

import java.io.Serializable;
import java.util.Date;
import java.util.List;

import cls.pilottery.common.EnumConfigEN;

public class PurchaseOrder implements Serializable {
	private static final long serialVersionUID = -1665927397349508488L;

	private String orderNo;

    private Short applyAdmin;

    private Date applyDate;

    private String applyAgency;

    private Short senderAdmin;

    private String sendWarehouse;

    private Date sendDate;

    private Short carrierAdmin;

    private Date carryDate;

    private String status;
    
    private String statusValue;

    private Short isInstantOrder;

    private Integer applyTickets;

    private Long applyAmount;

    private Long goodsTickets;

    private Long goodsAmount;
    
    private String applyName;
    
    private String applyContact;
    
    private String remark;
    
    private List<PurchaseOrderDetail> orderDetail;

	public String getOrderNo() {
		return orderNo;
	}

	public void setOrderNo(String orderNo) {
		this.orderNo = orderNo;
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

	public String getApplyAgency() {
		return applyAgency;
	}

	public void setApplyAgency(String applyAgency) {
		this.applyAgency = applyAgency;
	}

	public Short getSenderAdmin() {
		return senderAdmin;
	}

	public void setSenderAdmin(Short senderAdmin) {
		this.senderAdmin = senderAdmin;
	}

	public String getSendWarehouse() {
		return sendWarehouse;
	}

	public void setSendWarehouse(String sendWarehouse) {
		this.sendWarehouse = sendWarehouse;
	}

	public Date getSendDate() {
		return sendDate;
	}

	public void setSendDate(Date sendDate) {
		this.sendDate = sendDate;
	}

	public Short getCarrierAdmin() {
		return carrierAdmin;
	}

	public void setCarrierAdmin(Short carrierAdmin) {
		this.carrierAdmin = carrierAdmin;
	}

	public Date getCarryDate() {
		return carryDate;
	}

	public void setCarryDate(Date carryDate) {
		this.carryDate = carryDate;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
		this.statusValue=EnumConfigEN.purchaseOrderStatus.get(Integer.parseInt(status));
	}

	public String getStatusValue() {
		return statusValue;
	}

	public void setStatusValue(String statusValue) {
		this.statusValue = statusValue;
	}

	public Short getIsInstantOrder() {
		return isInstantOrder;
	}

	public void setIsInstantOrder(Short isInstantOrder) {
		this.isInstantOrder = isInstantOrder;
	}

	public Long getApplyAmount() {
		return applyAmount;
	}

	public Integer getApplyTickets() {
		return applyTickets;
	}

	public void setApplyTickets(Integer applyTickets) {
		this.applyTickets = applyTickets;
	}

	public Long getGoodsTickets() {
		return goodsTickets;
	}

	public void setGoodsTickets(Long goodsTickets) {
		this.goodsTickets = goodsTickets;
	}

	public void setApplyAmount(Long applyAmount) {
		this.applyAmount = applyAmount;
	}

	public Long getGoodsAmount() {
		return goodsAmount;
	}

	public void setGoodsAmount(Long goodsAmount) {
		this.goodsAmount = goodsAmount;
	}

	public String getApplyName() {
		return applyName;
	}

	public void setApplyName(String applyName) {
		this.applyName = applyName;
	}

	public List<PurchaseOrderDetail> getOrderDetail() {
		return orderDetail;
	}

	public void setOrderDetail(List<PurchaseOrderDetail> orderDetail) {
		this.orderDetail = orderDetail;
	}

	public String getApplyContact() {
		return applyContact;
	}

	public void setApplyContact(String applyContact) {
		this.applyContact = applyContact;
	}

	public String getRemark() {
		return remark;
	}

	public void setRemark(String remark) {
		this.remark = remark;
	}
}
