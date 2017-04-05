package cls.pilottery.model;

public class WhCheckPointDetailKey {
    private String cpNo;

    private Short sequenceNo;

    public String getCpNo() {
        return cpNo;
    }

    public void setCpNo(String cpNo) {
        this.cpNo = cpNo == null ? null : cpNo.trim();
    }

    public Short getSequenceNo() {
        return sequenceNo;
    }

    public void setSequenceNo(Short sequenceNo) {
        this.sequenceNo = sequenceNo;
    }
}