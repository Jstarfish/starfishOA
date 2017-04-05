package cls.pilottery.web.goodsreceipts.model;

import java.util.ArrayList;
import java.util.List;

import cls.pilottery.common.model.BaseEntity;

/**
 * 
    * @ClassName: GoodReceiptParamt
    * @Description: 入库参数
    * @author yuyuanhua
    * @date 2015年9月14日
    *
 */

public class GoodReceiptParamt extends BaseEntity {
	private String planCode;//方案名称
	
	private String batchNo;// 	生产批次
	
	private Long receiptType;// 入库类型（1-批次入库、2-调拨单入库、3-退货入库）
	
	private String sgrNo;// 入库单编号（RK12345678）


	private String trunkNo;//箱号

	private Integer boxNo;//盒号

	private String packageNo;//本号

	private int tickets;//票数

	private Long amount;//金额
	private String fullName;//方案全名
	
	private Integer trunkhAmount;//箱数

	private Integer boxAmount;//盒数
	
	private String warehouseCode;//库房编号
	
	private Integer adminId;//操作人

	private Integer packageAmount;//本数
	private Long receivableAmount;//
	private Long differencesAmount;//差异数
	private String remarks;
	private String stbNo;//调拨单号
    private String returnNo;//还货单号
    private Integer operType;//1新增，2继续，3完成
	public String getRemarks() {
		return remarks;
	}
	public void setRemarks(String remarks) {
		this.remarks = remarks;
	}
	private List<GameBatchParamt> para= new ArrayList<GameBatchParamt>();
	public List<GameBatchParamt> getPara() {
		return para;
	}
	public void setPara(List<GameBatchParamt> para) {
		this.para = para;
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
	public Long getReceiptType() {
		return receiptType;
	}
	public void setReceiptType(Long receiptType) {
		this.receiptType = receiptType;
	}
	public String getSgrNo() {
		return sgrNo;
	}
	public void setSgrNo(String sgrNo) {
		this.sgrNo = sgrNo;
	}
	public String getTrunkNo() {
		return trunkNo;
	}
	public void setTrunkNo(String trunkNo) {
		this.trunkNo = trunkNo;
	}
	public Integer getBoxNo() {
		return boxNo;
	}
	public void setBoxNo(Integer boxNo) {
		this.boxNo = boxNo;
	}
	public String getPackageNo() {
		return packageNo;
	}
	public void setPackageNo(String packageNo) {
		this.packageNo = packageNo;
	}
	public int getTickets() {
		return tickets;
	}
	public void setTickets(int tickets) {
		this.tickets = tickets;
	}
	public Long getAmount() {
		return amount;
	}
	public void setAmount(Long amount) {
		this.amount = amount;
	}
	public String getFullName() {
		return fullName;
	}
	public void setFullName(String fullName) {
		this.fullName = fullName;
	}
	public Integer getTrunkhAmount() {
		return trunkhAmount;
	}
	public void setTrunkhAmount(Integer trunkhAmount) {
		this.trunkhAmount = trunkhAmount;
	}
	public Integer getBoxAmount() {
		return boxAmount;
	}
	public void setBoxAmount(Integer boxAmount) {
		this.boxAmount = boxAmount;
	}
	public Integer getPackageAmount() {
		return packageAmount;
	}
	public void setPackageAmount(Integer packageAmount) {
		this.packageAmount = packageAmount;
	}
	public Long getReceivableAmount() {
		return receivableAmount;
	}
	public void setReceivableAmount(Long receivableAmount) {
		this.receivableAmount = receivableAmount;
	}
	public Long getDifferencesAmount() {
		return differencesAmount;
	}
	public void setDifferencesAmount(Long differencesAmount) {
		this.differencesAmount = differencesAmount;
	}
	public String getStbNo() {
		return stbNo;
	}
	public void setStbNo(String stbNo) {
		this.stbNo = stbNo;
	}
	public String getReturnNo() {
		return returnNo;
	}
	public void setReturnNo(String returnNo) {
		this.returnNo = returnNo;
	}
	public Integer getOperType() {
		return operType;
	}
	public void setOperType(Integer operType) {
		this.operType = operType;
	}
	public String getWarehouseCode() {
		return warehouseCode;
	}
	public void setWarehouseCode(String warehouseCode) {
		this.warehouseCode = warehouseCode;
	}
	public Integer getAdminId() {
		return adminId;
	}
	public void setAdminId(Integer adminId) {
		this.adminId = adminId;
	}
	
}
