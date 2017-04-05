package cls.pilottery.pos.system.model.mm;

import java.io.Serializable;

public class TagList020505Res implements Serializable {
	private static final long serialVersionUID = -650800724963886626L;
	private String tagNo;
	private long amount;
	public String getTagNo() {
		return tagNo;
	}
	public void setTagNo(String tagNo) {
		this.tagNo = tagNo;
	}
	public long getAmount() {
		return amount;
	}
	public void setAmount(long amount) {
		this.amount = amount;
	}
}
