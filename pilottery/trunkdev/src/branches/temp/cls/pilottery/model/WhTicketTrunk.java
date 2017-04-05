package cls.pilottery.model;

import java.util.Date;

public class WhTicketTrunk extends WhTicketTrunkKey {
    private Short rewardGroup;

    private String packageNoStart;

    private String packageNoEnd;

    private Short isFull;

    private Short status;

    private String currentWarehouse;

    private String lastWarehouse;

    private Date createDate;

    private Short createAdmin;

    private Short changeAdmin;

    private Date changeDate;

    public Short getRewardGroup() {
        return rewardGroup;
    }

    public void setRewardGroup(Short rewardGroup) {
        this.rewardGroup = rewardGroup;
    }

    public String getPackageNoStart() {
        return packageNoStart;
    }

    public void setPackageNoStart(String packageNoStart) {
        this.packageNoStart = packageNoStart == null ? null : packageNoStart.trim();
    }

    public String getPackageNoEnd() {
        return packageNoEnd;
    }

    public void setPackageNoEnd(String packageNoEnd) {
        this.packageNoEnd = packageNoEnd == null ? null : packageNoEnd.trim();
    }

    public Short getIsFull() {
        return isFull;
    }

    public void setIsFull(Short isFull) {
        this.isFull = isFull;
    }

    public Short getStatus() {
        return status;
    }

    public void setStatus(Short status) {
        this.status = status;
    }

    public String getCurrentWarehouse() {
        return currentWarehouse;
    }

    public void setCurrentWarehouse(String currentWarehouse) {
        this.currentWarehouse = currentWarehouse == null ? null : currentWarehouse.trim();
    }

    public String getLastWarehouse() {
        return lastWarehouse;
    }

    public void setLastWarehouse(String lastWarehouse) {
        this.lastWarehouse = lastWarehouse == null ? null : lastWarehouse.trim();
    }

    public Date getCreateDate() {
        return createDate;
    }

    public void setCreateDate(Date createDate) {
        this.createDate = createDate;
    }

    public Short getCreateAdmin() {
        return createAdmin;
    }

    public void setCreateAdmin(Short createAdmin) {
        this.createAdmin = createAdmin;
    }

    public Short getChangeAdmin() {
        return changeAdmin;
    }

    public void setChangeAdmin(Short changeAdmin) {
        this.changeAdmin = changeAdmin;
    }

    public Date getChangeDate() {
        return changeDate;
    }

    public void setChangeDate(Date changeDate) {
        this.changeDate = changeDate;
    }
}