package cls.pilottery.oms.monitor.model;

import java.io.Serializable;
import java.util.Date;

public class TaishanLog implements Serializable {

	private static final long serialVersionUID = 3809778726801932135L;
	private long logId; // LOG_ID 日志编号
	private int logType; // LOG_TYPE 日志类型(1=日结、2=期结)
	private Date logDate; // LOG_DATE 生成时间
	private String logDesc; // LOG_DESC 描述

	public long getLogId() {
		return logId;
	}

	public void setLogId(long logId) {
		this.logId = logId;
	}

	public int getLogType() {
		return logType;
	}

	public void setLogType(int logType) {
		this.logType = logType;
	}

	public Date getLogDate() {
		return logDate;
	}

	public void setLogDate(Date logDate) {
		this.logDate = logDate;
	}

	public String getLogDesc() {
		return logDesc;
	}

	public void setLogDesc(String logDesc) {
		this.logDesc = logDesc;
	}

}
