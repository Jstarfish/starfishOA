package cls.pilottery.model;

public class GameBatchRewardDetailKey {
    private String importNo;

    private String planCode;

    private String safeCode;

    public String getImportNo() {
        return importNo;
    }

    public void setImportNo(String importNo) {
        this.importNo = importNo == null ? null : importNo.trim();
    }

    public String getPlanCode() {
        return planCode;
    }

    public void setPlanCode(String planCode) {
        this.planCode = planCode == null ? null : planCode.trim();
    }

    public String getSafeCode() {
        return safeCode;
    }

    public void setSafeCode(String safeCode) {
        this.safeCode = safeCode == null ? null : safeCode.trim();
    }
}