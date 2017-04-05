package cls.pilottery.model;

import java.math.BigDecimal;
import java.util.Date;

public class FlowGuiPay {
    private String guiPayNo;

    private String winnername;

    private Short gender;

    private String contact;

    private Short age;

    private String certNo;

    private BigDecimal payAmount;

    private Short rewardLevel;

    private Date payTime;

    private Short payerAdmin;

    private String payerName;

    private String planCode;

    private String batchNo;

    private String trunkNo;

    private Integer boxNo;

    private String packageNo;

    private Integer ticketNo;

    private String securityCode;

    private String identityCode;

    private Short isManual;

    public String getGuiPayNo() {
        return guiPayNo;
    }

    public void setGuiPayNo(String guiPayNo) {
        this.guiPayNo = guiPayNo == null ? null : guiPayNo.trim();
    }

    public String getWinnername() {
        return winnername;
    }

    public void setWinnername(String winnername) {
        this.winnername = winnername == null ? null : winnername.trim();
    }

    public Short getGender() {
        return gender;
    }

    public void setGender(Short gender) {
        this.gender = gender;
    }

    public String getContact() {
        return contact;
    }

    public void setContact(String contact) {
        this.contact = contact == null ? null : contact.trim();
    }

    public Short getAge() {
        return age;
    }

    public void setAge(Short age) {
        this.age = age;
    }

    public String getCertNo() {
        return certNo;
    }

    public void setCertNo(String certNo) {
        this.certNo = certNo == null ? null : certNo.trim();
    }

    public BigDecimal getPayAmount() {
        return payAmount;
    }

    public void setPayAmount(BigDecimal payAmount) {
        this.payAmount = payAmount;
    }

    public Short getRewardLevel() {
        return rewardLevel;
    }

    public void setRewardLevel(Short rewardLevel) {
        this.rewardLevel = rewardLevel;
    }

    public Date getPayTime() {
        return payTime;
    }

    public void setPayTime(Date payTime) {
        this.payTime = payTime;
    }

    public Short getPayerAdmin() {
        return payerAdmin;
    }

    public void setPayerAdmin(Short payerAdmin) {
        this.payerAdmin = payerAdmin;
    }

    public String getPayerName() {
        return payerName;
    }

    public void setPayerName(String payerName) {
        this.payerName = payerName == null ? null : payerName.trim();
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

    public String getTrunkNo() {
        return trunkNo;
    }

    public void setTrunkNo(String trunkNo) {
        this.trunkNo = trunkNo == null ? null : trunkNo.trim();
    }

    public Integer getBoxNo() {
        return boxNo;
    }

    public void setBoxNo(Integer boxNo) {
        this.boxNo = boxNo;
    }

    public String getPackageNo() {
        return packageNo;
    }

    public void setPackageNo(String packageNo) {
        this.packageNo = packageNo == null ? null : packageNo.trim();
    }

    public Integer getTicketNo() {
        return ticketNo;
    }

    public void setTicketNo(Integer ticketNo) {
        this.ticketNo = ticketNo;
    }

    public String getSecurityCode() {
        return securityCode;
    }

    public void setSecurityCode(String securityCode) {
        this.securityCode = securityCode == null ? null : securityCode.trim();
    }

    public String getIdentityCode() {
        return identityCode;
    }

    public void setIdentityCode(String identityCode) {
        this.identityCode = identityCode == null ? null : identityCode.trim();
    }

    public Short getIsManual() {
        return isManual;
    }

    public void setIsManual(Short isManual) {
        this.isManual = isManual;
    }
}