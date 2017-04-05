package cls.pilottery.model;

import java.util.Date;

public class WhBatchEnd {
    private String beNo;

    private String planCode;

    private String batchNo;

    private Integer tickets;

    private Integer saleAmount;

    private Integer payAmount;

    private Integer inventoryTickets;

    private Short createAdmin;

    private Date createDate;

    public String getBeNo() {
        return beNo;
    }

    public void setBeNo(String beNo) {
        this.beNo = beNo == null ? null : beNo.trim();
    }

    public String getPlanCode() {
        return planCode;
    }

    public void setPlanCode(String planCode) {
        this.planCode = planCode == null ? null : planCode.trim();
    }

    public String getBatchNo() {
        return batchNo;
    }

    public void setBatchNo(String batchNo) {
        this.batchNo = batchNo == null ? null : batchNo.trim();
    }

    public Integer getTickets() {
        return tickets;
    }

    public void setTickets(Integer tickets) {
        this.tickets = tickets;
    }

    public Integer getSaleAmount() {
        return saleAmount;
    }

    public void setSaleAmount(Integer saleAmount) {
        this.saleAmount = saleAmount;
    }

    public Integer getPayAmount() {
        return payAmount;
    }

    public void setPayAmount(Integer payAmount) {
        this.payAmount = payAmount;
    }

    public Integer getInventoryTickets() {
        return inventoryTickets;
    }

    public void setInventoryTickets(Integer inventoryTickets) {
        this.inventoryTickets = inventoryTickets;
    }

    public Short getCreateAdmin() {
        return createAdmin;
    }

    public void setCreateAdmin(Short createAdmin) {
        this.createAdmin = createAdmin;
    }

    public Date getCreateDate() {
        return createDate;
    }

    public void setCreateDate(Date createDate) {
        this.createDate = createDate;
    }
}