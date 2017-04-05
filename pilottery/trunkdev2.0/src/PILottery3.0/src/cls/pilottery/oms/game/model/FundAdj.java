package cls.pilottery.oms.game.model;

import java.util.Date;

import cls.pilottery.common.model.BaseEntity;
/**
 *  调节基金手工调整信息（ADJ_GAME_CHANGE）
 *  
 *  @author Woo
 */
public class FundAdj  extends BaseEntity {

	/**
	 * 
	 */
	private static final long serialVersionUID = -955360003471979618L;
	
	private String adjFlow;		//调整流水
	private Short gameCode;		//游戏编码
	private Long adjAmount;		//变更金额
	private Long adjAmountBefore;//变更前金额
	private Long adjAmountAfter;//变更后金额
	private Integer adjChangeType;//调节基金变更类型（1、期次开奖滚入；2、弃奖滚入；3、期次开奖自动拨出；4、手工拨出到奖池；5、发行费手工拨入调节基金； 6、其他金额手工拨入调节基金；7、期次开奖抹零滚入；8、初始化设置。）
	private String adjDesc;		//变更备注
	private Date adjTime;		//变更时间
	private Long adjAdmin;		//变更人员
	
	public String getAdjFlow() {
		return adjFlow;
	}
	public void setAdjFlow(String adjFlow) {
		this.adjFlow = adjFlow;
	}
	public Short getGameCode() {
		return gameCode;
	}
	public void setGameCode(Short gameCode) {
		this.gameCode = gameCode;
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
	public Integer getAdjChangeType() {
		return adjChangeType;
	}
	public void setAdjChangeType(Integer adjChangeType) {
		this.adjChangeType = adjChangeType;
	}
	public String getAdjDesc() {
		return adjDesc;
	}
	public void setAdjDesc(String adjDesc) {
		this.adjDesc = adjDesc;
	}
	public Date getAdjTime() {
		return adjTime;
	}
	public void setAdjTime(Date adjTime) {
		this.adjTime = adjTime;
	}
	public Long getAdjAdmin() {
		return adjAdmin;
	}
	public void setAdjAdmin(Long adjAdmin) {
		this.adjAdmin = adjAdmin;
	}
	
}
