package cls.pilottery.model;

public class WhTicketBoxKey {
    private String planCode;

    private String batchNo;

    private String trunkNo;

    private Integer boxNo;

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
}