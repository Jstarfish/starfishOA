package cls.pilottery.oms.monitor.model;

import java.util.Date;

public class TerminalCheck {
	private Date checkTime;
	private int termCheckId; // TERM_CHECK_ID 巡检ID
	private String termCheckName; // 巡检员姓名
	private String agencyCode;
	private String agencyName;
	private String terminalCode;

	private String orgCode;

	public String getOrgCode() {
		return orgCode;
	}

	public void setOrgCode(String orgCode) {
		this.orgCode = orgCode;
	}

	public Date getCheckTime() {
		return checkTime;
	}

	public void setCheckTime(Date checkTime) {
		this.checkTime = checkTime;
	}

	public int getTermCheckId() {
		return termCheckId;
	}

	public void setTermCheckId(int termCheckId) {
		this.termCheckId = termCheckId;
	}

	public String getTermCheckName() {
		return termCheckName;
	}

	public void setTermCheckName(String termCheckName) {
		this.termCheckName = termCheckName;
	}

	public String getAgencyCode() {
		return agencyCode;
	}

	public void setAgencyCode(String agencyCode) {
		this.agencyCode = agencyCode;
	}

	public String getAgencyName() {
		return agencyName;
	}

	public void setAgencyName(String agencyName) {
		this.agencyName = agencyName;
	}

	public String getTerminalCode() {
		return terminalCode;
	}

	public void setTerminalCode(String terminalCode) {
		this.terminalCode = terminalCode;
	}

}
