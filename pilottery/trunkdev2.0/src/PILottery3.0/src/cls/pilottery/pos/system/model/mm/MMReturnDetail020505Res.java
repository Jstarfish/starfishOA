package cls.pilottery.pos.system.model.mm;

import java.io.Serializable;
import java.util.List;

public class MMReturnDetail020505Res implements Serializable {
	private static final long serialVersionUID = -5730506839230322909L;
	private String outletCode;
	private String time;
	private long returnAmount;
	private long returnComm;
	private List<PlanList020505Res> planList;
	private List<TagList020505Res> recordList;
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
	public long getReturnAmount() {
		return returnAmount;
	}
	public void setReturnAmount(long returnAmount) {
		this.returnAmount = returnAmount;
	}
	public long getReturnComm() {
		return returnComm;
	}
	public void setReturnComm(long returnComm) {
		this.returnComm = returnComm;
	}
	public List<PlanList020505Res> getPlanList() {
		return planList;
	}
	public void setPlanList(List<PlanList020505Res> planList) {
		this.planList = planList;
	}
	public List<TagList020505Res> getRecordList() {
		return recordList;
	}
	public void setRecordList(List<TagList020505Res> recordList) {
		this.recordList = recordList;
	}
}
