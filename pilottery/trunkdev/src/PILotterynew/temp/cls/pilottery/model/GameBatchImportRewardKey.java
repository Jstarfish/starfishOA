package cls.pilottery.model;

public class GameBatchImportRewardKey {
    private String importNo;

    private Short rewardNo;

    public String getImportNo() {
        return importNo;
    }

    public void setImportNo(String importNo) {
        this.importNo = importNo == null ? null : importNo.trim();
    }

    public Short getRewardNo() {
        return rewardNo;
    }

    public void setRewardNo(Short rewardNo) {
        this.rewardNo = rewardNo;
    }
}