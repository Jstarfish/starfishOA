package cls.pilottery.model;

public class DeliveryOrderDetailKey {
    private String doNo;

    private Short sequenceNo;

    public String getDoNo() {
        return doNo;
    }

    public void setDoNo(String doNo) {
        this.doNo = doNo == null ? null : doNo.trim();
    }

    public Short getSequenceNo() {
        return sequenceNo;
    }

    public void setSequenceNo(Short sequenceNo) {
        this.sequenceNo = sequenceNo;
    }
}