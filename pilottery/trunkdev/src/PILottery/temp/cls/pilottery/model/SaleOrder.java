package cls.pilottery.model;

import java.util.Date;

public class SaleOrder {
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

    private Short isInstantOrder;

    private Integer applyPackage;

    private Long applyAmount;

    private Long goodsPackage;

    private Long goodsAmount;

    public String getOrderNo() {
        return orderNo;
    }

    public void setOrderNo(String orderNo) {
        this.orderNo = orderNo == null ? null : orderNo.trim();
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
        this.applyAgency = applyAgency == null ? null : applyAgency.trim();
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
        this.sendWarehouse = sendWarehouse == null ? null : sendWarehouse.trim();
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
        this.status = status == null ? null : status.trim();
    }

    public Short getIsInstantOrder() {
        return isInstantOrder;
    }

    public void setIsInstantOrder(Short isInstantOrder) {
        this.isInstantOrder = isInstantOrder;
    }

    public Integer getApplyPackage() {
        return applyPackage;
    }

    public void setApplyPackage(Integer applyPackage) {
        this.applyPackage = applyPackage;
    }

    public Long getApplyAmount() {
        return applyAmount;
    }

    public void setApplyAmount(Long applyAmount) {
        this.applyAmount = applyAmount;
    }

    public Long getGoodsPackage() {
        return goodsPackage;
    }

    public void setGoodsPackage(Long goodsPackage) {
        this.goodsPackage = goodsPackage;
    }

    public Long getGoodsAmount() {
        return goodsAmount;
    }

    public void setGoodsAmount(Long goodsAmount) {
        this.goodsAmount = goodsAmount;
    }
}