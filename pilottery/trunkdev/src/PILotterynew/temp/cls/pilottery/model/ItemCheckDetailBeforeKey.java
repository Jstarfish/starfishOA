package cls.pilottery.model;

public class ItemCheckDetailBeforeKey {
    private String checkNo;

    private Short sequenceNo;

    public String getCheckNo() {
        return checkNo;
    }

    public void setCheckNo(String checkNo) {
        this.checkNo = checkNo == null ? null : checkNo.trim();
    }

    public Short getSequenceNo() {
        return sequenceNo;
    }

    public void setSequenceNo(Short sequenceNo) {
        this.sequenceNo = sequenceNo;
    }
}