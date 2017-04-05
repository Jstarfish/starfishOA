package cls.pilottery.web.goodsIssues.model;

import java.util.ArrayList;
import java.util.List;

import cls.pilottery.web.goodsreceipts.model.GameBatchParamt;

public class GoodIssuesParamt {
	private String doNo;// 出货单
	private Integer operType;// 操作类型
	private String  sgiNo;//出库单编号
	private Integer trunkhAmount;//箱数

	private Integer boxAmount;//盒数
	private Integer packageAmount;//本数
	private Long receivableAmount;//实际出库票数
	private Long differencesAmount;//差异数
	private Long receivabedAmount;//应出库张数
	private Long tickets;//票数

	private Long amount;//金额
	private List<GameBatchParamt> para= new ArrayList<GameBatchParamt>();
	private String remarks;
	private String receivingUnit;//收货单位
	private String deliveringUnit;//发货单位
	private String sbtNo;//调拨单编号
	private String warehouseCode;//库房编号
	private Integer adminId;//操作人
	private String refNo;
    private String stbNo;
	public String getDoNo() {
		return doNo;
	}

	public void setDoNo(String doNo) {
		this.doNo = doNo;
	}

	public Integer getOperType() {
		return operType;
	}

	public void setOperType(Integer operType) {
		this.operType = operType;
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

	public List<GameBatchParamt> getPara() {
		return para;
	}

	public void setPara(List<GameBatchParamt> para) {
		this.para = para;
	}

	public String getSgiNo() {
		return sgiNo;
	}

	public void setSgiNo(String sgiNo) {
		this.sgiNo = sgiNo;
	}

	public String getRemarks() {
		return remarks;
	}

	public void setRemarks(String remarks) {
		this.remarks = remarks;
	}

	public Long getReceivabedAmount() {
		return receivabedAmount;
	}

	public void setReceivabedAmount(Long receivabedAmount) {
		this.receivabedAmount = receivabedAmount;
	}

	public String getReceivingUnit() {
		return receivingUnit;
	}

	public void setReceivingUnit(String receivingUnit) {
		this.receivingUnit = receivingUnit;
	}

	public String getDeliveringUnit() {
		return deliveringUnit;
	}

	public void setDeliveringUnit(String deliveringUnit) {
		this.deliveringUnit = deliveringUnit;
	}

	public String getSbtNo() {
		return sbtNo;
	}

	public void setSbtNo(String sbtNo) {
		this.sbtNo = sbtNo;
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

	public String getRefNo() {
		return refNo;
	}

	public void setRefNo(String refNo) {
		this.refNo = refNo;
	}

	public String getStbNo() {
		return stbNo;
	}

	public void setStbNo(String stbNo) {
		this.stbNo = stbNo;
	}

}
