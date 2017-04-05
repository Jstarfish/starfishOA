package cls.pilottery.web.plans.model;

import java.io.Serializable;

/**
 * 批次导入后的显示
 * 
 * @author Administrator
 * 
 */
public class ImportBatchResult implements Serializable {

	private static final long serialVersionUID = 1L;

	private int rewardNo;// 奖符编号

	private String fastIdentityCode;// 奖符快速识别码

	private long singleRewardAccount;// 单注中奖金额

	private long counts;// 总数量

	private String planCode;// 方案代码

	private String lotteryType;// 彩票分类

	private String lotteryName;// 彩票名称

	private long boxEveryTrunk;// 每箱盒数

	private String batchNo;// 生产批次

	private long trunkEveryGroup;// 每组箱数

	private long packsEveryTrunk;// 每箱本数

	private long ticketEveryPack;// 每本张数

	private long ticketEveryGroup;// 奖组张数

	private long firstRewardGroupNo;// 首分组号

	private String publisherName;// 印制厂商

	private String message;

	public ImportBatchResult() {

	}

	public String getBatchNo() {

		return batchNo;
	}

	public long getBoxEveryTrunk() {

		return boxEveryTrunk;
	}

	public long getCounts() {

		return counts;
	}

	public String getFastIdentityCode() {

		return fastIdentityCode;
	}

	public long getFirstRewardGroupNo() {

		return firstRewardGroupNo;
	}

	public String getLotteryName() {

		return lotteryName;
	}

	public String getLotteryType() {

		return lotteryType;
	}

	public long getPacksEveryTrunk() {

		return packsEveryTrunk;
	}

	public String getPlanCode() {

		return planCode;
	}

	public String getPublisherName() {

		return publisherName;
	}

	public int getRewardNo() {

		return rewardNo;
	}

	public long getSingleRewardAccount() {

		return singleRewardAccount;
	}

	public long getTicketEveryGroup() {

		return ticketEveryGroup;
	}

	public long getTrunkEveryGroup() {

		return trunkEveryGroup;
	}

	public void setBatchNo(String batchNo) {

		this.batchNo = batchNo;
	}

	public void setBoxEveryTrunk(long boxEveryTrunk) {

		this.boxEveryTrunk = boxEveryTrunk;
	}

	public void setCounts(long counts) {

		this.counts = counts;
	}

	public void setFastIdentityCode(String fastIdentityCode) {

		this.fastIdentityCode = fastIdentityCode;
	}

	public void setFirstRewardGroupNo(long firstRewardGroupNo) {

		this.firstRewardGroupNo = firstRewardGroupNo;
	}

	public void setLotteryName(String lotteryName) {

		this.lotteryName = lotteryName;
	}

	public void setLotteryType(String lotteryType) {

		this.lotteryType = lotteryType;
	}

	public void setPacksEveryTrunk(long packsEveryTrunk) {

		this.packsEveryTrunk = packsEveryTrunk;
	}

	public void setPlanCode(String planCode) {

		this.planCode = planCode;
	}

	public void setPublisherName(String publisherName) {

		this.publisherName = publisherName;
	}

	public void setRewardNo(int rewardNo) {

		this.rewardNo = rewardNo;
	}

	public void setSingleRewardAccount(long singleRewardAccount) {

		this.singleRewardAccount = singleRewardAccount;
	}

	public void setTicketEveryGroup(long ticketEveryGroup) {

		this.ticketEveryGroup = ticketEveryGroup;
	}

	public long getTicketEveryPack() {

		return ticketEveryPack;
	}

	public void setTicketEveryPack(long ticketEveryPack) {

		this.ticketEveryPack = ticketEveryPack;
	}

	public void setTrunkEveryGroup(long trunkEveryGroup) {

		this.trunkEveryGroup = trunkEveryGroup;
	}

	public String getMessage() {

		return message;
	}

	public void setMessage(String message) {

		this.message = message;
	}
}
