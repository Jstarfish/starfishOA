package cls.pilottery.oms.report.model;

public class GameInfo implements java.io.Serializable{
	private static final long serialVersionUID = -604274595259702020L;
	private String gameCode;
	private String fullName;
	private String shortName;
	public String getGameCode() {
		return gameCode;
	}
	public void setGameCode(String gameCode) {
		this.gameCode = gameCode;
	}
	public String getFullName() {
		return fullName;
	}
	public void setFullName(String fullName) {
		this.fullName = fullName;
	}
	public String getShortName() {
		return shortName;
	}
	public void setShortName(String shortName) {
		this.shortName = shortName;
	}

}
