package cls.pilottery.oms.game.model;

import java.util.Date;

import cls.pilottery.common.model.BaseEntity;
/**
 *  游戏期次管理(ISS_GAME_ISSUE)
 *
 *	@author Woo
 */
public class GameIssue extends BaseEntity{

	private static final long serialVersionUID = 2842742756738588374L;

	private Short gameCode;			//游戏编码
	private Long issueNumber;		//游戏期号
	private Long issueSeq;			//期次序号
	private Integer issueStatus;		//期次状态（1=预售；2=游戏期开始；3=期即将关闭；4=游戏期关闭；5=数据封存完毕；6=开奖号码已录入；7=销售已经匹配；8=已录入（得到开奖号码）；9=本地算奖完成；10=奖级已确认；11=开奖确认；12=中奖数据已录入数据库；13=期结全部完成）
	private Short isPublish;		//是否已发布 （1=发布；0=未发布）
	private Long drawStatus;		//期次开奖状态（0=不能开奖状态；1=开奖准备状态；2=数据整理状态；3=备份状态；4=备份完成；5=第一次输入完成；6=第二次输入完成；7=开奖号码审批通过；8=开奖号码审批失败；9=开奖号码已发送；10=派奖检索完成；11=派奖输入已发送；12=中奖统计完成；13=数据稽核已发送 ；14=数据稽核完成；15=期结确认已发送；16=开奖完成）
	private Date planStartTime;		//开始时间（预计）
	private Date planCloseTime;		//关闭时间（预计）
	private Date planRewardTime;	//开奖时间（预计）
	private Date realStartTime;		//开始时间（实际）
	private Date realCloseTime;		//关闭时间（实际）
	private Date realRewardTime;	//开奖时间（实际）
	private Date issueEndTime;		//期结时间
	private Long codeInputMethold;	//开奖号码输入模式（1=手工；2=光盘）
	private Long firstDrawUserId;	//第一次开奖用户
	private String firstDrawNumber;	//第一次开奖号码
	private Long secondDrawUserId;	//第二次开奖用户
	private String secondDrawNumber;//第二次开奖号码
	private String finalDrawNumber;	//最终开奖号码
	private String finalDrawUserId;	//开奖号码审批人
	private Long payEndDay;			//兑奖截止日期
	private Long poolStartAmount;	//期初奖池
	private Long poolCloseAmount;	//期末奖池
	private Long issueSaleAmount;	//销售金额
	private Long issueSaleTickets;	//销售票数
	private Long issueSaleBets;		//销售注数
	private Long issueCancelAmount;	//退票总额
	private Long issueCancelTickets;//退票张数
	private Long issueCancelBets;	//退票住数
	private Long winningAmount;		//中奖总额
	private Long winningBets;		//中奖总额
	private Long winningTickets;	//中奖票数
	private Long winningAmountBig;	//大奖金额
	private Long winningTicketsBig;	//大奖票数
	private Long issueRickAmount;	//风控拒绝金额
	private Long issueRickTickets;	//风控拒绝票数
	private String winningResult;	//开奖号码
	private Long rewardingErrorCode;	//开奖过程错误编码
	private String rewardingErrorMesg;	//开奖过程错误描述
	private String calcWinningCode;		 //算奖规则
	
	public String getCalcWinningCode() {
		return calcWinningCode;
	}
	public void setCalcWinningCode(String calcWinningCode) {
		this.calcWinningCode = calcWinningCode;
	}
	public String getFinalDrawUserId() {
		return finalDrawUserId;
	}
	public void setFinalDrawUserId(String finalDrawUserId) {
		this.finalDrawUserId = finalDrawUserId;
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
	public Long getIssueSeq() {
		return issueSeq;
	}
	public void setIssueSeq(Long issueSeq) {
		this.issueSeq = issueSeq;
	}
	public Integer getIssueStatus() {
		return issueStatus;
	}
	public void setIssueStatus(Integer issueStatus) {
		this.issueStatus = issueStatus;
	}
	public Short getIsPublish() {
		return isPublish;
	}
	public void setIsPublish(Short isPublish) {
		this.isPublish = isPublish;
	}
	public Long getDrawStatus() {
		return drawStatus;
	}
	public void setDrawStatus(Long drawStatus) {
		this.drawStatus = drawStatus;
	}
	public Date getPlanStartTime() {
		return planStartTime;
	}
	public void setPlanStartTime(Date planStartTime) {
		this.planStartTime = planStartTime;
	}
	public Date getPlanCloseTime() {
		return planCloseTime;
	}
	public void setPlanCloseTime(Date planCloseTime) {
		this.planCloseTime = planCloseTime;
	}
	public Date getPlanRewardTime() {
		return planRewardTime;
	}
	public void setPlanRewardTime(Date planRewardTime) {
		this.planRewardTime = planRewardTime;
	}
	public Date getRealStartTime() {
		return realStartTime;
	}
	public void setRealStartTime(Date realStartTime) {
		this.realStartTime = realStartTime;
	}
	public Date getRealCloseTime() {
		return realCloseTime;
	}
	public void setRealCloseTime(Date realCloseTime) {
		this.realCloseTime = realCloseTime;
	}
	public Date getRealRewardTime() {
		return realRewardTime;
	}
	public void setRealRewardTime(Date realRewardTime) {
		this.realRewardTime = realRewardTime;
	}
	public Date getIssueEndTime() {
		return issueEndTime;
	}
	public void setIssueEndTime(Date issueEndTime) {
		this.issueEndTime = issueEndTime;
	}
	public Long getCodeInputMethold() {
		return codeInputMethold;
	}
	public void setCodeInputMethold(Long codeInputMethold) {
		this.codeInputMethold = codeInputMethold;
	}
	public Long getFirstDrawUserId() {
		return firstDrawUserId;
	}
	public void setFirstDrawUserId(Long firstDrawUserId) {
		this.firstDrawUserId = firstDrawUserId;
	}
	public String getFirstDrawNumber() {
		return firstDrawNumber;
	}
	public void setFirstDrawNumber(String firstDrawNumber) {
		this.firstDrawNumber = firstDrawNumber;
	}
	public Long getSecondDrawUserId() {
		return secondDrawUserId;
	}
	public void setSecondDrawUserId(Long secondDrawUserId) {
		this.secondDrawUserId = secondDrawUserId;
	}
	public String getSecondDrawNumber() {
		return secondDrawNumber;
	}
	public void setSecondDrawNumber(String secondDrawNumber) {
		this.secondDrawNumber = secondDrawNumber;
	}
	public String getFinalDrawNumber() {
		return finalDrawNumber;
	}
	public void setFinalDrawNumber(String finalDrawNumber) {
		this.finalDrawNumber = finalDrawNumber;
	}
	public Long getPayEndDay() {
		return payEndDay;
	}
	public void setPayEndDay(Long payEndDay) {
		this.payEndDay = payEndDay;
	}
	public Long getPoolStartAmount() {
		return poolStartAmount;
	}
	public void setPoolStartAmount(Long poolStartAmount) {
		this.poolStartAmount = poolStartAmount;
	}
	public Long getPoolCloseAmount() {
		return poolCloseAmount;
	}
	public void setPoolCloseAmount(Long poolCloseAmount) {
		this.poolCloseAmount = poolCloseAmount;
	}
	public Long getIssueSaleAmount() {
		return issueSaleAmount;
	}
	public void setIssueSaleAmount(Long issueSaleAmount) {
		this.issueSaleAmount = issueSaleAmount;
	}
	public Long getIssueSaleTickets() {
		return issueSaleTickets;
	}
	public void setIssueSaleTickets(Long issueSaleTickets) {
		this.issueSaleTickets = issueSaleTickets;
	}
	public Long getIssueSaleBets() {
		return issueSaleBets;
	}
	public void setIssueSaleBets(Long issueSaleBets) {
		this.issueSaleBets = issueSaleBets;
	}
	public Long getIssueCancelAmount() {
		return issueCancelAmount;
	}
	public void setIssueCancelAmount(Long issueCancelAmount) {
		this.issueCancelAmount = issueCancelAmount;
	}
	public Long getIssueCancelTickets() {
		return issueCancelTickets;
	}
	public void setIssueCancelTickets(Long issueCancelTickets) {
		this.issueCancelTickets = issueCancelTickets;
	}
	public Long getIssueCancelBets() {
		return issueCancelBets;
	}
	public void setIssueCancelBets(Long issueCancelBets) {
		this.issueCancelBets = issueCancelBets;
	}
	public Long getWinningAmount() {
		return winningAmount;
	}
	public void setWinningAmount(Long winningAmount) {
		this.winningAmount = winningAmount;
	}
	public Long getWinningBets() {
		return winningBets;
	}
	public void setWinningBets(Long winningBets) {
		this.winningBets = winningBets;
	}
	public Long getWinningAmountBig() {
		return winningAmountBig;
	}
	public void setWinningAmountBig(Long winningAmountBig) {
		this.winningAmountBig = winningAmountBig;
	}
	public Long getWinningTickets() {
		return winningTickets;
	}
	public void setWinningTickets(Long winningTickets) {
		this.winningTickets = winningTickets;
	}
	public Long getWinningTicketsBig() {
		return winningTicketsBig;
	}
	public void setWinningTicketsBig(Long winningTicketsBig) {
		this.winningTicketsBig = winningTicketsBig;
	}
	public Long getIssueRickAmount() {
		return issueRickAmount;
	}
	public void setIssueRickAmount(Long issueRickAmount) {
		this.issueRickAmount = issueRickAmount;
	}
	public Long getIssueRickTickets() {
		return issueRickTickets;
	}
	public void setIssueRickTickets(Long issueRickTickets) {
		this.issueRickTickets = issueRickTickets;
	}
	public String getWinningResult() {
		return winningResult;
	}
	public void setWinningResult(String winningResult) {
		this.winningResult = winningResult;
	}
	public Long getRewardingErrorCode() {
		return rewardingErrorCode;
	}
	public void setRewardingErrorCode(Long rewardingErrorCode) {
		this.rewardingErrorCode = rewardingErrorCode;
	}
	public String getRewardingErrorMesg() {
		return rewardingErrorMesg;
	}
	public void setRewardingErrorMesg(String rewardingErrorMesg) {
		this.rewardingErrorMesg = rewardingErrorMesg;
	}
}
