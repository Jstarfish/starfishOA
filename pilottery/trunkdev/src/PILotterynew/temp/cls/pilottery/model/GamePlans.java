package cls.pilottery.model;

public class GamePlans {
    private String planCode;

    private String fullName;

    private String shortName;

    private Short publisherCode;

    public String getPlanCode() {
        return planCode;
    }

    public void setPlanCode(String planCode) {
        this.planCode = planCode == null ? null : planCode.trim();
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName == null ? null : fullName.trim();
    }

    public String getShortName() {
        return shortName;
    }

    public void setShortName(String shortName) {
        this.shortName = shortName == null ? null : shortName.trim();
    }

    public Short getPublisherCode() {
        return publisherCode;
    }

    public void setPublisherCode(Short publisherCode) {
        this.publisherCode = publisherCode;
    }
}