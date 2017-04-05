package cls.pilottery.oms.monitor.model;

import cls.pilottery.common.model.BaseEntity;

/**
 * @describe 游戏期次监控实体类
 * 
 */
public class GameIssue extends BaseEntity {

	private static final long serialVersionUID = -6270069205866269912L;
	private long gameCode; // GAME_CODE 游戏编码
	private long issueNumber; // ISSUE_NUMBER 游戏期号
	private long issueSeq; // ISSUE_SEQ 期次序号
	private int issueStatus; // ISSUE_STATUS 期次状态
	private int isPublish; // IS_PUBLISH 是否已发布
	private int drawState; // DRAW_STATE 期次开奖状态

	private String realStartTime; // REAL_START_TIME 开始时间（实际）
	private String realRewardTime; // REAL_REWARD_TIME 开奖时间（实际）
	private String realCloseTime; // REAL_CLOSE_TIME 关闭时间（实际）

	private String issueEndTime; // ISSUE_END_TIME 期结时间

	private String firstDrawUser; // FIRST_DRAW_USER_ID 第一次开奖用户
	private String secondDrawUser; // SECOND_DRAW_USER_ID 第二次开奖用户
	private String finalDrawNumber; // FINAL_DRAW_NUMBER 最终开奖号码
	private long finalDrawUserId; // FINAL_DRAW_USER_ID 开奖号码审批人

	private long poolStartAmount; // POOL_START_AMOUNT 期初奖池
	private long poolCloseAmount; // POOL_CLOSE_AMOUNT 期末奖池
	private long winningAmount; // WINNING_AMOUNT 中奖总额

	private long issueSaleAmount; // ISSUE_SALE_AMOUNT 销售金额
	private long issueSaleTickets; // ISSUE_SALE_TICKETS 本期销售票数,不包含未来游戏期销售
	private long issueCancelAmount; // ISSUE_CANCEL_AMOUNT 本期退票金额,不包含未来游戏期销售
	private long issueCancelTickets; // ISSUE_CANCEL_TICKETS 本期退票票数,不包含未来游戏期销售

	// private int riskStatus; // RISK_STATUS 是否启用风控(1:启用,0:不启用)
	private long issueRickTickets; // ISSUE_RICK_TICKETS 风控拒绝票数/风控拒绝次数
	private long issueRickAmount; // ISSUE_RICK_AMOUNT 风控拒绝金额

	private String winningResult; // WINNING_RESULT 开奖号码
	private int isOpenRisk;  //是否启用风控
	private String firstUserName;
	private String secondUserName;

	
	
	public int getIsOpenRisk() {
		return isOpenRisk;
	}

	public void setIsOpenRisk(int isOpenRisk) {
		this.isOpenRisk = isOpenRisk;
	}

	public String getFirstUserName() {
		return firstUserName;
	}

	public void setFirstUserName(String firstUserName) {
		this.firstUserName = firstUserName;
	}

	public String getSecondUserName() {
		return secondUserName;
	}

	public void setSecondUserName(String secondUserName) {
		this.secondUserName = secondUserName;
	}

	public long getGameCode() {
		return gameCode;
	}

	public void setGameCode(long gameCode) {
		this.gameCode = gameCode;
	}

	public long getIssueNumber() {
		return issueNumber;
	}

	public void setIssueNumber(long issueNumber) {
		this.issueNumber = issueNumber;
	}

	public long getIssueSeq() {
		return issueSeq;
	}

	public void setIssueSeq(long issueSeq) {
		this.issueSeq = issueSeq;
	}

	public int getIssueStatus() {
		return issueStatus;
	}

	public void setIssueStatus(int issueStatus) {
		this.issueStatus = issueStatus;
	}

	public int getIsPublish() {
		return isPublish;
	}

	public void setIsPublish(int isPublish) {
		this.isPublish = isPublish;
	}

	public int getDrawState() {
		return drawState;
	}

	public void setDrawState(int drawState) {
		this.drawState = drawState;
	}

	public String getRealStartTime() {
		return realStartTime;
	}

	public void setRealStartTime(String realStartTime) {
		this.realStartTime = realStartTime;
	}

	public String getRealRewardTime() {
		return realRewardTime;
	}

	public void setRealRewardTime(String realRewardTime) {
		this.realRewardTime = realRewardTime;
	}

	public String getRealCloseTime() {
		return realCloseTime;
	}

	public void setRealCloseTime(String realCloseTime) {
		this.realCloseTime = realCloseTime;
	}

	public String getIssueEndTime() {
		return issueEndTime;
	}

	public void setIssueEndTime(String issueEndTime) {
		this.issueEndTime = issueEndTime;
	}

	public String getFirstDrawUser() {
		return firstDrawUser;
	}

	public void setFirstDrawUser(String firstDrawUser) {
		this.firstDrawUser = firstDrawUser;
	}

	public String getSecondDrawUser() {
		return secondDrawUser;
	}

	public void setSecondDrawUser(String secondDrawUser) {
		this.secondDrawUser = secondDrawUser;
	}

	public String getFinalDrawNumber() {
		return finalDrawNumber;
	}

	public void setFinalDrawNumber(String finalDrawNumber) {
		this.finalDrawNumber = finalDrawNumber;
	}

	public long getFinalDrawUserId() {
		return finalDrawUserId;
	}

	public void setFinalDrawUserId(long finalDrawUserId) {
		this.finalDrawUserId = finalDrawUserId;
	}

	public long getPoolStartAmount() {
		return poolStartAmount;
	}

	public void setPoolStartAmount(long poolStartAmount) {
		this.poolStartAmount = poolStartAmount;
	}

	public long getPoolCloseAmount() {
		return poolCloseAmount;
	}

	public void setPoolCloseAmount(long poolCloseAmount) {
		this.poolCloseAmount = poolCloseAmount;
	}

	public long getWinningAmount() {
		return winningAmount;
	}

	public void setWinningAmount(long winningAmount) {
		this.winningAmount = winningAmount;
	}

	public long getIssueSaleAmount() {
		return issueSaleAmount;
	}

	public void setIssueSaleAmount(long issueSaleAmount) {
		this.issueSaleAmount = issueSaleAmount;
	}

	public long getIssueSaleTickets() {
		return issueSaleTickets;
	}

	public void setIssueSaleTickets(long issueSaleTickets) {
		this.issueSaleTickets = issueSaleTickets;
	}

	public long getIssueCancelAmount() {
		return issueCancelAmount;
	}

	public void setIssueCancelAmount(long issueCancelAmount) {
		this.issueCancelAmount = issueCancelAmount;
	}

	public long getIssueCancelTickets() {
		return issueCancelTickets;
	}

	public void setIssueCancelTickets(long issueCancelTickets) {
		this.issueCancelTickets = issueCancelTickets;
	}

	public long getIssueRickTickets() {
		return issueRickTickets;
	}

	public void setIssueRickTickets(long issueRickTickets) {
		this.issueRickTickets = issueRickTickets;
	}

	public long getIssueRickAmount() {
		return issueRickAmount;
	}

	public void setIssueRickAmount(long issueRickAmount) {
		this.issueRickAmount = issueRickAmount;
	}

	public String getWinningResult() {
		return winningResult;
	}

	public void setWinningResult(String winningResult) {
		this.winningResult = winningResult;
	}

}
