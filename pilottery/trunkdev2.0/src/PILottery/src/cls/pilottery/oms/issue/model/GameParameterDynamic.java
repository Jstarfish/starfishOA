package cls.pilottery.oms.issue.model;

import cls.pilottery.common.model.BaseEntity;
/**
 * 游戏动态参数(GP_DYNAMIC)
 * 
 * @author Woo
 */
public class GameParameterDynamic extends BaseEntity{
	
	/**
	 * 
	 */
	private static final long serialVersionUID = -238034704770001668L;
	
	private Short gameCode; 	  		//GAME_CODE					游戏编码
	private Long singleLineMaxAmount;	//SINGLELINE_MAX_AMOUNT		单行最大倍数
	private Long singleTicketMaxLine;	//SINGLETICKET_MAX_LINE		单票最大投注行数
	private Long singleTicketMaxAmount;	//SINGLETICKET_MAX_AMOUNT	单票最大销售限额（单位分）
	private Long cancelSec; 			//CANCEL_SEC				退票时间
	private Long salerPayLimit;			//SALER_PAY_LIMIT			普通销售员兑奖限额（单位分）
	private Long salerCancelLimit;		//SALER_CANCEL_LIMIT		普通销售员退票限额（单位分）
	private Long issueCloseAlertTime;	//ISSUE_CLOSE_ALERT_TIME	期关闭倒数提醒时间（单位秒）
	private Short isPay;				//IS_PAY					是否可兑奖
	private Short isSale;				//IS_SALE					是否可销售
	private Short isCancel;				//IS_CANCEL					是否可取消
	private Short isAutoDraw;			//IS_AUTO_DRAW				是否自动开奖
	private String serviceTime1;		//SERVICE_TIME_1			游戏每日服务时间段一
	private String serviceTime2;		//SERVICE_TIME_2			游戏每日服务时间段二
	private Long auditSingleTicketSale;	//AUDIT_SINGLE_TICKET_SALE	单票销售金额告警阈值
	private Long auditSingleTicketPay;	//AUDIT_SINGLE_TICKET_PAY	单票兑奖金额告警阈值
	private Long auditSingleTicketCancel;//AUDIT_SINGLE_TICKET_CANCEL	单票退票金额告警阈值
	private String calcWinningCode;		 //CALC_WINNING_CODE		记录每一期的算奖规则
	
	public Short getGameCode() {
		return gameCode;
	}
	public void setGameCode(Short gameCode) {
		this.gameCode = gameCode;
	}
	public Long getSingleLineMaxAmount() {
		return singleLineMaxAmount;
	}
	public void setSingleLineMaxAmount(Long singleLineMaxAmount) {
		this.singleLineMaxAmount = singleLineMaxAmount;
	}
	public Long getSingleTicketMaxLine() {
		return singleTicketMaxLine;
	}
	public void setSingleTicketMaxLine(Long singleTicketMaxLine) {
		this.singleTicketMaxLine = singleTicketMaxLine;
	}
	public Long getSingleTicketMaxAmount() {
		return singleTicketMaxAmount;
	}
	public void setSingleTicketMaxAmount(Long singleTicketMaxAmount) {
		this.singleTicketMaxAmount = singleTicketMaxAmount;
	}
	public Long getCancelSec() {
		return cancelSec;
	}
	public void setCancelSec(Long cancelSec) {
		this.cancelSec = cancelSec;
	}
	public Long getSalerPayLimit() {
		return salerPayLimit;
	}
	public void setSalerPayLimit(Long salerPayLimit) {
		this.salerPayLimit = salerPayLimit;
	}
	public Long getSalerCancelLimit() {
		return salerCancelLimit;
	}
	public void setSalerCancelLimit(Long salerCancelLimit) {
		this.salerCancelLimit = salerCancelLimit;
	}
	public Long getIssueCloseAlertTime() {
		return issueCloseAlertTime;
	}
	public void setIssueCloseAlertTime(Long issueCloseAlertTime) {
		this.issueCloseAlertTime = issueCloseAlertTime;
	}
	public Short getIsPay() {
		return isPay;
	}
	public void setIsPay(Short isPay) {
		this.isPay = isPay;
	}
	public Short getIsSale() {
		return isSale;
	}
	public void setIsSale(Short isSale) {
		this.isSale = isSale;
	}
	public Short getIsCancel() {
		return isCancel;
	}
	public void setIsCancel(Short isCancel) {
		this.isCancel = isCancel;
	}
	public Short getIsAutoDraw() {
		return isAutoDraw;
	}
	public void setIsAutoDraw(Short isAutoDraw) {
		this.isAutoDraw = isAutoDraw;
	}
	public String getServiceTime1() {
		return serviceTime1;
	}
	public void setServiceTime1(String serviceTime1) {
		this.serviceTime1 = serviceTime1;
	}
	public String getServiceTime2() {
		return serviceTime2;
	}
	public void setServiceTime2(String serviceTime2) {
		this.serviceTime2 = serviceTime2;
	}
	public Long getAuditSingleTicketSale() {
		return auditSingleTicketSale;
	}
	public void setAuditSingleTicketSale(Long auditSingleTicketSale) {
		this.auditSingleTicketSale = auditSingleTicketSale;
	}
	public Long getAuditSingleTicketPay() {
		return auditSingleTicketPay;
	}
	public void setAuditSingleTicketPay(Long auditSingleTicketPay) {
		this.auditSingleTicketPay = auditSingleTicketPay;
	}
	public Long getAuditSingleTicketCancel() {
		return auditSingleTicketCancel;
	}
	public void setAuditSingleTicketCancel(Long auditSingleTicketCancel) {
		this.auditSingleTicketCancel = auditSingleTicketCancel;
	}
	public String getCalcWinningCode() {
		return calcWinningCode;
	}
	public void setCalcWinningCode(String calcWinningCode) {
		this.calcWinningCode = calcWinningCode;
	}

}
