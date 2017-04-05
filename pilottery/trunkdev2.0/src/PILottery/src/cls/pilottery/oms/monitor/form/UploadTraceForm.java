package cls.pilottery.oms.monitor.form;

import cls.pilottery.common.model.BaseEntity;

public class UploadTraceForm extends BaseEntity {

	private static final long serialVersionUID = -7648448876665694481L;

	private String seq;
	private String terminalCode;
	private String applyTime;
	private int applyType;
	private String applyArg1;
	private int applyStatus;
	private String succTime;
	private String uploadFile;

	public String getSeq() {
		return seq;
	}

	public void setSeq(String seq) {
		this.seq = seq;
	}

	public String getTerminalCode() {
		return terminalCode;
	}

	public void setTerminalCode(String terminalCode) {
		this.terminalCode = terminalCode;
	}

	public String getApplyTime() {
		return applyTime;
	}

	public void setApplyTime(String applyTime) {
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

	public String getSuccTime() {
		return succTime;
	}

	public void setSuccTime(String succTime) {
		this.succTime = succTime;
	}

	public String getUploadFile() {
		return uploadFile;
	}

	public void setUploadFile(String uploadFile) {
		this.uploadFile = uploadFile;
	}

}
