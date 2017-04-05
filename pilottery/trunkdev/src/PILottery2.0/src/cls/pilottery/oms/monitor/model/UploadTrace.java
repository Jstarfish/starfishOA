package cls.pilottery.oms.monitor.model;

import java.io.Serializable;
import java.util.Date;

/**
 * @Description:上传日志实体类
 * @author:star
 * @time:2016年3月24日 上午10:03:45
 */
public class UploadTrace implements Serializable {

	private static final long serialVersionUID = 7147250505579416289L;

	private long seq;
	private String terminalCode;
	private Date applyTime;
	private int applyType;
	private String applyArg1;
	private int applyStatus;
	private Date succTime;
	private String uploadFile;

	public long getSeq() {
		return seq;
	}

	public void setSeq(long seq) {
		this.seq = seq;
	}

	public String getTerminalCode() {
		return terminalCode;
	}

	public void setTerminalCode(String terminalCode) {
		this.terminalCode = terminalCode;
	}

	public Date getApplyTime() {
		return applyTime;
	}

	public void setApplyTime(Date applyTime) {
		this.applyTime = applyTime;
	}

	public int getApplyType() {
		return applyType;
	}

	public void setApplyType(int applyType) {
		this.applyType = applyType;
	}

	public String getApplyArg1() {
		return applyArg1;
	}

	public void setApplyArg1(String applyArg1) {
		this.applyArg1 = applyArg1;
	}

	public int getApplyStatus() {
		return applyStatus;
	}

	public void setApplyStatus(int applyStatus) {
		this.applyStatus = applyStatus;
	}

	public Date getSuccTime() {
		return succTime;
	}

	public void setSuccTime(Date succTime) {
		this.succTime = succTime;
	}

	public String getUploadFile() {
		return uploadFile;
	}

	public void setUploadFile(String uploadFile) {
		this.uploadFile = uploadFile;
	}

}
