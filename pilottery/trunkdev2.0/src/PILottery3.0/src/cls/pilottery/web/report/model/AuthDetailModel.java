package cls.pilottery.web.report.model;

public class AuthDetailModel implements java.io.Serializable {
	private static final long serialVersionUID = 7235694216227931337L;
	private String gameCode;
	private String gameName;
	private int isSale;
	private int isPayout;
	private int isCancel;
	private int saleComm;
	private int payoutComm;
	public String getGameCode() {
		return gameCode;
	}
	public void setGameCode(String gameCode) {
		this.gameCode = gameCode;
	}
	public String getGameName() {
		return gameName;
	}
	public void setGameName(String gameName) {
		this.gameName = gameName;
	}
	public int getIsSale() {
		return isSale;
	}
	public void setIsSale(int isSale) {
		this.isSale = isSale;
	}
	public int getIsPayout() {
		return isPayout;
	}
	public void setIsPayout(int isPayout) {
		this.isPayout = isPayout;
	}
	public int getIsCancel() {
		return isCancel;
	}
	public void setIsCancel(int isCancel) {
		this.isCancel = isCancel;
	}
	public int getSaleComm() {
		return saleComm;
	}
	public void setSaleComm(int saleComm) {
		this.saleComm = saleComm;
	}
	public int getPayoutComm() {
		return payoutComm;
	}
	public void setPayoutComm(int payoutComm) {
		this.payoutComm = payoutComm;
	}
}
