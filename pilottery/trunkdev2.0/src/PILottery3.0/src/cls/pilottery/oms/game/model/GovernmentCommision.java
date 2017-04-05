package cls.pilottery.oms.game.model;

import java.util.Date;

import cls.pilottery.common.model.BaseEntity;
/**
 * 游戏发行费历史（GOV_COMMISION）
 * @author Woo
 */
public class GovernmentCommision extends BaseEntity {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1425548940728485460L;
	private Long hisCode;
	private Short gameCode;
	private Long issueNumber;
	private Short commChangeType;	//1.	发行费变更类型（1、期次开奖滚入；2、发行费手动拨出到奖池；3、发行费手动拨出到调节基金；）
	private Long adjAmount;
	private Long adjAmountBefore;
	private Long adjAmountAfter;
	private Date adjTime;
	private String adjReason;
	
	public Long getHisCode() {
		return hisCode;
	}
	public void setHisCode(Long hisCode) {
		this.hisCode = hisCode;
	}
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
	public Short getCommChangeType() {
		return commChangeType;
	}
	public void setCommChangeType(Short commChangeType) {
		this.commChangeType = commChangeType;
	}
	public Long getAdjAmount() {
		return adjAmount;
	}
	public void setAdjAmount(Long adjAmount) {
		this.adjAmount = adjAmount;
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
	public Date getAdjTime() {
		return adjTime;
	}
	public void setAdjTime(Date adjTime) {
		this.adjTime = adjTime;
	}
	public String getAdjReason() {
		return adjReason;
	}
	public void setAdjReason(String adjReason) {
		this.adjReason = adjReason;
	}
	
}
