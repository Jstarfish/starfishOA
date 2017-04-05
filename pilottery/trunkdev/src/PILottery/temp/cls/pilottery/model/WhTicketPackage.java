package cls.pilottery.model;

import java.util.Date;

public class WhTicketPackage extends WhTicketPackageKey {
    private Short rewardGroup;

    private String ticketNoStart;

    private String ticketNoEnd;

    private Long ticketsEveryPack;

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

    public String getTicketNoStart() {
        return ticketNoStart;
    }

    public void setTicketNoStart(String ticketNoStart) {
        this.ticketNoStart = ticketNoStart == null ? null : ticketNoStart.trim();
    }

    public String getTicketNoEnd() {
        return ticketNoEnd;
    }

    public void setTicketNoEnd(String ticketNoEnd) {
        this.ticketNoEnd = ticketNoEnd == null ? null : ticketNoEnd.trim();
    }

    public Long getTicketsEveryPack() {
        return ticketsEveryPack;
    }

    public void setTicketsEveryPack(Long ticketsEveryPack) {
        this.ticketsEveryPack = ticketsEveryPack;
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