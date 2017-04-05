package cls.pilottery.pos.system.model;

import java.io.Serializable;
import java.util.List;

public class MktFundFlowResponse implements Serializable {
	private static final long serialVersionUID = 7699554037433225549L;
	private String follow = "";
	private long balance;
	private long credit;
	private List<MktFundFlowDetail> recordList;
	public String getFollow() {
		return follow;
	}
	public void setFollow(String follow) {
		this.follow = follow;
	}
	public long getBalance() {
		return balance;
	}
	public void setBalance(long balance) {
		this.balance = balance;
	}
	public long getCredit() {
		return credit;
	}
	public void setCredit(long credit) {
		this.credit = credit;
	}
	public List<MktFundFlowDetail> getRecordList() {
		return recordList;
	}
	public void setRecordList(List<MktFundFlowDetail> recordList) {
		this.recordList = recordList;
	}
}
