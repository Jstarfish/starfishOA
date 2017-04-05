package cls.pilottery.web.goodsreceipts.model;

import java.io.Serializable;

public class GameBatchImportDetail implements Serializable {

	/**
	 * @Fields serialVersionUID :
	 */

	private static final long serialVersionUID = 1554674501867456209L;

	private String importNo;// 数据导入序号（IMP-12345678）

	private String planCode;// 方案编码

	private String batchNo;// 生产批次

	private String lotteryType;// 彩票分类

	private String lotteryName;// 彩票名称

	private Long boxesEveryTrunk;// 每箱盒数

	private Long trunksEveryGroup;// 每组箱数

	private Long packsEveryTrunk;// 每箱本数

	private Long ticketsEveryPack;// 每本张数

	private Long ticketsEveryGroup;// 奖组张数（万张）

	private Long firstRewardGroupNo;// 首分组号

	private Long ticketsEveryBatch;// 批次张数
	
	private Long firstTrunkBath;// 批次首箱编号
	
	private Short status;// 状态（1-启用，2-停用）
	
	private Long ticketAmount;// 单票金额
	

	public String getImportNo() {
		return importNo;
	}

	public void setImportNo(String importNo) {
		this.importNo = importNo == null ? null : importNo.trim();
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

	public String getLotteryType() {
		return lotteryType;
	}

	public void setLotteryType(String lotteryType) {
		this.lotteryType = lotteryType == null ? null : lotteryType.trim();
	}

	public String getLotteryName() {
		return lotteryName;
	}

	public void setLotteryName(String lotteryName) {
		this.lotteryName = lotteryName == null ? null : lotteryName.trim();
	}

	public Long getBoxesEveryTrunk() {
		return boxesEveryTrunk;
	}

	public void setBoxesEveryTrunk(Long boxesEveryTrunk) {
		this.boxesEveryTrunk = boxesEveryTrunk;
	}

	public Long getTrunksEveryGroup() {
		return trunksEveryGroup;
	}

	public void setTrunksEveryGroup(Long trunksEveryGroup) {
		this.trunksEveryGroup = trunksEveryGroup;
	}

	public Long getPacksEveryTrunk() {
		return packsEveryTrunk;
	}

	public void setPacksEveryTrunk(Long packsEveryTrunk) {
		this.packsEveryTrunk = packsEveryTrunk;
	}

	public Long getTicketsEveryPack() {
		return ticketsEveryPack;
	}

	public void setTicketsEveryPack(Long ticketsEveryPack) {
		this.ticketsEveryPack = ticketsEveryPack;
	}

	public Long getTicketsEveryGroup() {
		return ticketsEveryGroup;
	}

	public void setTicketsEveryGroup(Long ticketsEveryGroup) {
		this.ticketsEveryGroup = ticketsEveryGroup;
	}

	public Long getFirstRewardGroupNo() {
		return firstRewardGroupNo;
	}

	public void setFirstRewardGroupNo(Long firstRewardGroupNo) {
		this.firstRewardGroupNo = firstRewardGroupNo;
	}

	public Long getTicketsEveryBatch() {
		return ticketsEveryBatch;
	}

	public void setTicketsEveryBatch(Long ticketsEveryBatch) {
		this.ticketsEveryBatch = ticketsEveryBatch;
	}

	public Short getStatus() {
		return status;
	}

	public void setStatus(Short status) {
		this.status = status;
	}

	public Long getFirstTrunkBath() {
		return firstTrunkBath;
	}

	public void setFirstTrunkBath(Long firstTrunkBath) {
		this.firstTrunkBath = firstTrunkBath;
	}

	public Long getTicketAmount() {
		return ticketAmount;
	}

	public void setTicketAmount(Long ticketAmount) {
		this.ticketAmount = ticketAmount;
	}

}