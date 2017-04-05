package cls.pilottery.oms.business.model.tmversionmodel;

import java.util.Date;

import cls.pilottery.common.model.BaseEntity;
import cls.pilottery.oms.business.model.TerminalType;

public class TerminalSoftWare extends BaseEntity {
	/**
	 * 
	 */
	private static final long serialVersionUID = -3963559188606618036L;
	/**
	 * 终端编码
	 */
	String terminalCode;
	Long tCode;
	/**
	 * 终端机型
	 */
	Integer termType;
	/**
	 * 运行软件包版本号
	 * 
	 * @return
	 */
	String runningPkgVer;
	/**
	 * 正在下载的软件包版本号
	 * 
	 * @return
	 */
	String downingPkgVer;
	/**
	 * 最近升级日期
	 */
	Date lastUpgradeDate;
	String lastUpgradeDateToChar;
	/**
	 * 最近上报日期
	 */
	Date lastReportDate;
	String lastReportDateToChar;
	/**
	 * 开始日期
	 * 
	 * @return
	 */
	String startTime;
	/**
	 * 结束日期
	 * 
	 * @return
	 */
	String endTime;

	private TerminalType terminalTypes;

	public String getStartTime() {
		return startTime;
	}

	public void setStartTime(String startTime) {
		this.startTime = startTime;
	}

	public String getEndTime() {
		return endTime;
	}

	public void setEndTime(String endTime) {
		this.endTime = endTime;
	}

	public String getTerminalCode() {
		return terminalCode;
	}

	public void setTerminalCode(String terminalCode) {
		this.terminalCode = terminalCode;
	}

	public Integer getTermType() {
		return termType;
	}

	public void setTermType(Integer termType) {
		this.termType = termType;
	}

	public String getRunningPkgVer() {
		return runningPkgVer;
	}

	public void setRunningPkgVer(String runningPkgVer) {
		this.runningPkgVer = runningPkgVer;
	}

	public String getDowningPkgVer() {
		return downingPkgVer;
	}

	public void setDowningPkgVer(String downingPkgVer) {
		this.downingPkgVer = downingPkgVer;
	}

	public Date getLastUpgradeDate() {
		return lastUpgradeDate;
	}

	public void setLastUpgradeDate(Date lastUpgradeDate) {
		this.lastUpgradeDate = lastUpgradeDate;
	}

	public Date getLastReportDate() {
		return lastReportDate;
	}

	public void setLastReportDate(Date lastReportDate) {
		this.lastReportDate = lastReportDate;
	}

	public Long gettCode() {
		return tCode;
	}

	public void settCode(Long tCode) {
		this.tCode = tCode;
	}

	public String getLastUpgradeDateToChar() {
		return lastUpgradeDateToChar;
	}

	public void setLastUpgradeDateToChar(String lastUpgradeDateToChar) {
		this.lastUpgradeDateToChar = lastUpgradeDateToChar;
	}

	public String getLastReportDateToChar() {
		return lastReportDateToChar;
	}

	public void setLastReportDateToChar(String lastReportDateToChar) {
		this.lastReportDateToChar = lastReportDateToChar;
	}

	public TerminalType getTerminalTypes() {
		return terminalTypes;
	}

	public void setTerminalTypes(TerminalType terminalTypes) {
		this.terminalTypes = terminalTypes;
	}

}
