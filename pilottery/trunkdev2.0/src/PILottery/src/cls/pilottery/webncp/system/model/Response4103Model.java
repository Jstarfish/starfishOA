package cls.pilottery.webncp.system.model;

import java.util.List;

import cls.pilottery.webncp.common.model.BaseResponse;

public class Response4103Model extends BaseResponse {
	private static final long serialVersionUID = -3848879055583403768L;
	private long winAmount;
	private int winTickets;
	List<Response4103Record> winningList;
	public long getWinAmount() {
		return winAmount;
	}
	public void setWinAmount(long winAmount) {
		this.winAmount = winAmount;
	}
	public int getWinTickets() {
		return winTickets;
	}
	public void setWinTickets(int winTickets) {
		this.winTickets = winTickets;
	}
	public List<Response4103Record> getWinningList() {
		return winningList;
	}
	public void setWinningList(List<Response4103Record> winningList) {
		this.winningList = winningList;
	}
}
