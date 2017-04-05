package cls.pilottery.model;

import java.math.BigDecimal;
import java.util.Date;

public class WhGoodsReceipt {
    private String sgrNo;

    private Short createAdmin;

    private Date createDate;

    private BigDecimal receiptAmount;

    private Long receiptTickets;

    private BigDecimal actReceiptAmount;

    private Long actReceiptTickets;

    private Short planCode;

    private String refNo;

    private Short status;

    private String carrier;

    private Date carryDate;

    private String carrierContact;

    private String sendOrg;

    private String sendWh;

    private Short sendManager;

    private Date sendDate;

    public String getSgrNo() {
        return sgrNo;
    }

    public void setSgrNo(String sgrNo) {
        this.sgrNo = sgrNo == null ? null : sgrNo.trim();
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

    public BigDecimal getReceiptAmount() {
        return receiptAmount;
    }

    public void setReceiptAmount(BigDecimal receiptAmount) {
        this.receiptAmount = receiptAmount;
    }

    public Long getReceiptTickets() {
        return receiptTickets;
    }

    public void setReceiptTickets(Long receiptTickets) {
        this.receiptTickets = receiptTickets;
    }

    public BigDecimal getActReceiptAmount() {
        return actReceiptAmount;
    }

    public void setActReceiptAmount(BigDecimal actReceiptAmount) {
        this.actReceiptAmount = actReceiptAmount;
    }

    public Long getActReceiptTickets() {
        return actReceiptTickets;
    }

    public void setActReceiptTickets(Long actReceiptTickets) {
        this.actReceiptTickets = actReceiptTickets;
    }

    public Short getPlanCode() {
        return planCode;
    }

    public void setPlanCode(Short planCode) {
        this.planCode = planCode;
    }

    public String getRefNo() {
        return refNo;
    }

    public void setRefNo(String refNo) {
        this.refNo = refNo == null ? null : refNo.trim();
    }

    public Short getStatus() {
        return status;
    }

    public void setStatus(Short status) {
        this.status = status;
    }

    public String getCarrier() {
        return carrier;
    }

    public void setCarrier(String carrier) {
        this.carrier = carrier == null ? null : carrier.trim();
    }

    public Date getCarryDate() {
        return carryDate;
    }

    public void setCarryDate(Date carryDate) {
        this.carryDate = carryDate;
    }

    public String getCarrierContact() {
        return carrierContact;
    }

    public void setCarrierContact(String carrierContact) {
        this.carrierContact = carrierContact == null ? null : carrierContact.trim();
    }

    public String getSendOrg() {
        return sendOrg;
    }

    public void setSendOrg(String sendOrg) {
        this.sendOrg = sendOrg == null ? null : sendOrg.trim();
    }

    public String getSendWh() {
        return sendWh;
    }

    public void setSendWh(String sendWh) {
        this.sendWh = sendWh == null ? null : sendWh.trim();
    }

    public Short getSendManager() {
        return sendManager;
    }

    public void setSendManager(Short sendManager) {
        this.sendManager = sendManager;
    }

    public Date getSendDate() {
        return sendDate;
    }

    public void setSendDate(Date sendDate) {
        this.sendDate = sendDate;
    }
}