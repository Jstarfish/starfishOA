package cls.pilottery.model;

public class GameBatchImportReward extends GameBatchImportRewardKey {
    private String planCode;

    private String batchNo;

    private String fastIdentityCode;

    private Long singleRewardAmount;

    private Long counts;

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

    public String getFastIdentityCode() {
        return fastIdentityCode;
    }

    public void setFastIdentityCode(String fastIdentityCode) {
        this.fastIdentityCode = fastIdentityCode == null ? null : fastIdentityCode.trim();
    }

    public Long getSingleRewardAmount() {
        return singleRewardAmount;
    }

    public void setSingleRewardAmount(Long singleRewardAmount) {
        this.singleRewardAmount = singleRewardAmount;
    }

    public Long getCounts() {
        return counts;
    }

    public void setCounts(Long counts) {
        this.counts = counts;
    }
}