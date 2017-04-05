package cls.pilottery.oms.game.model;

import java.util.Date;

import cls.pilottery.common.model.BaseEntity;

public class FundAdjHistoryVo extends BaseEntity {

	/**
	 * 
	 */
	private static final long serialVersionUID = -5870520190674263128L;
	
	private Short gameCode;
	private Long issueNumber;
	private Date realRewardTime;
	private Long adjAmountBefore;
	private Long adjAmountAfter;
	private Long adjAmount;
	
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
	public Date getRealRewardTime() {
		return realRewardTime;
	}
	public void setRealRewardTime(Date realRewardTime) {
		this.realRewardTime = realRewardTime;
	}
	public Long getAdjAmountBefore() {
		return adjAmountBefore;
	}
	public void setAdjAmountBefore(Long adjAmountBefore) {
		this.adjAmountBefore = adjAmountBefore;
	}
	public Long getAdjAmountAfter() {
		return adjAmountAfter;
	}
	public void setAdjAmountAfter(Long adjAmountAfter) {
		this.adjAmountAfter = adjAmountAfter;
	}
	public Long getAdjAmount() {
		return adjAmount;
	}
	public void setAdjAmount(Long adjAmount) {
		this.adjAmount = adjAmount;
	}
	
}
