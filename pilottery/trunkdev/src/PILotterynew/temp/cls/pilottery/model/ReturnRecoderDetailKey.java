package cls.pilottery.model;

public class ReturnRecoderDetailKey {
    private String returnNo;

    private Short sequenceNo;

    public String getReturnNo() {
        return returnNo;
    }

    public void setReturnNo(String returnNo) {
        this.returnNo = returnNo == null ? null : returnNo.trim();
    }

    public Short getSequenceNo() {
        return sequenceNo;
    }

    public void setSequenceNo(Short sequenceNo) {
        this.sequenceNo = sequenceNo;
    }
}