package cls.pilottery.pos.system.model.mm;

import cls.pilottery.common.EnumConfigEN;

public class MMInventoryCheckTag020507Res implements java.io.Serializable{
	private static final long serialVersionUID = -7587470777458570850L;
	private String tagCode;
	private String status;
	private String statusValue;
	public String getTagCode() {
		return tagCode;
	}
	public void setTagCode(String tagCode) {
		this.tagCode = tagCode;
	}
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
		this.statusValue = EnumConfigEN.mmInventoryCheckStatus.get(Integer.parseInt(status));
	}
	public String getStatusValue() {
		return statusValue;
	}
	public void setStatusValue(String statusValue) {
		this.statusValue = statusValue;
	}
}
