package cls.pilottery.web.capital.model;

import java.io.Serializable;
import java.util.Date;

import cls.pilottery.common.EnumConfigEN;

public class CapitalRecord implements Serializable {
	private static final long serialVersionUID = 2511592214446857704L;
	private String flowNo;
	private String orgCode;
	private String orgName;
	private Date tradeTime;
	private long amount;
	private long beforeBalance;
	private long afterBalance;
	private int type;
	private String typeValue;
	public String getOrgCode() {
		return orgCode;
	}
	public void setOrgCode(String orgCode) {
		this.orgCode = orgCode;
	}
	public String getOrgName() {
		return orgName;
	}
	public void setOrgName(String orgName) {
		this.orgName = orgName;
	}
	public Date getTradeTime() {
		return tradeTime;
	}
	public void setTradeTime(Date tradeTime) {
		this.tradeTime = tradeTime;
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
		this.typeValue = EnumConfigEN.transFlowType.get(type);
	}
	public String getTypeValue() {
		return typeValue;
	}
	public void setTypeValue(String typeValue) {
		this.typeValue = typeValue;
	}
	public String getFlowNo() {
		return flowNo;
	}
	public void setFlowNo(String flowNo) {
		this.flowNo = flowNo;
	}
	public long getBeforeBalance() {
		return beforeBalance;
	}
	public void setBeforeBalance(long beforeBalance) {
		this.beforeBalance = beforeBalance;
	}
	public long getAfterBalance() {
		return afterBalance;
	}
	public void setAfterBalance(long afterBalance) {
		this.afterBalance = afterBalance;
	}
}
