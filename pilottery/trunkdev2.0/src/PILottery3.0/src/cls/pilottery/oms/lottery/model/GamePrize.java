package cls.pilottery.oms.lottery.model;

import cls.pilottery.common.model.BaseEntity;

public class GamePrize extends BaseEntity {

	private static final long serialVersionUID = 1L;
	private short prizeCode;// 奖级编号uint8
	private String prizeName;// 奖等名称char[64]
	private long betCount;// 中奖注数uint32
	private long prizeAmount;// 单注中奖金额uint64

	public short getPrizeCode() {
		return prizeCode;
	}

	public void setPrizeCode(short prizeCode) {
		this.prizeCode = prizeCode;
	}

	public String getPrizeName() {
		return prizeName;
	}

	public void setPrizeName(String prizeName) {
		this.prizeName = prizeName;
	}

	public long getBetCount() {
		return betCount;
	}

	public void setBetCount(long betCount) {
		this.betCount = betCount;
	}

	public long getPrizeAmount() {
		return prizeAmount;
	}

	public void setPrizeAmount(long prizeAmount) {
		this.prizeAmount = prizeAmount;
	}

}
