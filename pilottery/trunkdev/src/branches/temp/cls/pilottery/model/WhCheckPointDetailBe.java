package cls.pilottery.model;

public class WhCheckPointDetailBe extends WhCheckPointDetailBeKey {
    private Short validNumber;

    private String planCode;

    private String batchNo;

    private String trunkNo;

    private Integer boxNo;

    private String packageNo;

    private Short packages;

    private Long amount;

    public Short getValidNumber() {
        return validNumber;
    }

    public void setValidNumber(Short validNumber) {
        this.validNumber = validNumber;
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

    public Short getPackages() {
        return packages;
    }

    public void setPackages(Short packages) {
        this.packages = packages;
    }

    public Long getAmount() {
        return amount;
    }

    public void setAmount(Long amount) {
        this.amount = amount;
    }
}