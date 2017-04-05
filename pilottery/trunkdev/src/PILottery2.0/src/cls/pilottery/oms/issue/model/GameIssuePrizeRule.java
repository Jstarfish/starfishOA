package cls.pilottery.oms.issue.model;

import cls.pilottery.common.model.BaseEntity;

public class GameIssuePrizeRule extends BaseEntity {

	/**
	 * 
	 */
	private static final long serialVersionUID = 4975274641555838124L;

	private Short gameCode;
	private Long issueNumber;
	private Short prizeLevel;
	private String prizeName;
	private Long levelPrize;
	public Short getGameCode() {
		return gameCode;
	}
	public void setGameCode(Short gameCode) {
		this.gameCode = gameCode;
	}
	public Long getIssueNumber() {
		return issueNumber;
	}
	public void setIssueNumber(Long issueNumber) {
		this.issueNumber = issueNumber;
	}
	public Short getPrizeLevel() {
		return prizeLevel;
	}
	public void setPrizeLevel(Short prizeLevel) {
		this.prizeLevel = prizeLevel;
	}
	public String getPrizeName() {
		return prizeName;
	}
	public void setPrizeName(String prizeName) {
		this.prizeName = prizeName;
	}
	public Long getLevelPrize() {
		return levelPrize;
	}
	public void setLevelPrize(Long levelPrize) {
		this.levelPrize = levelPrize;
	}
	
}
