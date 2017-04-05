package cls.pilottery.web.logistics.form;

import java.io.Serializable;
import java.util.Date;

public class PayoutForm implements Serializable {

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

	public PayoutForm() {

	}

	public void setOutlet(String outlet) {

		this.outlet = outlet;
	}
}
