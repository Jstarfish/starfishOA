package cls.pilottery.web.sales.model;

import java.io.Serializable;

public class OrgAccountFlowModel implements Serializable {
	private static final long serialVersionUID = 6025905153105101156L;
	private String orgCode;
	private String refNo;
	private String accountNo;
	private long changeAmount;
	private long frozen;
	private long beforeAmount;
	private long afterAmount;
	private long beforeFrozen;
	private long afterFrozen;
	public String getOrgCode() {
		return orgCode;
	}
	public void setOrgCode(String orgCode) {
		this.orgCode = orgCode;
	}
	public String getRefNo() {
		return refNo;
	}
	public void setRefNo(String refNo) {
		this.refNo = refNo;
	}
	public String getAccountNo() {
		return accountNo;
	}
	public void setAccountNo(String accountNo) {
		this.accountNo = accountNo;
	}
	public long getChangeAmount() {
		return changeAmount;
	}
	public void setChangeAmount(long changeAmount) {
		this.changeAmount = changeAmount;
	}
	public long getFrozen() {
		return frozen;
	}
	public void setFrozen(long frozen) {
		this.frozen = frozen;
	}
	public long getBeforeAmount() {
		return beforeAmount;
	}
	public void setBeforeAmount(long beforeAmount) {
		this.beforeAmount = beforeAmount;
	}
	public long getAfterAmount() {
		return afterAmount;
	}
	public void setAfterAmount(long afterAmount) {
		this.afterAmount = afterAmount;
	}
	public long getBeforeFrozen() {
		return beforeFrozen;
	}
	public void setBeforeFrozen(long beforeFrozen) {
		this.beforeFrozen = beforeFrozen;
	}
	public long getAfterFrozen() {
		return afterFrozen;
	}
	public void setAfterFrozen(long afterFrozen) {
		this.afterFrozen = afterFrozen;
	}
}
