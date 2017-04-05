package cls.pilottery.model;

public class ItemIssueDetailKey {
    private String iiNo;

    private Short sequenceNo;

    public String getIiNo() {
        return iiNo;
    }

    public void setIiNo(String iiNo) {
        this.iiNo = iiNo == null ? null : iiNo.trim();
    }

    public Short getSequenceNo() {
        return sequenceNo;
    }

    public void setSequenceNo(Short sequenceNo) {
        this.sequenceNo = sequenceNo;
    }
}