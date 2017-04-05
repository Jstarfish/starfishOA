package cls.pilottery.oms.game.model;

import cls.pilottery.common.model.BaseEntity;
/**
 * 游戏控制参数视图(v_gp_control)
 * 
 * @author Woo
 */
public class GameParameterControlView extends BaseEntity{

	/**
	 * 
	 */
	private static final long serialVersionUID = 7092222557865131706L;

	private Short gameCode; 		//GAME_CODE
	private Long limitBigPrize; 	//LIMIT_BIG_PRIZE	大奖金额（单位分）
	private Long limitPayment;		//LIMIT_PAYMENT		游戏兑奖保护限额（单位分）
	private Long limitPayment2;		//LIMIT_PAYMENT2	“二级区域”兑奖金额上限（单位分）
	private Long limitCancel2;		//LIMIT_CANCEL2		“二级区域”退票金额上限（单位分）
	private Long cancelSec;			//CANCEL_SEC	允许退票时间（单位秒）
	private Long salerPayLimit;		//SALER_PAY_LIMIT	普通销售员兑奖限额（单位分）
	private Long salerCancelLimit;	//SALER_CANCEL_LIMIT	普通销售员退票限额（单位分）
	private Long issueCloseAlertTime;	//ISSUE_CLOSE_ALERT_TIME	销售关闭倒数时间（单位秒）
	
	public Short getGameCode() {
		return gameCode;
	}
	public void setGameCode(Short gameCode) {
		this.gameCode = gameCode;
	}
	public Long getLimitBigPrize() {
		return limitBigPrize;
	}
	public void setLimitBigPrize(Long limitBigPrize) {
		this.limitBigPrize = limitBigPrize;
	}
	public Long getLimitPayment() {
		return limitPayment;
	}
	public void setLimitPayment(Long limitPayment) {
		this.limitPayment = limitPayment;
	}
	public Long getLimitPayment2() {
		return limitPayment2;
	}
	public void setLimitPayment2(Long limitPayment2) {
		this.limitPayment2 = limitPayment2;
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
	public Long getLimitCancel2() {
		return limitCancel2;
	}
	public void setLimitCancel2(Long limitCancel2) {
		this.limitCancel2 = limitCancel2;
	}

}
