package cls.pilottery.model;

import java.util.Date;

public class GameBatchImport {
    private String importNo;

    private String planCode;

    private String batchNo;

    private String packageFile;

    private String rewardMapFile;

    private String rewardDetailFile;

    private Date startDate;

    private Date endDate;

    private Short importAdmin;

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

    public String getBatchNo() {
        return batchNo;
    }

    public void setBatchNo(String batchNo) {
        this.batchNo = batchNo == null ? null : batchNo.trim();
    }

    public String getPackageFile() {
        return packageFile;
    }

    public void setPackageFile(String packageFile) {
        this.packageFile = packageFile == null ? null : packageFile.trim();
    }

    public String getRewardMapFile() {
        return rewardMapFile;
    }

    public void setRewardMapFile(String rewardMapFile) {
        this.rewardMapFile = rewardMapFile == null ? null : rewardMapFile.trim();
    }

    public String getRewardDetailFile() {
        return rewardDetailFile;
    }

    public void setRewardDetailFile(String rewardDetailFile) {
        this.rewardDetailFile = rewardDetailFile == null ? null : rewardDetailFile.trim();
    }

    public Date getStartDate() {
        return startDate;
    }

    public void setStartDate(Date startDate) {
        this.startDate = startDate;
    }

    public Date getEndDate() {
        return endDate;
    }

    public void setEndDate(Date endDate) {
        this.endDate = endDate;
    }

    public Short getImportAdmin() {
        return importAdmin;
    }

    public void setImportAdmin(Short importAdmin) {
        this.importAdmin = importAdmin;
    }
}