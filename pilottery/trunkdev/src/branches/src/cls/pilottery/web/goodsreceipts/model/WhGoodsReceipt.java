package cls.pilottery.web.goodsreceipts.model;

import java.io.Serializable;
import java.util.Date;

public class WhGoodsReceipt implements Serializable{
	
	    /**
	    * @Fields serialVersionUID : TODO(用一句话描述这个变量表示什么)
	    */
	    
	private static final long serialVersionUID = 1L;

	private String sgrNo;// 入库单编号（RK12345678）

	private Long createAdmin;// 建立人

	private Date createDate;// 建立时间

	private Long receiptAmount;// 入库金额合计

	private Long receiptTickets;// 入库张数

	private Long actReceiptAmount;// 实际入库金额合计

	private Long actReceiptTickets;// 实际入库张数

	private Long receiptType;// 入库类型（1-批次入库、2-调拨单入库、3-退货入库）

	private String refNo;// 参考编号

	private Long status;// 状态（1-未完成，2-已完成）

	private String carrier;// 送货人

	private Date carryDate;// 送货时间

	private String carrierContact;// 联系方式

	private String sendOrg;// 入库仓库所属单位

	private String sendWh;// 入库仓库

	private Long sendManager;// 入库仓库管理员

	private Date sendDate;// 入库时间
	private String sendOperater;//
	private String planCode;
	private String planName;
	private String batchNo;
    private String remark;

	public String getSgrNo() {
		return sgrNo;
	}

	public void setSgrNo(String sgrNo) {
		this.sgrNo = sgrNo == null ? null : sgrNo.trim();
	}

	public Long getCreateAdmin() {
		return createAdmin;
	}

	public void setCreateAdmin(Long createAdmin) {
		this.createAdmin = createAdmin;
	}

	public Date getCreateDate() {
		return createDate;
	}

	public void setCreateDate(Date createDate) {
		this.createDate = createDate;
	}

	public Long getReceiptAmount() {
		return receiptAmount;
	}

	public void setReceiptAmount(Long receiptAmount) {
		this.receiptAmount = receiptAmount;
	}

	public Long getReceiptTickets() {
		return receiptTickets;
	}

	public void setReceiptTickets(Long receiptTickets) {
		this.receiptTickets = receiptTickets;
	}

	public Long getActReceiptAmount() {
		return actReceiptAmount;
	}

	public void setActReceiptAmount(Long actReceiptAmount) {
		this.actReceiptAmount = actReceiptAmount;
	}

	public Long getActReceiptTickets() {
		return actReceiptTickets;
	}

	public void setActReceiptTickets(Long actReceiptTickets) {
		this.actReceiptTickets = actReceiptTickets;
	}


	public Long getReceiptType() {
		return receiptType;
	}

	public void setReceiptType(Long receiptType) {
		this.receiptType = receiptType;
	}

	public String getRefNo() {
		return refNo;
	}

	public void setRefNo(String refNo) {
		this.refNo = refNo == null ? null : refNo.trim();
	}

	public Long getStatus() {
		return status;
	}

	public void setStatus(Long status) {
		this.status = status;
	}

	public String getCarrier() {
		return carrier;
	}

	public void setCarrier(String carrier) {
		this.carrier = carrier == null ? null : carrier.trim();
	}

	public Date getCarryDate() {
		return carryDate;
	}

	public void setCarryDate(Date carryDate) {
		this.carryDate = carryDate;
	}

	public String getCarrierContact() {
		return carrierContact;
	}

	public void setCarrierContact(String carrierContact) {
		this.carrierContact = carrierContact == null ? null : carrierContact.trim();
	}

	public String getSendOrg() {
		return sendOrg;
	}

	public void setSendOrg(String sendOrg) {
		this.sendOrg = sendOrg == null ? null : sendOrg.trim();
	}

	public String getSendWh() {
		return sendWh;
	}

	public void setSendWh(String sendWh) {
		this.sendWh = sendWh == null ? null : sendWh.trim();
	}

	public Long getSendManager() {
		return sendManager;
	}

	public void setSendManager(Long sendManager) {
		this.sendManager = sendManager;
	}

	public Date getSendDate() {
		return sendDate;
	}

	public void setSendDate(Date sendDate) {
		this.sendDate = sendDate;
	}

	public String getSendOperater() {
		return sendOperater;
	}

	public void setSendOperater(String sendOperater) {
		this.sendOperater = sendOperater;
	}

	public String getPlanCode() {
		return planCode;
	}

	public void setPlanCode(String planCode) {
		this.planCode = planCode;
	}

	public String getPlanName() {
		return planName;
	}

	public void setPlanName(String planName) {
		this.planName = planName;
	}

	public String getBatchNo() {
		return batchNo;
	}

	public void setBatchNo(String batchNo) {
		this.batchNo = batchNo;
	}

	public String getRemark() {
		return remark;
	}

	public void setRemark(String remark) {
		this.remark = remark;
	}
	
}