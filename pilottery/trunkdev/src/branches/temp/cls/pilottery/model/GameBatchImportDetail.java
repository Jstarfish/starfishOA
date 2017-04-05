package cls.pilottery.model;

public class GameBatchImportDetail {
    private String importNo;

    private String planCode;

    private String batchNo;

    private String lotteryType;

    private String lotteryName;

    private Long boxesEveryTrunk;

    private Long trunksEveryGroup;

    private Long packsEveryTrunk;

    private Long ticketsEveryPack;

    private Long ticketsEveryGroup;

    private Long firstRewardGroupNo;

    private Long ticketsEveryBatch;

    private Short status;

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

    public String getLotteryType() {
        return lotteryType;
    }

    public void setLotteryType(String lotteryType) {
        this.lotteryType = lotteryType == null ? null : lotteryType.trim();
    }

    public String getLotteryName() {
        return lotteryName;
    }

    public void setLotteryName(String lotteryName) {
        this.lotteryName = lotteryName == null ? null : lotteryName.trim();
    }

    public Long getBoxesEveryTrunk() {
        return boxesEveryTrunk;
    }

    public void setBoxesEveryTrunk(Long boxesEveryTrunk) {
        this.boxesEveryTrunk = boxesEveryTrunk;
    }

    public Long getTrunksEveryGroup() {
        return trunksEveryGroup;
    }

    public void setTrunksEveryGroup(Long trunksEveryGroup) {
        this.trunksEveryGroup = trunksEveryGroup;
    }

    public Long getPacksEveryTrunk() {
        return packsEveryTrunk;
    }

    public void setPacksEveryTrunk(Long packsEveryTrunk) {
        this.packsEveryTrunk = packsEveryTrunk;
    }

    public Long getTicketsEveryPack() {
        return ticketsEveryPack;
    }

    public void setTicketsEveryPack(Long ticketsEveryPack) {
        this.ticketsEveryPack = ticketsEveryPack;
    }

    public Long getTicketsEveryGroup() {
        return ticketsEveryGroup;
    }

    public void setTicketsEveryGroup(Long ticketsEveryGroup) {
        this.ticketsEveryGroup = ticketsEveryGroup;
    }

    public Long getFirstRewardGroupNo() {
        return firstRewardGroupNo;
    }

    public void setFirstRewardGroupNo(Long firstRewardGroupNo) {
        this.firstRewardGroupNo = firstRewardGroupNo;
    }

    public Long getTicketsEveryBatch() {
        return ticketsEveryBatch;
    }

    public void setTicketsEveryBatch(Long ticketsEveryBatch) {
        this.ticketsEveryBatch = ticketsEveryBatch;
    }

    public Short getStatus() {
        return status;
    }

    public void setStatus(Short status) {
        this.status = status;
    }
}