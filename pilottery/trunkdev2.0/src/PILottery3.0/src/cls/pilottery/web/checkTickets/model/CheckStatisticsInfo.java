package cls.pilottery.web.checkTickets.model;

import java.io.Serializable;

public class CheckStatisticsInfo implements Serializable {
	private static final long serialVersionUID = -6273850171090959303L;
	private String planName;
	private long levelAmount;
	private int winTickets;
	private long winAmount;
	public String getPlanName() {
		return planName;
	}
	public void setPlanName(String planName) {
		this.planName = planName;
	}
	public long getLevelAmount() {
		return levelAmount;
	}
	public void setLevelAmount(long levelAmount) {
		this.levelAmount = levelAmount;
	}
	public int getWinTickets() {
		return winTickets;
	}
	public void setWinTickets(int winTickets) {
		this.winTickets = winTickets;
	}
	public long getWinAmount() {
		return winAmount;
	}
	public void setWinAmount(long winAmount) {
		this.winAmount = winAmount;
	}
}
