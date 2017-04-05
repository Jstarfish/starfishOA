package cls.pilottery.web.logistics.model;

import java.io.Serializable;
import java.util.Date;

public class PayoutModel implements Serializable {

	private static final long serialVersionUID = 1L;

	private Date payoutDate;// 兑奖时间

	private String outlet;// 兑奖站点

	public Date getPayoutDate() {

		return payoutDate;
	}

	public void setPayoutDate(Date payoutDate) {

		this.payoutDate = payoutDate;
	}

	public String getOutlet() {

		return outlet;
	}

	public PayoutModel() {

	}

	public void setOutlet(String outlet) {

		this.outlet = outlet;
	}
}
