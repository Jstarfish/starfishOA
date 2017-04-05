package cls.pilottery.oms.monitor.model;

public class GameSalesTrend {

	private int gameCode; // GAME_CODE 游戏编码
	private long saleAmount; // SALE_AMOUNT 当日累计销售金额
	private String timePoint; // TIME_POINT 统计时间点
	private String timePointText;

	public String getTimePointText() {
		timePointText = timePoint.substring(11, 16);
		return timePointText;
	}

	public int getGameCode() {
		return gameCode;
	}

	public void setGameCode(int gameCode) {
		this.gameCode = gameCode;
	}

	public long getSaleAmount() {
		return saleAmount;
	}

	public void setSaleAmount(long saleAmount) {
		this.saleAmount = saleAmount;
	}

	public String getTimePoint() {
		return timePoint;
	}

	public void setTimePoint(String timePoint) {
		this.timePoint = timePoint;
	}
}
