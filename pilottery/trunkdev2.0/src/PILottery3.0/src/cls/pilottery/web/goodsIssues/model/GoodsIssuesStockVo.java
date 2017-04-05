package cls.pilottery.web.goodsIssues.model;

public class GoodsIssuesStockVo {
	private String stbNo;//调拨单号
	private String deliveringUnit;//发货单位
	private String receivingUnit;//收获单位

	public String getStbNo() {
		return stbNo;
	}

	public void setStbNo(String stbNo) {
		this.stbNo = stbNo;
	}

	public String getDeliveringUnit() {
		return deliveringUnit;
	}

	public void setDeliveringUnit(String deliveringUnit) {
		this.deliveringUnit = deliveringUnit;
	}

	public String getReceivingUnit() {
		return receivingUnit;
	}

	public void setReceivingUnit(String receivingUnit) {
		this.receivingUnit = receivingUnit;
	}

}
