package cls.pilottery.web.monitor.model;

import java.io.Serializable;

public class SalesLineModel implements Serializable {
	private static final long serialVersionUID = 7524413636925113129L;
	private String calcTime;
	private long saleAmount;
	public String getCalcTime() {
		return calcTime;
	}
	public void setCalcTime(String calcTime) {
		this.calcTime = calcTime;
	}
	public long getSaleAmount() {
		return saleAmount;
	}
	public void setSaleAmount(long saleAmount) {
		this.saleAmount = saleAmount;
	}
}
