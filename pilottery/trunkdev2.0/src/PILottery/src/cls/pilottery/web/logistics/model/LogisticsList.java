package cls.pilottery.web.logistics.model;

import java.io.Serializable;
import java.util.Date;
import java.util.List;

import cls.pilottery.common.model.BaseEntity;

public class LogisticsList extends BaseEntity implements Serializable {

	private static final long serialVersionUID = 1L;

	private long rewardAmount;// 兑奖金额

	private Date rewardTime;// 兑奖时间

	private List<LogisticsResult> result;// 结果集

	// ----------------
	public long getRewardAmount() {

		return rewardAmount;
	}

	public void setRewardAmount(long rewardAmount) {

		this.rewardAmount = rewardAmount;
	}

	public Date getRewardTime() {

		return rewardTime ;
	}

	public void setRewardTime(Date rewardTime) {

		this.rewardTime = rewardTime;
	}

	public List<LogisticsResult> getResult() {

		return result;
	}

	public void setResult(List<LogisticsResult> result) {

		this.result = result;
	}
}
