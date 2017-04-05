package cls.pilottery.model;

import java.math.BigDecimal;
import java.util.Date;

public class FlowPay {
    private String payFlow;

    private String payAgency;

    private String areaCode;

    private Long payComm;

    private Integer payCommRate;

    private String planCode;

    private String batchNo;

    private Short rewardGroup;

    private String trunkNo;

    private Integer boxNo;

    private String packageNo;

    private Integer ticketNo;

    private String securityCode;

    private String identityCode;

    private BigDecimal payAmount;

    private Short rewardLevel;

    private Long lotteryAmount;

    private Date payTime;

    private Short payerAdmin;

    private String payerName;

    public String getPayFlow() {
        return payFlow;
    }

    public void setPayFlow(String payFlow) {
        this.payFlow = payFlow == null ? null : payFlow.trim();
    }

    public String getPayAgency() {
        return payAgency;
    }

    public void setPayAgency(String payAgency) {
        this.payAgency = payAgency == null ? null : payAgency.trim();
    }

    public String getAreaCode() {
        return areaCode;
    }

    public void setAreaCode(String areaCode) {
        this.areaCode = areaCode == null ? null : areaCode.trim();
    }

    public Long getPayComm() {
        return payComm;
    }

    public void setPayComm(Long payComm) {
        this.payComm = payComm;
    }

    public Integer getPayCommRate() {
        return payCommRate;
    }

    public void setPayCommRate(Integer payCommRate) {
        this.payCommRate = payCommRate;
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

    public Short getRewardGroup() {
        return rewardGroup;
    }

    public void setRewardGroup(Short rewardGroup) {
        this.rewardGroup = rewardGroup;
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

    public Long getLotteryAmount() {
        return lotteryAmount;
    }

    public void setLotteryAmount(Long lotteryAmount) {
        this.lotteryAmount = lotteryAmount;
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
}