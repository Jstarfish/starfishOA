package cls.pilottery.model;

public class ReturnRecoderDetail extends ReturnRecoderDetailKey {
    private String planCode;

    private Short packages;

    private Long amount;

    public String getPlanCode() {
        return planCode;
    }

    public void setPlanCode(String planCode) {
        this.planCode = planCode == null ? null : planCode.trim();
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