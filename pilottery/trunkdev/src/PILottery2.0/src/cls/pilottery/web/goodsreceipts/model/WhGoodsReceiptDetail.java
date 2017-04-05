package cls.pilottery.web.goodsreceipts.model;

import java.io.Serializable;

public class WhGoodsReceiptDetail implements Serializable{
	
	    /**
	    * @Fields serialVersionUID : TODO(用一句话描述这个变量表示什么)
	    */
	    
	private static final long serialVersionUID = 1L;
	private String sgrNo;      //入库单编号
	
	 private Long sequenceNo; //顺序号
	 
	private Integer receiptType;//入库类型（1-批次入库、2-调拨单入库、3-退货入库）

	private String refNo;//参考编号

	private int validNumber;//有效位数（1-箱号、2-盒号、3-本号）

	private String planCode;//方案编码

	private String batchNo;//批次

	private String trunkNo;//箱号

	private String boxNo;//盒号

	private String packageNo;//本号

	private Long tickets;//票数

	private Long amount;//金额
	
	private String planName;//方案名称
	private Long tickAmount;//票面金额
	private Integer trunkCount;//箱数
    private Integer boxCount;//盒数
    private Integer packCount;//本数
   
	public Integer getTrunkCount() {
		return trunkCount;
	}

	public void setTrunkCount(Integer trunkCount) {
		this.trunkCount = trunkCount;
	}

	public Integer getBoxCount() {
		return boxCount;
	}

	public void setBoxCount(Integer boxCount) {
		this.boxCount = boxCount;
	}

	public Integer getPackCount() {
		return packCount;
	}

	public void setPackCount(Integer packCount) {
		this.packCount = packCount;
	}

	public String getSgrNo() {
		return sgrNo;
	}

	public void setSgrNo(String sgrNo) {
		this.sgrNo = sgrNo == null ? null : sgrNo.trim();
	}

	public Long getSequenceNo() {
		return sequenceNo;
	}

	public void setSequenceNo(Long sequenceNo) {
		this.sequenceNo = sequenceNo;
	}

	public Integer getReceiptType() {
		return receiptType;
	}

	public void setReceiptType(Integer receiptType) {
		this.receiptType = receiptType;
	}

	public String getRefNo() {
		return refNo;
	}

	public void setRefNo(String refNo) {
		this.refNo = refNo == null ? null : refNo.trim();
	}

	public int getValidNumber() {
		return validNumber;
	}

	public void setValidNumber(int validNumber) {
		this.validNumber = validNumber;
	}

	public String getPlanCode() {
		return planCode;
	}

	public void setPlanCode(String planCode) {
		this.planCode = planCode == null ? null : planCode.trim();
	}

	public String getBatchNo() {
		return batchNo;
	}

	public void setBatchNo(String batchNo) {
		this.batchNo = batchNo == null ? null : batchNo.trim();
	}

	public String getTrunkNo() {
		return trunkNo;
	}

	public void setTrunkNo(String trunkNo) {
		this.trunkNo = trunkNo == null ? null : trunkNo.trim();
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
		this.packageNo = packageNo == null ? null : packageNo.trim();
	}

	public Long getTickets() {
		return tickets;
	}

	public void setTickets(Long tickets) {
		this.tickets = tickets;
	}

	public Long getAmount() {
		return amount;
	}

	public void setAmount(Long amount) {
		this.amount = amount;
	}

	public String getPlanName() {
		return planName;
	}

	public void setPlanName(String planName) {
		this.planName = planName;
	}

	public Long getTickAmount() {
		return tickAmount;
	}

	public void setTickAmount(Long tickAmount) {
		this.tickAmount = tickAmount;
	}
	
}