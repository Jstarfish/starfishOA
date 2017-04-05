package cls.pilottery.oms.monitor.model;

import java.io.Serializable;

public class AreaTerminal implements Serializable {

	private static final long serialVersionUID = -7968822334127895304L;
	private String areaCode; // 机构编码ORG_CODE
	private String areaName; // 机构名称ORG_NAME

	private int onlineCount; // 上线终端数量ONLINE_COUNT
	private int totalCount; // 终端总数量TOTAL_COUNT

	private String calcDate; // 统计日期CALC_DATE

	private String calcTime; // 统计时间（24小时，每10分钟一个间隔，从1-144）CALC_TIME

	public String getAreaCode() {
		return areaCode;
	}

	public void setAreaCode(String areaCode) {
		this.areaCode = areaCode;
	}

	public String getAreaName() {
		return areaName;
	}

	public void setAreaName(String areaName) {
		this.areaName = areaName;
	}

	public int getOnlineCount() {
		return onlineCount;
	}

	public void setOnlineCount(int onlineCount) {
		this.onlineCount = onlineCount;
	}

	public int getTotalCount() {
		return totalCount;
	}

	public void setTotalCount(int totalCount) {
		this.totalCount = totalCount;
	}

	public String getCalcDate() {
		return calcDate;
	}

	public void setCalcDate(String calcDate) {
		this.calcDate = calcDate;
	}

	public String getCalcTime() {
		return calcTime;
	}

	public void setCalcTime(String calcTime) {
		this.calcTime = calcTime;
	}
}
