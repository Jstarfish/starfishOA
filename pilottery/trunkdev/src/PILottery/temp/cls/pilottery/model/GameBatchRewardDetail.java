package cls.pilottery.model;

public class GameBatchRewardDetail extends GameBatchRewardDetailKey {
    private String batchNo;

    private Short isPaid;

    public String getBatchNo() {
        return batchNo;
    }

    public void setBatchNo(String batchNo) {
        this.batchNo = batchNo == null ? null : batchNo.trim();
    }

    public Short getIsPaid() {
        return isPaid;
    }

    public void setIsPaid(Short isPaid) {
        this.isPaid = isPaid;
    }
}