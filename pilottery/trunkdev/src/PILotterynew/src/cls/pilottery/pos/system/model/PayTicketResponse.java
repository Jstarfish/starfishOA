package cls.pilottery.pos.system.model;

import java.util.List;

/*
 * 兑奖相应信息
 */
public class PayTicketResponse {

	private String outletCode;
	private long winAmount=0;
	private int winTickets;
	private List<WinTicketInfo> winningList = null;
	public String getOutletCode() {
		return outletCode;
	}
	public void setOutletCode(String outletCode) {
		this.outletCode = outletCode;
	}
	public long getWinAmount() {
		return winAmount;
	}
	public void setWinAmount(long winAmount) {
		this.winAmount = winAmount;
	}
	public List<WinTicketInfo> getWinningList() {
		return winningList;
	}
	public void setWinningList(List<WinTicketInfo> winningList) {
		this.winningList = winningList;
	}
	public int getWinTickets() {
		return winTickets;
	}
	public void setWinTickets(int winTickets) {
		this.winTickets = winTickets;
	}
}
