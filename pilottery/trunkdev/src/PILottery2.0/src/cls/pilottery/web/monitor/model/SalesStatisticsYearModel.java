package cls.pilottery.web.monitor.model;

import java.io.Serializable;

public class SalesStatisticsYearModel implements Serializable {

	private static final long serialVersionUID = 1L;

	private String month;

	private long amount;

	private long inComing;

	public SalesStatisticsYearModel() {

	}

	public long getAmount() {

		return amount;
	}

	public long getInComing() {

		return inComing;
	}

	public String getMonth() {

		return month;
	}

	public void setAmount(long amount) {

		this.amount = amount;
	}

	public void setInComing(long inComing) {

		this.inComing = inComing;
	}

	public void setMonth(String month) {

		this.month = month;
	}
}
