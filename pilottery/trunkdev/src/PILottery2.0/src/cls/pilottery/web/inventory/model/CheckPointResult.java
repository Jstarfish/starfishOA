package cls.pilottery.web.inventory.model;

public class CheckPointResult {
	private String cpNo;
	private Long cbeforeNum;
	private Long cbeforeAmount;
	private Long cafterNum;
	private Long cafterAmount;
	private int  cresult;
	private int cerrorcode;
	private String cerrormesg;
	private String planCode;
	private String batchNo;
	private String trunNo;
	private String boxNo;
	private String packageNo;
	private int validNumber;
	private Long seqNo;
	private int pack;
	//如下 add by dzg 用于查询盘点结果详情列表
	private int beforePkg;//盘点前当前物流包装包含包数 
	private int afterPkg;//盘点后包数
	private int diffPkg;//盘点差异数
	private int lastStep=0;
    private String remark;
	
	public int getBeforePkg() {
		return beforePkg;
	}

	public void setBeforePkg(int beforePkg) {
		this.beforePkg = beforePkg;
	}

	public int getAfterPkg() {
		return afterPkg;
	}

	public void setAfterPkg(int afterPkg) {
		this.afterPkg = afterPkg;
	}

	public int getDiffPkg() {
		return diffPkg;
	}

	public void setDiffPkg(int diffPkg) {
		this.diffPkg = diffPkg;
	}

	public String getCpNo() {
		return cpNo;
	}

	public void setCpNo(String cpNo) {
		this.cpNo = cpNo;
	}

	public Long getCbeforeNum() {
		return cbeforeNum;
	}

	public void setCbeforeNum(Long cbeforeNum) {
		this.cbeforeNum = cbeforeNum;
	}

	public Long getCbeforeAmount() {
		return cbeforeAmount;
	}

	public void setCbeforeAmount(Long cbeforeAmount) {
		this.cbeforeAmount = cbeforeAmount;
	}

	public Long getCafterNum() {
		return cafterNum;
	}

	public void setCafterNum(Long cafterNum) {
		this.cafterNum = cafterNum;
	}

	public Long getCafterAmount() {
		return cafterAmount;
	}

	public void setCafterAmount(Long cafterAmount) {
		this.cafterAmount = cafterAmount;
	}

	public int getCerrorcode() {
		return cerrorcode;
	}

	public void setCerrorcode(int cerrorcode) {
		this.cerrorcode = cerrorcode;
	}

	public String getCerrormesg() {
		return cerrormesg;
	}

	public void setCerrormesg(String cerrormesg) {
		this.cerrormesg = cerrormesg;
	}

	public int getCresult() {
		return cresult;
	}

	public void setCresult(int cresult) {
		this.cresult = cresult;
	}

	public String getPlanCode() {
		return planCode;
	}

	public void setPlanCode(String planCode) {
		this.planCode = planCode;
	}

	public String getBatchNo() {
		return batchNo;
	}

	public void setBatchNo(String batchNo) {
		this.batchNo = batchNo;
	}

	public String getTrunNo() {
		return trunNo;
	}

	public void setTrunNo(String trunNo) {
		this.trunNo = trunNo;
	}

	public String getBoxNo() {
		return boxNo;
	}

	public void setBoxNo(String boxNo) {
		this.boxNo = boxNo;
	}

	public String getPackageNo() {
		return packageNo;
	}

	public void setPackageNo(String packageNo) {
		this.packageNo = packageNo;
	}

	public int getValidNumber() {
		return validNumber;
	}

	public void setValidNumber(int validNumber) {
		this.validNumber = validNumber;
	}

	public Long getSeqNo() {
		return seqNo;
	}

	public void setSeqNo(Long seqNo) {
		this.seqNo = seqNo;
	}

	public int getPack() {
		return pack;
	}

	public void setPack(int pack) {
		this.pack = pack;
	}

	public String getRemark() {
		return remark;
	}

	public void setRemark(String remark) {
		this.remark = remark;
	}

	public int getLastStep() {
		return lastStep;
	}

	public void setLastStep(int lastStep) {
		this.lastStep = lastStep;
	}

}
