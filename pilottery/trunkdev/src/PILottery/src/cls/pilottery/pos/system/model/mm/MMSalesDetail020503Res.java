package cls.pilottery.pos.system.model.mm;

import java.io.Serializable;
import java.util.List;

public class MMSalesDetail020503Res implements Serializable {
	private static final long serialVersionUID = -5730506839230322909L;
	private String outletCode;
	private String time;
	private long saleAmount;
	private long saleComm;
	private List<PlanList020503Res> planList;
	private List<TagList020503Res> recordList;
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
	public long getSaleAmount() {
		return saleAmount;
	}
	public void setSaleAmount(long saleAmount) {
		this.saleAmount = saleAmount;
	}
	public long getSaleComm() {
		return saleComm;
	}
	public void setSaleComm(long saleComm) {
		this.saleComm = saleComm;
	}
	public List<PlanList020503Res> getPlanList() {
		return planList;
	}
	public void setPlanList(List<PlanList020503Res> planList) {
		this.planList = planList;
	}
	public List<TagList020503Res> getRecordList() {
		return recordList;
	}
	public void setRecordList(List<TagList020503Res> recordList) {
		this.recordList = recordList;
	}
}
