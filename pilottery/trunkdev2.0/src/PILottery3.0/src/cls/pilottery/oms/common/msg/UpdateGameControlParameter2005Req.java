package cls.pilottery.oms.common.msg;

import java.io.Serializable;

public class UpdateGameControlParameter2005Req implements Serializable {

	private static final long serialVersionUID = -6486385388308832371L;
	private Short gameCode;
	private Long cancelTime;
	private Long countDownTimes;
	private Long branchCenterPayLimited;
	private Long branchCenterCancelLimited;
	private Long commonTellerPayLimited;
	private Long commonTellerCancelLimited;
	
	public Short getGameCode() {
		return gameCode;
	}
	public void setGameCode(Short gameCode) {
		this.gameCode = gameCode;
	}
	public Long getCancelTime() {
		return cancelTime;
	}
	
	public void setCancelTime(Long cancelTime) {
		this.cancelTime = cancelTime;
	}
	public Long getCountDownTimes() {
		return countDownTimes;
	}
	
	public void setCountDownTimes(Long countDownTimes) {
		this.countDownTimes = countDownTimes;
	}
	public Long getBranchCenterPayLimited() {
		return branchCenterPayLimited;
	}
	
	public void setBranchCenterPayLimited(Long branchCenterPayLimited) {
		this.branchCenterPayLimited = branchCenterPayLimited;
	}
	public Long getBranchCenterCancelLimited() {
		return branchCenterCancelLimited;
	}
	public void setBranchCenterCancelLimited(Long branchCenterCancelLimited) {
		this.branchCenterCancelLimited = branchCenterCancelLimited;
	}
	
	public Long getCommonTellerPayLimited() {
		return commonTellerPayLimited;
	}
	public void setCommonTellerPayLimited(Long commonTellerPayLimited) {
		this.commonTellerPayLimited = commonTellerPayLimited;
	}
	
	public Long getCommonTellerCancelLimited() {
		return commonTellerCancelLimited;
	}
	public void setCommonTellerCancelLimited(Long commonTellerCancelLimited) {
		this.commonTellerCancelLimited = commonTellerCancelLimited;
	}
}
