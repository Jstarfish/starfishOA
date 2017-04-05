package cls.pilottery.webncp.system.model;

import cls.pilottery.webncp.common.model.BaseRequest;

public class Request3002Model extends BaseRequest {

	private static final long serialVersionUID = 1L;

	private String gameCode;

	private String agencyCode;

	private String startIssue;

	private String closeIssue;

	public String getGameCode() {

		return gameCode;
	}

	public void setGameCode(String gameCode) {

		this.gameCode = gameCode;
	}

	public String getAgencyCode() {

		return agencyCode;
	}

	public void setAgencyCode(String agencyCode) {

		this.agencyCode = agencyCode;
	}

	public String getStartIssue() {

		return startIssue;
	}

	public void setStartIssue(String startIssue) {

		this.startIssue = startIssue;
	}

	public String getCloseIssue() {

		return closeIssue;
	}

	public void setCloseIssue(String closeIssue) {

		this.closeIssue = closeIssue;
	}
}
