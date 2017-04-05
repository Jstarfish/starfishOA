package cls.pilottery.oms.business.form.tmversionform;

import cls.pilottery.oms.business.model.tmversionmodel.TerminalSoftWare;

public class TerminalSoftWareForm {
	/**
	 * 升级开始时间
	 */
	private String upgradeStartTime;
	/**
	 * 升级结束时间
	 */
	private String upgradeEndTime;
	/**
	 * 上报开始时间
	 */
	private String reportStartTime;
	/**
	 * 上报结束时间
	 */
	private String reportEndTime;

	private TerminalSoftWare terminalSoftWare;

	public TerminalSoftWare getTerminalSoftWare() {
		if (terminalSoftWare == null)
			terminalSoftWare = new TerminalSoftWare();
		return terminalSoftWare;
	}

	public void setTerminalSoftWare(TerminalSoftWare terminalSoftWare) {
		this.terminalSoftWare = terminalSoftWare;
	}

	public String getUpgradeStartTime() {
		return upgradeStartTime;
	}

	public void setUpgradeStartTime(String upgradeStartTime) {
		this.upgradeStartTime = upgradeStartTime;
	}

	public String getUpgradeEndTime() {
		return upgradeEndTime;
	}

	public void setUpgradeEndTime(String upgradeEndTime) {
		this.upgradeEndTime = upgradeEndTime;
	}

	public String getReportStartTime() {
		return reportStartTime;
	}

	public void setReportStartTime(String reportStartTime) {
		this.reportStartTime = reportStartTime;
	}

	public String getReportEndTime() {
		return reportEndTime;
	}

	public void setReportEndTime(String reportEndTime) {
		this.reportEndTime = reportEndTime;
	}

}
