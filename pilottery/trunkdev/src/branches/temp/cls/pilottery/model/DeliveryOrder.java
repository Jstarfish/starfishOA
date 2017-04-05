package cls.pilottery.model;

import java.math.BigDecimal;
import java.util.Date;

public class DeliveryOrder {
    private String doNo;

    private Short applyAdmin;

    private Date applyDate;

    private String whCode;

    private String org;

    private Short managerAdmin;

    private Date outDate;

    private Short status;

    private Long totalQuantity;

    private BigDecimal totalValue;

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

    public Short getStatus() {
        return status;
    }

    public void setStatus(Short status) {
        this.status = status;
    }

    public Long getTotalQuantity() {
        return totalQuantity;
    }

    public void setTotalQuantity(Long totalQuantity) {
        this.totalQuantity = totalQuantity;
    }

    public BigDecimal getTotalValue() {
        return totalValue;
    }

    public void setTotalValue(BigDecimal totalValue) {
        this.totalValue = totalValue;
    }
}