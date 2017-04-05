package cls.pilottery.pos.system.model.mm;

import java.io.Serializable;
import java.util.List;

public class MMPayoutDetail020504Res implements Serializable {
	private static final long serialVersionUID = -956225922915853928L;
	private String outletCode;
	private String time;
	private long winAmount;
	private int winTickets;
	private long payoutComm;
	private int scanTickets;
	private List<PrizeLevelList020504Res> planList;
	private List<TagList020504Res> recordList;
	public String getOutletCode() {
		return outletCode;
	}
	public void setOutletCode(String outletCode) {
		this.outletCode = outletCode;
	}
	public String getTime() {
		return time;
	}
	public void setTime(String time) {
		this.time = time;
	}
	public long getWinAmount() {
		return winAmount;
	}
	public void setWinAmount(long winAmount) {
		this.winAmount = winAmount;
	}
	public int getWinTickets() {
		return winTickets;
	}
	public void setWinTickets(int winTickets) {
		this.winTickets = winTickets;
	}
	public long getPayoutComm() {
		return payoutComm;
	}
	public void setPayoutComm(long payoutComm) {
		this.payoutComm = payoutComm;
	}
	public int getScanTickets() {
		return scanTickets;
	}
	public void setScanTickets(int scanTickets) {
		this.scanTickets = scanTickets;
	}
	public List<PrizeLevelList020504Res> getPlanList() {
		return planList;
	}
	public void setPlanList(List<PrizeLevelList020504Res> planList) {
		this.planList = planList;
	}
	public List<TagList020504Res> getRecordList() {
		return recordList;
	}
	public void setRecordList(List<TagList020504Res> recordList) {
		this.recordList = recordList;
	}

}
