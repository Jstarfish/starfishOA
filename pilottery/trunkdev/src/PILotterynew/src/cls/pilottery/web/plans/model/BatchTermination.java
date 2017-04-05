package cls.pilottery.web.plans.model;

import java.io.Serializable;

public class BatchTermination implements Serializable {

	private static final long serialVersionUID = 1L;

	private long batchCounts;// 批次数量

	private long saleCounts;// 销售数量

	private long counts;// 兑奖金额

	private long payoutNum;// 兑奖数量

	private long saleMoney;// 销售金额

	private long brokenNum;// 损毁数量

	private long warehouseCounts;// 当前库存数量

	private long marketCounts;// 市场管理员库存

	private String errorMessage;

	public long getPayoutNum() {

		return payoutNum;
	}

	public void setPayoutNum(long payoutNum) {

		this.payoutNum = payoutNum;
	}

	public BatchTermination() {

	}

	public long getBatchCounts() {

		return batchCounts;
	}

	public long getBrokenNum() {

		return brokenNum;
	}

	public long getCounts() {

		return counts;
	}

	public String getErrorMessage() {

		return errorMessage;
	}

	public long getMarketCounts() {

		return marketCounts;
	}

	public long getSaleCounts() {

		return saleCounts;
	}

	public long getSaleMoney() {

		return saleMoney;
	}

	public long getWarehouseCounts() {

		return warehouseCounts;
	}

	public void setBatchCounts(long batchCounts) {

		this.batchCounts = batchCounts;
	}

	public void setBrokenNum(long brokenNum) {

		this.brokenNum = brokenNum;
	}

	public void setCounts(long counts) {

		this.counts = counts;
	}

	public void setErrorMessage(String errorMessage) {

		this.errorMessage = errorMessage;
	}

	public void setMarketCounts(long marketCounts) {

		this.marketCounts = marketCounts;
	}

	public void setSaleCounts(long saleCounts) {

		this.saleCounts = saleCounts;
	}

	public void setSaleMoney(long saleMoney) {

		this.saleMoney = saleMoney;
	}

	public void setWarehouseCounts(long warehouseCounts) {

		this.warehouseCounts = warehouseCounts;
	}
}
