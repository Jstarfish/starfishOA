package cls.pilottery.pos.system.model.wh;

import java.io.Serializable;

import cls.pilottery.common.EnumConfigEN;

public class InstoreRecord070001Res implements Serializable {
	private static final long serialVersionUID = -7127639146682507455L;
	private String sgrNO;
	private String time;
	private long amount;
	private String type;
	private String sendOrg;
	private int status;
	public String getTime() {
		return time;
	}
	public void setTime(String time) {
		this.time = time;
	}
	public long getAmount() {
		return amount;
	}
	public void setAmount(long amount) {
		this.amount = amount;
	}
	public String getType() {
		return type;
	}
	public void setType(String type) {
		this.type = EnumConfigEN.goodsReceiptType.get(Integer.parseInt(type));
	}
	public String getSendOrg() {
		return sendOrg;
	}
	public void setSendOrg(String sendOrg) {
		this.sendOrg = sendOrg;
	}
	public int getStatus() {
		return status;
	}
	public void setStatus(int status) {
		this.status = status;
	}
	public String getSgrNO() {
		return sgrNO;
	}
	public void setSgrNO(String sgrNO) {
		this.sgrNO = sgrNO;
	}
}
