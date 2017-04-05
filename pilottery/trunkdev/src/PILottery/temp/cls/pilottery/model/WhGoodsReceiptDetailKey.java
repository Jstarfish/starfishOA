package cls.pilottery.model;

public class WhGoodsReceiptDetailKey {
    private String sgrNo;

    private Short sequenceNo;

    public String getSgrNo() {
        return sgrNo;
    }

    public void setSgrNo(String sgrNo) {
        this.sgrNo = sgrNo == null ? null : sgrNo.trim();
    }

    public Short getSequenceNo() {
        return sequenceNo;
    }

    public void setSequenceNo(Short sequenceNo) {
        this.sequenceNo = sequenceNo;
    }
}