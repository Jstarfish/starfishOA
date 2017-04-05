package cls.pilottery.web.monitor.model;

import java.io.Serializable;

public class SalesStatisticsDayModel implements Serializable {

	private static final long serialVersionUID = 1L;

	private String day;//天

	private long amount;//金额

	public SalesStatisticsDayModel() {

	}

	public long getAmount() {

		return amount;
	}

	public String getDay() {

		return day;
	}

	public void setAmount(long amount) {

		this.amount = amount;
	}

	public void setDay(String day) {

		this.day = day;
	}
}
