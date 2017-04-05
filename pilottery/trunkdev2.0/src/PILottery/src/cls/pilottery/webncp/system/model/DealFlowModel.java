package cls.pilottery.webncp.system.model;

import java.io.Serializable;

import org.springframework.data.annotation.Transient;

import cls.pilottery.common.EnumConfigEN;

public class DealFlowModel implements Serializable {
	private static final long serialVersionUID = -28618941934245355L;
	private String dealTime;
	@Transient
	private int type;	//交易类型的KEY
	private String dealType; 	//交易类型的值
	private long amount;
	public String getDealTime() {
		return dealTime;
	}
	public void setDealTime(String dealTime) {
		this.dealTime = dealTime;
	}
	public String getDealType() {
		return dealType;
	}
	public void setDealType(String dealType) {
		this.dealType = dealType;
	}
	public long getAmount() {
		return amount;
	}
	public void setAmount(long amount) {
		this.amount = amount;
	}
	public int getType() {
		return type;
	}
	public void setType(int type) {
		this.type = type;
		this.dealType = EnumConfigEN.transFlowType.get(type);
	}
}
