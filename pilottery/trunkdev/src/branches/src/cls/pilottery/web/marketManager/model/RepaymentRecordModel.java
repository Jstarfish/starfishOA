package cls.pilottery.web.marketManager.model;

import java.io.Serializable;
import java.util.Date;

public class RepaymentRecordModel implements Serializable {
	private static final long serialVersionUID = 1544980214119994216L;
	private long amount;
	private Date repayDate;
	private long afterBalance;
	public long getAmount() {
		return amount;
	}
	public void setAmount(long amount) {
		this.amount = amount;
	}
	public Date getRepayDate() {
		return repayDate;
	}
	public void setRepayDate(Date repayDate) {
		this.repayDate = repayDate;
	}
	public long getAfterBalance() {
		return afterBalance;
	}
	public void setAfterBalance(long afterBalance) {
		this.afterBalance = afterBalance;
	}
}
